import 'package:flutter/material.dart';
import 'package:madscientistandthescientists/app_navigator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String key = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (item) {
            key = item;
          },
        ),
        TextButton(onPressed: sendCredentials, child: const Text("SEND"))
      ],
    );
  }

  void sendCredentials() {
    if (key == "") {
      Navigator.pushNamed(context, AppNavigatorRoutes.clubDetail,
          arguments: null);
    }
  }
}
