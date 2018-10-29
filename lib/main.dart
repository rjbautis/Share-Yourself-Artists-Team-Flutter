import 'launch.dart';
import 'role.dart';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

final themeColor = const Color(0xFF7D27);

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new LaunchPage(role: Role.NOTSIGNEDIN),
    );
  }
}

