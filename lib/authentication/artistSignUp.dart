import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class ArtistSignUpPage extends StatefulWidget {
  @override
  _ArtistSignUpPageState createState() => _ArtistSignUpPageState();
}

class _ArtistSignUpPageState extends State<ArtistSignUpPage> {
  final GlobalKey<FormState> _form = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  Future _handleCreation(Map<String, String> credentials) async {
    String uid = await Authentication.createArtistAccount(credentials);
    if (uid != '') {
      await savePreferences('artist', uid);
      print('Created user is ${uid}');
      Navigator.of(context).pushNamedAndRemoveUntil('/artist', (Route<dynamic> route) => false);

    } else {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: new Text(
            'The email address is already in use by another account.'),
        duration: Duration(seconds: 4),
      ));
    }
  }

  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var credentials =  {
      'name': '',
      'email': '',
      'password': '',
      'instagram': ''
    };

    bool _validate() {
      var loginForm = _form.currentState;

      if (loginForm.validate()) {
        loginForm.save();
        return true;
      }
      return false;
    }

    Widget name = TextFormField(
        decoration: new InputDecoration(labelText: 'Name'),
        keyboardType: TextInputType.text,
        maxLines: 1,
        validator: (input) => input.isEmpty ? 'Name is required.' : null,
        onSaved: (input) => credentials['name'] = input,
    );

    Widget email = TextFormField(
      decoration: new InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      validator: (input) {
        if (input.isEmpty) {
          return 'Email address is required.';
        }
        if (!input.contains('@')) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
      onSaved: (input) => credentials['email'] = input,
    );

    Widget password = TextFormField(
      controller: _confirmPassword,
      decoration: new InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (input) {
        if (input.isEmpty) {
          return 'Password is required.';
        }
        if (input.length < 6) {
          return 'Password must be 6 characters long or more.';
        }
        return null;
      },
      onSaved: (input) => credentials['password'] = input,
    );

    Widget confirmPassword = TextFormField(
      decoration: new InputDecoration(labelText: 'Confirm Password'),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (password) {
        print('password is ${password}');
        print(_confirmPassword);
        if (password != _confirmPassword.text) {
          return 'Passwords do not match.';
        }
      },
//      onSaved: (input) => _password = input,
    );

    Widget instagramField = new TextFormField(
      decoration: new InputDecoration(labelText: 'Instagram (Optional)'),
      keyboardType: TextInputType.url,
      onSaved: (input) => credentials['instagram'] = input,
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
                  await _handleCreation(credentials);
                }
              },
              child: new Text('Sign Up',
                  style: new TextStyle(color: Colors.white)),
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
                    "Get Your Art Seen Today - guaranteed a response.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25.0,
                        color: Color.fromRGBO(255, 160, 0, 1.0)),
                  ),
                ),
                Form(
                  key: _form,
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
