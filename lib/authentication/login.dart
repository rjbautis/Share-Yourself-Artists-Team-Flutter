import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

import 'authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static GlobalKey<FormState> _form = new GlobalKey<FormState>();
  static GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  // Determines which flow to push after successful login
  void _navigateToRoute(String role) {
    if (role == 'business') {
      Navigator.of(context).pushReplacementNamed('/business');
    }
    if (role == 'artist') {
      Navigator.of(context).pushReplacementNamed('/artist');
    }
  }

  Future _handleLogin(String uid) async {
    if (uid != '') {
      String role = await Authentication.readUserDocument(uid);
      await savePreferences(role, uid);
      _navigateToRoute(role);
    } else {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: new Text(
            'The password is invalid or the user does not have a password. '
                'Or you may have not confirmed your email yet. If you need further '
                'assistance, please send us an email.',
          style: new TextStyle(color: Colors.white)),
        duration: Duration(seconds: 4),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    // On init, check if the user had already signed in or not
    Authentication.alreadySignedIn().then((isSignedIn) {
      if (isSignedIn) {
        loadRole().then((String role) {
          _navigateToRoute(role);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String _email;
    String _password;

    bool _validate() {
      var loginForm = _form.currentState;
      if (loginForm.validate()) {
        loginForm.save();
        return true;
      }
      return false;
    }

    Widget loginSocialMedia = Container(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new IconButton(
                iconSize: 50.0,
                icon: new Icon(FontAwesomeIcons.facebook,
                    color: Color.fromRGBO(59, 89, 152, 1.0)),
                onPressed: () async {
                  String uid = await Authentication.signInWithFacebookAndFireBase();
                  await _handleLogin(uid);
                }),
            new IconButton(
                iconSize: 50.0,
                icon: new Icon(FontAwesomeIcons.google,
                    color: Color.fromRGBO(72, 133, 237, 1.0)),
                onPressed: () async {
                  String uid =
                  await Authentication.signInWithGoogleAndFireBase();
                  await _handleLogin(uid);
                })
          ],
        ));

    Widget email = TextFormField(
      decoration: new InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      style: new TextStyle(color: Colors.black),
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

    Widget password = TextFormField(
      decoration: new InputDecoration(
        labelText: "Password",
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
        style: new TextStyle(color: Colors.black),
      validator: (input) => input.isEmpty ? "Password is required." : null,
      onSaved: (input) => _password = input,
    );

    Widget loginButtons = Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
      child: Column(
        children: <Widget>[
          ButtonTheme(
            minWidth: 150.0,
            child: new OutlineButton(
              borderSide: BorderSide(color: Colors.black),
              color: Colors.white,
              onPressed: () async {
                _scaffoldState.currentState.showSnackBar(
                    new SnackBar(duration: new Duration(seconds: 4), content:
                    new Row(
                      children: <Widget>[
                        new CircularProgressIndicator(),
                        new Text("  Signing-In...", style: new TextStyle(color: Colors.white))
                      ],
                    ),
                    ));
                if (_validate()) {
                  print("the email is $_email and password is $_password");
                  String uid = await Authentication.signInWithEmailAndPassword(
                      _email, _password);
                  await _handleLogin(uid);
                }
              },
              child: new Text('Sign In'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          ButtonTheme(
            minWidth: 150.0,
            child: new MaterialButton(
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pushNamed('/artistSignUp');
              },
              child: new Text("Artist Sign Up",
                  style: new TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          ButtonTheme(
            minWidth: 150.0,
            child: new MaterialButton(
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pushNamed('/businessSignUpFirst');
              },
              child: new Text("Business Sign Up",
                  style: new TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );

    Widget forgotSection = Container(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            new InkWell(
//              child: new Text("Forgot Email"),
//              onTap: _onPressed,
//            ),
            new InkWell(
              child: new Text("Forgot Password", style: new TextStyle(color: Colors.black)),
              onTap: () => Navigator.of(context).pushNamed('/forgotPassword'),
            )
          ],
        ));

    return new Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.white,
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
                      "Get Your Art Seen Today - guaranteed a response.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 25.0,
                          color: Color.fromRGBO(255, 160, 0, 1.0)),
                    ),
                  ),
                  loginSocialMedia,
                  Form(
                    key: _form, // Remember the state of the filled-in form
                    child: Column(
                      children: <Widget>[
                        email,
                        password,
                      ],
                    ),
                  ),
                  loginButtons,
                  forgotSection,
                ],
              ),
            ],
          )),
    );
  }
}
