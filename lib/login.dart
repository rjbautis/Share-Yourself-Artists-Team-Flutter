import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    _onPressed() {
      print("hi");
    }

    Widget loginSocialMedia = Container(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
//          new Text("Login with"),
          new IconButton(
            iconSize: 50.0,
            icon: new Icon(FontAwesomeIcons.facebook),
            onPressed: _onPressed
          ),
          new IconButton(
            iconSize: 50.0,
            icon: new Icon(FontAwesomeIcons.google),
            onPressed: _onPressed
          )
        ],
      )
    );

    Widget name = TextFormField(
      decoration: new InputDecoration(
        labelText: "Name"
      ),
      keyboardType: TextInputType.text,
      maxLines: 1,
    );

    Widget usernameOrEmail = TextFormField(
      decoration: new InputDecoration(
        labelText: "Username or Email"
      ),
      keyboardType: TextInputType.emailAddress,
    );

    Widget password = TextFormField(
      decoration: new InputDecoration(
        labelText: "Password",
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
    );

    Widget loginButtons = Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new MaterialButton(
            color: Theme.of(context).accentColor,
            onPressed: _onPressed,
            child: new Text("Sign Up"),
          ),
          new MaterialButton (

            color: Theme.of(context).buttonColor,
            onPressed: _onPressed,
            child: new Text('Sign In'),
          )
        ],
      ),
    );

    Widget forgotSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new InkWell(
            child: new Text("Forgot Username"),
            onTap: _onPressed,
          ),
          new InkWell(
            child: new Text("Forgot Password"),
            onTap: _onPressed,
          )
        ],
      )
    );

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
                "Get Your Art Seen Today - guaranteed a response",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25.0),
              ),
            ),
            loginSocialMedia,
            Form (
              child: Column(
                children: <Widget>[
                  name,
                  usernameOrEmail,
                  password,
                ],
              ),
            ),
            loginButtons,
            forgotSection,
          ],
        ),
      ),
    );
  }
}


