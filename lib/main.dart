import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(new MyApp());

  class MyApp extends StatelessWidget {
  final routes = {
    '/login': (context) => new LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
      routes: routes,
    );
  }
}

