import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pfeditor/home.dart';
import 'api/backend.dart' as api;
import 'home.dart' as home;

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kReleaseMode) {
      exit(1);
    }
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PfEditor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'PfEditor'),
      navigatorObservers: [home.observer],
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [TextEditingController(), TextEditingController()];
  }

  @override
  Widget build(BuildContext context) {
    var appWidth = MediaQuery.of(context).size.width;
    var containerWidth = appWidth * 0.5;
    var formPadding = containerWidth * 0.185;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Hero(
          tag: "landing",
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: containerWidth,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                    padding:
                        EdgeInsets.only(left: formPadding, right: formPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: _controllers[0],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: 'Email *',
                          ),
                          validator: (String? value) {
                            if (value == null) return "Email cannot be empty";

                            if (!value.contains("@")) {
                              // really hacky solution, use regex
                              return "Not a valid email";
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _controllers[1],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.password),
                            labelText: 'Password *',
                          ),
                          obscureText: true,
                          obscuringCharacter: '*',
                          validator: (String? value) {
                            if (value == null) {
                              return "Password cannot be empty";
                            }

                            if (value.length < 8) return "Password is to short";

                            return null;
                          },
                        ),
                        SizedBox(
                          width: containerWidth,
                          height: 55,
                          child: TextButton(
                            onPressed: () async {
                              if (await api.simulateLogin(
                                  _controllers[0].text, _controllers[1].text)) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const HomePage();
                                }));
                              }
                            },
                            child: const Text("Login",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueGrey),
                            ),
                          ),
                        )
                      ],
                    ))),
          )),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
  }
}
