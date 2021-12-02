import 'package:flutter/material.dart';
import 'package:madscientistandthescientists/app_navigator.dart';
import 'package:madscientistandthescientists/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: AppNavigator()),
    );
  }
}
