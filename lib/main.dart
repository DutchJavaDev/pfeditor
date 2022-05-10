import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'components/login.dart';
import 'create.dart';
import 'create.dart' as create;
import 'home.dart' as home;
import 'home.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const App(title: "PfEditor"),
        '/home': (context) => const HomePage(),
        '/create': (context) => const CreatePage(),
      },
      navigatorObservers: [home.observer, create.observer],
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<App> createState() => _AppPageState();
}

class _AppPageState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: const LoginPage());
  }
}
