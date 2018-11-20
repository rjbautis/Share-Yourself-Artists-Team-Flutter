import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  static GlobalKey<FormState> _form = new GlobalKey<FormState>();
  static GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  String _email;

  void _handleReset() async {
    try {
      await Authentication.resetPassword(_email);
      Navigator.of(context).pop();
    } catch (e) {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: new Text('There is no user record corresponding to this email account.'),
        duration: Duration(seconds: 4),
      ));
    }

  }

  @override
  Widget build(BuildContext context) {

    bool _validate() {
      var loginForm = _form.currentState;
      if (loginForm.validate()) {
        loginForm.save();
        return true;
      }
      return false;
    }

    Widget email = TextFormField(
      decoration: new InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.text,
      maxLines: 1,
      validator: (input) {
        if (input.isEmpty) {
          return "Email address is required.";
        }
        if (!input.contains('@')) {
          return "Please enter a valid email address.";
        }
        return null;
      },
      onSaved: (input) => _email = input,
    );

    Widget resetButton = Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ButtonTheme(
            minWidth: 150.0,
            child: new MaterialButton(
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
              child: new Text('Cancel',
                  style: new TextStyle(color: Colors.white)),
            ),
          ),
          ButtonTheme(
            minWidth: 150.0,
            child: new OutlineButton(
              borderSide: BorderSide(color: Colors.black),
              color: Colors.white,
              onPressed: () async {
                if (_validate()) {
                  _handleReset();
                }
              },
              child: new Text('Reset',
                  style: new TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );

    return new Scaffold(
      key: _scaffoldState,
      body: Container(
        padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo.png'),
                  padding: const EdgeInsets.all(20.0),
                ),
                Center(
                  child: new Text(
                    "Reset password.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25.0,
                        color: Color.fromRGBO(255, 160, 0, 1.0)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    "Please enter the email address associated with Share Yourself Artists.",
                    textAlign: TextAlign.center,
                  ),
                ),
                Form(
                  key: _form,
                  child: Center(
                    child: email
                  ),
                ),
                resetButton
              ],
            ),
          ],
        ),
      ),
    );
  }
}

