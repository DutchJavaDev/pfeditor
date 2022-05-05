import 'package:flutter/material.dart';
import 'data/blueprint.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePage();
}

class _CreatePage extends State<CreatePage> {
  final _template = ProjectBlueprint("TTitle", "Des", "Url");

  List<Widget> createForm() {
    var children = List<Widget>.empty(growable: true);

    // Title, Description, GitHub URL fields
    children.add(const Padding(
      padding: EdgeInsets.only(top: 15, bottom: 5),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Title',
        ),
      ),
    ));

    children.add(const Padding(
      padding: EdgeInsets.only(top: 15, bottom: 5),
      child: TextField(
        maxLines: 12,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
          labelText: 'Description',
        ),
      ),
    ));

    children.add(const Padding(
      padding: EdgeInsets.only(top: 15, bottom: 5),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Github URL',
        ),
      ),
    ));

    children.add(Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 5),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: TextButton(
            child: const Text("Save",
                style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () {},
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
}
