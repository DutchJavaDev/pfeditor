import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfeditor/create.dart';
import 'api/backend.dart' as api;
import 'data/blueprint.dart';

final RouteObserver<ModalRoute<void>> observer =
    RouteObserver<ModalRoute<void>>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with RouteAware {
  bool hasBeenBuild = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
    _updateListView();
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    _updateListView();
  }

  void _updateListView() async {
    if (!hasBeenBuild) return;
    setState(() {});
  }

  List<Widget> createChildren(double containerWidth) {
    var children = List<Widget>.empty(growable: true);
    double padding = 1;
    for (var i = 0; i < 50; i++) {
      children.add(Row(
        children: [
          SizedBox(
            width: containerWidth / 2,
            height: containerWidth / 4,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Container(
                width: containerWidth / 2 - padding,
                height: containerWidth / 4 - padding,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(child: Text("$i")),
              ),
            ),
          ),
          SizedBox(
            width: containerWidth / 2,
            height: containerWidth / 4,
            child: Padding(
                padding: EdgeInsets.all(padding),
                child: Container(
                  width: containerWidth / 2 - padding,
                  height: containerWidth / 4 - padding,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text("${i * 2}"),
                )),
          )
        ],
      ));
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    var appWidth = MediaQuery.of(context).size.width;
    var containerWidth = appWidth;
    hasBeenBuild = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bonjour"),
      ),
      body: Center(
        child: Hero(
            tag: "landing",
            child: SizedBox(
              width: containerWidth,
              child: FutureBuilder(
                  future: api.loadProject(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      // Own widget
                      var projects = jsonDecode(snapshot.data!);

                      return ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          var project =
                              ProjectBlueprint.fromJson(projects[index]);
                          return Center(child: Text(project.title));
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return const Center(child: Text("Loading beep boop"));
                    }
                  }),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const CreatePage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
