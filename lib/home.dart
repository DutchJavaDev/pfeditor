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
                        // use grid view
                        itemCount: api.projectsCount,
                        itemBuilder: (context, index) {
                          var project =
                              ProjectBlueprint.fromJson(projects[index]);
                          return Column(
                            children: [
                              Text(project.title),
                              Text(project.description),
                              Text(project.url),
                              TextButton(
                                  onPressed: () {
                                    activeProjectId = index;

                                    Navigator.pushNamed(context, '/create');
                                  },
                                  child: const Text("Edit"))
                            ],
                          );
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
          Navigator.pushNamed(context, '/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
