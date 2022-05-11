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
    var modalRoute = ModalRoute.of(context);
    if (modalRoute == null) return;
    observer.subscribe(this, modalRoute);
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
    //if (!hasBeenBuild) return;
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
                  future: api.loadProjects(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      // Own widget
                      var projects = jsonDecode(snapshot.data!);
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemCount: api.projectsCount,
                        itemBuilder: (context, index) {
                          var project =
                              ProjectBlueprint.fromJson(projects[index]);
                          return Column(
                            children: [
                              Flexible(child: Text(project.title), flex: 1),
                              Flexible(
                                  child: Text(project.description), flex: 5),
                              Flexible(child: Text(project.url), flex: 3),
                              Flexible(
                                child: TextButton(
                                    onPressed: () {
                                      activeProjectId = index;

                                      Navigator.pushNamed(context, '/create');
                                    },
                                    child: const Text("Edit")),
                                flex: 4,
                              )
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
