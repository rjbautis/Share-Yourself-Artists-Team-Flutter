import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/artist-upload-image.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';

class ArtistSignUpPage extends StatefulWidget {
  @override
  _ArtistSignUpPageState createState() => _ArtistSignUpPageState();
}

class _ArtistSignUpPageState extends State<ArtistSignUpPage> {
  final GlobalKey<FormState> form = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String _name;
    String _email;
    String _password;
    String _instagram;
    final myController = TextEditingController();

    bool _validate() {
      var loginForm = form.currentState;

      if (loginForm.validate()) {
        loginForm.save();
        return true;
      }
      return false;
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
//      controller: myController,
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
        labelText: "Instagram (Optional)",
      ),
      keyboardType: TextInputType.url,
      obscureText: true,
      onSaved: (input) => _instagram = input,
    );

    Widget signUpButton = Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ButtonTheme(
            child: new MaterialButton(
              color: Colors.black,
              onPressed: () async {
                if (_validate()) {
                  String uid = await Authentication.createArtistAccount(
                      _email, _password);
                  print('uid created is ${uid}');
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => ArtistUploadImage()));
                }
              },
              child: new Text("Sign Up",
                  style: new TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );

    return new Scaffold(
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
                signUpButton
              ],
            ),
          ],
        ),
      ),
    );
  }
}
