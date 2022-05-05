import 'package:flutter/material.dart';
import 'package:pfeditor/home.dart';

void main() {
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
      body: Hero(tag: "landing", child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: containerWidth,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
                padding: EdgeInsets.only(left: formPadding, right: formPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email *',
                      ),
                      onSaved: (String? value) {},
                      validator: (String? value) {
                        return "";
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        labelText: 'Password *',
                      ),
                      obscureText: true,
                      obscuringCharacter: '*',
                      onSaved: (String? value) {},
                      validator: (String? value) {
                        return "";
                      },
                    ),
                    SizedBox(
                      width: containerWidth,
                      height: 55,
                      child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return const HomePage();
                        }));
                      },
                      child: const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                      ),
                    ),
                    )
                  ],
                ))),
      )),)// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
