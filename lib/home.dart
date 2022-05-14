import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfeditor/create.dart';
import 'api/backend.dart' as api;
import 'data/blueprint.dart';
import 'dart:math' as math;

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
        child: SizedBox(
          width: containerWidth,
          child: FutureBuilder(
              future: api.loadProjects(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  // Own widget
                  var projects = jsonDecode(snapshot.data!);
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    itemCount: api.projectsCount,
                    itemBuilder: (context, index) {
                      var project = ProjectBlueprint.fromJson(projects[index]);
                      return Card(
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 5.0),
                          child: Column(
                            children: [
                              Flexible(
                                child: Container(
                                  child: Center(child: Text(project.title)),
                                  color: Color((math.Random().nextDouble() *
                                              0xFFFFFF)
                                          .toInt())
                                      .withOpacity(1.0),
                                ),
                                flex: 1,
                              ),
                              Flexible(
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(project.description),
                                  ),
                                  color: Color((math.Random().nextDouble() *
                                              0xFFFFFF)
                                          .toInt())
                                      .withOpacity(1.0),
                                ),
                                flex: 3,
                              ),
                              Flexible(
                                child: Container(
                                  child: Center(child: Text(project.url)),
                                  color: Color((math.Random().nextDouble() *
                                              0xFFFFFF)
                                          .toInt())
                                      .withOpacity(1.0),
                                ),
                                flex: 1,
                              ),
                              Flexible(
                                child: TextButton(
                                    onPressed: () {
                                      activeProjectId = index;

                                      Navigator.pushNamed(context, '/create');
                                    },
                                    child: const Text("Edit")),
                                flex: 1,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const Center(child: Text("Loading beep boop"));
                }
              }),
        ),
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
