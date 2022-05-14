import 'package:flutter/material.dart';
import 'data/blueprint.dart';
import 'api/backend.dart' as api;

var activeProjectId = -1;
final RouteObserver<ModalRoute<void>> observer =
    RouteObserver<ModalRoute<void>>();

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePage();
}

class _CreatePage extends State<CreatePage> with RouteAware {
  var _template = ProjectBlueprint("Title", "Des", "Url");
  final _inputFields = ["Title", "Description"];
  late List<TextEditingController> _controllers;
  String _dropDownValue = '';

  @override
  void initState() {
    super.initState();
    _controllers = [
      TextEditingController(),
      TextEditingController(),
    ];

    for (var i = 0; i < _controllers.length; i++) {
      var controller = _controllers[i];
      controller.addListener(() {
        final text = controller.text;
        switch (i) {
          case 0:
            _template.title = text;
            break;

          case 1:
            _template.description = text;
            break;

          default:
            break;
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var modalRoute = ModalRoute.of(context);
    if (modalRoute == null) return;
    observer.subscribe(this, modalRoute);
  }

  @override
  void didPopNext() {
    _updateProject();
  }

  @override
  void didPush() {
    _updateProject();
  }

  @override
  void didPop() {
    activeProjectId = -1;
    ScaffoldMessenger.of(context).clearMaterialBanners();
  }

  @override
  void didPushNext() {}

  void _updateProject() {
    if (activeProjectId == -1) return;

    _template = api.getByID(activeProjectId) ?? ProjectBlueprint("", "", "");

    _controllers[0].text = _template.title;
    _controllers[1].text = _template.description;
    // fix url?_controllers[2].text = _template.url;

    setState(() {});
  }

  void clearInput() {
    for (var controller in _controllers) {
      controller.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var appWidth = MediaQuery.of(context).size.width;
    var containerWidth = appWidth;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Create"),
        ),
        body: Center(
            child: SizedBox(
          width: containerWidth / 2,
          child: Column(
            children: [
              for (var i = 0; i < _inputFields.length; i++)
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                  child: TextField(
                    controller: _controllers[i],
                    maxLines: i == 1 ? 12 : 1,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: _inputFields[i],
                        alignLabelWithHint: true),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 5),
                child: FutureBuilder<List<String>>(
                    future: api.fecthProjects(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasData) {
                        _dropDownValue =
                            snapshot.data![0].split(api.GithubSeparator)[0];

                        return DropdownButton<String>(
                            icon: const Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Icon(Icons.arrow_downward)),
                            hint: const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text("Project",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))),
                            items: snapshot.data
                                ?.map<DropdownMenuItem<String>>((String data) {
                              var arr = data.split(api.GithubSeparator);
                              var cv = arr[1];
                              var v = arr[0];
                              return DropdownMenuItem<String>(
                                value: cv,
                                child: Text(v),
                              );
                            }).toList(),
                            onChanged: (String? s) {
                              if (s == null) return;
                              setState(() {
                                _dropDownValue = s;
                                _template.url = s;
                              });
                            });
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("Error"));
                      } else {
                        return const Center(child: Text("Loading"));
                      }
                    }),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: TextButton(
                      child: const Text("Save",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      onPressed: () {
                        api.saveProject(_template.toJson(), activeProjectId);

                        ScaffoldMessenger.of(context).showMaterialBanner(
                            MaterialBanner(
                                elevation: 1.0,
                                content: Text(
                                    "${_controllers[0].text} has been saved!",
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white)),
                                padding: const EdgeInsets.all(20),
                                backgroundColor: Colors.green,
                                actions: [
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .clearMaterialBanners();
                                },
                                child: const Text("DISMISS"),
                              )
                            ]));

                        clearInput();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueGrey),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: TextButton(
                      child: const Text("Delete",
                          style: TextStyle(fontSize: 18, color: Colors.red)),
                      onPressed: activeProjectId <= -1
                          ? null
                          : () {
                              api.deleteById(activeProjectId);
                              clearInput();
                              ScaffoldMessenger.of(context).showMaterialBanner(
                                  MaterialBanner(
                                      content: const Text(
                                          "Project has been deleted",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white)),
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: Colors.green,
                                      actions: [
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .clearMaterialBanners();
                                      },
                                      child: const Text("DISMISS"),
                                    )
                                  ]));
                            },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                      ),
                    ),
                  ))
            ],
          ),
        )));
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
}
