import 'package:flutter/material.dart';

import 'routes.dart';

void main() => runApp(new App());

final themeColor = const Color(0xFF7D27);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: routes,
      initialRoute: '/',
    );
  }
}
