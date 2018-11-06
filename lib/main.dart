import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';

import 'launch.dart';

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
      home: new LaunchPage(
          authentication:
              new Authentication()), // Pass in new Authentication object
    );
  }
}
