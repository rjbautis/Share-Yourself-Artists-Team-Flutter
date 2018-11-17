import 'package:flutter/material.dart';

class BusinessSignUpPage extends StatefulWidget {
  @override
  _BusinessSignUpPageState createState() => _BusinessSignUpPageState();
}

class _BusinessSignUpPageState extends State<BusinessSignUpPage> {
  @override
  Widget build(BuildContext context) {
    String _name;
    String _email;
    String _password;
    String _instagram;
    final myController = TextEditingController();
    final GlobalKey<FormState> form = new GlobalKey<FormState>();

    _validate() {
      var loginForm = form.currentState;

      if (loginForm.validate()) {
        loginForm.save();
      }

      print("Inside sign up");
      print("${loginForm.validate()}");
      print("$_name");
      print("$_email");
      print("$_password");
      print("$_instagram");
    }

    Widget name = TextFormField(
        decoration: new InputDecoration(labelText: "Name"),
        keyboardType: TextInputType.text,
        maxLines: 1,
        validator: (input) => input.isEmpty ? "Name is required." : null,
        onSaved: (input) => _name = input);

    Widget email = TextFormField(
      decoration: new InputDecoration(labelText: "Email"),
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
      controller: myController,
      decoration: new InputDecoration(
        labelText: "Password",
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (input) => input.isEmpty ? "Password is required." : null,
      onSaved: (input) => _password = input,
    );

    Widget confirmPassword = TextFormField(
      decoration: new InputDecoration(
        labelText: "Confirm Password",
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (password) {
        if (password != myController.text) {
          return "Passwords do not match.";
        }
      },
      onSaved: (input) => _password = input,
    );

    Widget instagramField = new TextFormField(
      decoration: new InputDecoration(
        labelText: "Instagram (LOL Optional)",
      ),
      keyboardType: TextInputType.url,
      obscureText: true,
      onSaved: (input) => _instagram = input,
    );

    Widget loginButtons = Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
//        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new MaterialButton(
            color: Colors.black,
            onPressed: () {
              _validate();
            },
            child:
                new Text("Sign In", style: new TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                    fontSize: 25.0, color: Color.fromRGBO(255, 160, 0, 1.0)),
              ),
            ),
            Form(
              key: form,
              child: Column(
                children: <Widget>[
                  name,
                  email,
                  password,
                  confirmPassword,
                  instagramField
                ],
              ),
            ),
            loginButtons
          ],
        ),
      ),
    );
  }
}
