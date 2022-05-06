import 'package:flutter/material.dart';
import 'data/blueprint.dart';
import 'api/backend.dart' as api;

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePage();
}

class _CreatePage extends State<CreatePage> {
  final _template = ProjectBlueprint("Title", "Des", "Url");
  final _inputFields = ["Title", "Description"];
  late List<TextEditingController> _controllers;
  String _dropDownValue = 'Select a project';

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

  List<Widget> createForm() {
    var children = List<Widget>.empty(growable: true);

    for (var i = 0; i < _inputFields.length; i++) {
      children.add(Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 5),
        child: TextField(
          controller: _controllers[i],
          maxLines: i == 1 ? 12 : 1,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: _inputFields[i],
              alignLabelWithHint: true),
        ),
      ));
    }

    children.add(Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: FutureBuilder<List<String>>(
          future: api.fecthProjects(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              snapshot.data?.insert(0, "Select a project");
              return DropdownButton<String>(
                  value: _dropDownValue,
                  icon: const Icon(Icons.arrow_downward),
                  items: snapshot.data
                      ?.map<DropdownMenuItem<String>>((String str) {
                    return DropdownMenuItem<String>(
                      value: str,
                      child: Text(str),
                      enabled:
                          str.startsWith("Select a project") ? false : true,
                    );
                  }).toList(),
                  onChanged: (String? s) {
                    setState(() {
                      _dropDownValue = s!;
                      _template.url = _dropDownValue.split(" ")[1];
                    });
                  });
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error"));
            } else {
              return const Center(child: Text("Loading"));
            }
          }),
    ));

    children.add(Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 5),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: TextButton(
            child: const Text("Save",
                style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () {
              print(_template.toJson());
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blueGrey),
            ),
          ),
        )));

    return children;
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
            children: createForm(),
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
