import 'package:flutter/material.dart';
import '../api/backend.dart' as api;

// use stateless instead since ui wont be updating?
//  nvm it will when waiting for network
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _controllers;
  bool _showLoading = false;
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
    return Hero(
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
                    child: Form(
                        key: _formKey,
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
                                if (value == null) {
                                  return "Email cannot be empty";
                                }

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

                                if (value.length < 8) {
                                  return "Password is to short";
                                }

                                return null;
                              },
                            ),
                            SizedBox(
                              width: containerWidth,
                              height: 55,
                              child: TextButton(
                                onPressed: _showLoading
                                    ? null
                                    : () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        setState(() {
                                          _showLoading = true;
                                        });
                                        if (await api.simulateLogin(
                                            _controllers[0].text,
                                            _controllers[1].text)) {
                                          Navigator.pushNamed(context, '/home');
                                        }
                                        // Error mate
                                        setState(() {
                                          _showLoading = false;
                                        });
                                      },
                                child: Center(
                                    child: _showLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.green,
                                          )
                                        : const Text("Login",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white))),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blueGrey),
                                ),
                              ),
                            )
                          ],
                        ))),
              )),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
  }
}
