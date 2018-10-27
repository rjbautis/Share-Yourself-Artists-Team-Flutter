import 'package:flutter/material.dart';
import 'login.dart';
import 'feedbackpage.dart';
import 'feedbacklist.dart';

void main() => runApp(new MyApp());

  final themeColor = const Color(0xFF7D27);

  class MyApp extends StatelessWidget {
  final routes = {
    '/login': (context) => new LoginPage(),
    '/feedback': (context) => new FeedbackPage(),
    '/feedbacklist': (context) => new FeedbackList(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new FeedbackList(),
      routes: routes,
    );
  }
}

