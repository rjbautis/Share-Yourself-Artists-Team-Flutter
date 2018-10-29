import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final VoidCallback handleSignOut;

  HomePage({this.handleSignOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(25.0),
        child: Column (
//          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset('images/logo.png'),
              padding: const EdgeInsets.all(20.0),
            ),
            Center (
              child: new Text(
                "Get Your Art Seen Today - guaranteed a response.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 25.0,
                    color: Color.fromRGBO(255, 160, 0, 1.0)),
              ),
            ),
            Center (
              child: RaisedButton(
                child: Text("Log Out"),
                onPressed: () => widget.handleSignOut()
              )
            )
          ],
        ),
      ),
    );
  }
}
