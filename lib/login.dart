import 'signup.dart';
import 'authentication.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  final Authentication authentication;
  // Custom callback function for after successful sign in
  final void Function(String) handleSuccess;

  LoginPage({Key key, @required this.authentication, this.handleSuccess}) : super (key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SignUpPage _signup;

  @override
  void initState() {
    super.initState();
    // Need to override SignUpPage
    _signup = SignUpPage();
  }

  @override
  Widget build(BuildContext context) {
    String _email;
    String _password;
    final GlobalKey<FormState> _form = new GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

    _onPressed() {
      print("hi");
    }

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
                icon: new Icon(
                    FontAwesomeIcons.facebook,
                    color: Color.fromRGBO(59, 89, 152, 1.0)
                ),
                onPressed: () => _onPressed
            ),
            new IconButton(
              iconSize: 50.0,
              icon: new Icon(
                  FontAwesomeIcons.google,
                  color: Color.fromRGBO(72, 133, 237, 1.0)
              ),
              onPressed: () async {
                  String uid = await widget.authentication.signInWithGoogleAndFireBase();
                  widget.handleSuccess(uid);
              }
            )
          ],
        )
    );

    Widget email = TextFormField(
      decoration: new InputDecoration(
          labelText: "Email"
      ),
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
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
      validator: (input) => input.isEmpty ? "Password is required." : null,
      onSaved: (input) => _password = input,
    );

    Widget loginButtons = Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new MaterialButton(
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => _signup),
              );
            },
            child: new Text("Sign Up", style: new TextStyle(color: Colors.white)),
          ),
          new MaterialButton (
            color: Colors.white,
            child: new Text('Sign In'),
            onPressed: () async {
              if (_validate()) {
                print("the email is $_email and password is $_password");
                String uid = await widget.authentication.signInWithEmailAndPassword(_email, _password);
                if (uid != "") {
                  widget.handleSuccess(uid);
                } else {
                  _scaffoldState.currentState.showSnackBar(
                    SnackBar(
                      content: new Text('The password is invalid or the user does not have a password. '
                                        'Or you may have not confirmed your email yet. If you need further '
                                        'assistance, please send us an email.'),
                      duration: Duration(seconds: 4),
                    )
                  );
                }
              }
            },
          )
        ],
      ),
    );

    Widget forgotSection = Container(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
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
      key: _scaffoldState,
//      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
        child: ListView(
          children: <Widget>[
            Column (
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
                loginSocialMedia,
                Form (
                  key: _form,       // Remember the state of the filled-in form
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
        )
      ),
    );
  }
}


