import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class BusinessSignUpThirdPage extends StatefulWidget {
  final File image;
  final Map<String, String> credentials;

  BusinessSignUpThirdPage({this.image, this.credentials});

  @override
  _BusinessSignUpThirdPageState createState() =>
      _BusinessSignUpThirdPageState();
}

class _BusinessSignUpThirdPageState extends State<BusinessSignUpThirdPage> {
  static GlobalKey<FormState> _form = new GlobalKey<FormState>();
  static GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  Future _handleCreation(Map<String, String> credentials, File image) async {
    String uid = await Authentication.createBusinessAccount(credentials, image);
    if (uid == 'uploadStorageFailure') {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: new Text(
            'There was a problem with uploading your logo, please try again.',
            style: new TextStyle(color: Colors.white)),
        duration: Duration(seconds: 4),
      ));
    } else if (uid == '') {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: new Text(
            'The email address is already in use by another account.',
            style: new TextStyle(color: Colors.white)),
        duration: Duration(seconds: 4),
      ));
    } else {
      await savePreferences('business', uid);
      print('Created user is $uid');
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/business', (Route<dynamic> route) => false);
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

    Widget facebookUrl = TextFormField(
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'Facebook',
          prefixIcon: new Icon(FontAwesomeIcons.facebook)),
      keyboardType: TextInputType.url,
      onSaved: (input) => widget.credentials['facebook'] = input,
    );

    Widget instagramUrl = TextFormField(
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'Instagram',
          prefixIcon: new Icon(FontAwesomeIcons.instagram)),
      keyboardType: TextInputType.url,
      onSaved: (input) => widget.credentials['instagram'] = input,
    );

    Widget tumblrUrl = TextFormField(
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          labelText: 'Tumblr',
          prefixIcon: new Icon(FontAwesomeIcons.tumblr)),
      keyboardType: TextInputType.url,
      onSaved: (input) => widget.credentials['tumblr'] = input,
    );

    Widget signUpButton = Container(
      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ButtonTheme(
            minWidth: 150.0,
            child: new MaterialButton(
              color: Colors.black,
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('/')),
              child:
                  new Text('Cancel', style: new TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          ButtonTheme(
            minWidth: 150.0,
            child: new OutlineButton(
              borderSide: BorderSide(color: Colors.black),
              color: Colors.white,
              onPressed: () async {
                if (_validate()) {
                  _scaffoldState.currentState.showSnackBar(new SnackBar(
                    duration: new Duration(seconds: 4),
                    content: new Row(
                      children: <Widget>[
                        new CircularProgressIndicator(),
                        new Text("  Signing-Up...")
                      ],
                    ),
                  ));
                  await _handleCreation(widget.credentials, widget.image);
                }
              },
              child:
                  new Text('Done', style: new TextStyle(color: Colors.black)),
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
                    "Share your social media URL",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25.0,
                        color: Color.fromRGBO(255, 160, 0, 1.0)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[facebookUrl, instagramUrl, tumblrUrl],
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
