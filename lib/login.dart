import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SignUpPage _signup;

  @override
  void initState() {
    // Need to override SignUpPage
    // Reference: https://stackoverflow.com/questions/50295726/widget-rebuild-after-textfield-selection-flutter
    _signup = SignUpPage();
  }

  @override
  Widget build(BuildContext context) {
    String _name;
    String _email;
    String _password;
    final GlobalKey<FormState> form= new GlobalKey<FormState>();

    _onPressed() {
      print("hi");
    }

    _validate() {
      var loginForm = form.currentState;

      if (loginForm.validate()) {
        loginForm.save();
      }

      print("Inside login");
      print("${loginForm.validate()}");
      print("$_name");
      print("$_email");
      print("$_password");

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
            onPressed: _onPressed
          ),
          new IconButton(
            iconSize: 50.0,
            icon: new Icon(
              FontAwesomeIcons.google,
              color: Color.fromRGBO(72, 133, 237, 1.0)
            ),
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
      onSaved: (input) => _name = input
    );

    Widget email = TextFormField(
      decoration: new InputDecoration(
        labelText: "Email"
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (input) =>
          !input.contains('@') ? "Please enter a valid email adrress." : null,
      onSaved: (input) => _email = input,
    );

    Widget password = TextFormField(
      decoration: new InputDecoration(
        labelText: "Password",
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
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
            onPressed: _validate,
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
                "Get Your Art Seen Today - guaranteed a response.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Color.fromRGBO(255, 160, 0, 1.0)),
              ),
            ),
            loginSocialMedia,
            Form (
              key: form,       // Remember the state of the filled-in form
              child: Column(
                children: <Widget>[
                  name,
                  email,
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


