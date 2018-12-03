import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/businessSignUp/businessSignUpThirdPage.dart';

class BusinessSignUpSecondPage extends StatefulWidget {
  final File image;
  final Map<String, String> credentials;

  BusinessSignUpSecondPage({this.image, this.credentials});

  @override
  _BusinessSignUpSecondPageState createState() => _BusinessSignUpSecondPageState();
}

class _BusinessSignUpSecondPageState extends State<BusinessSignUpSecondPage> {
  static GlobalKey<FormState> _form = new GlobalKey<FormState>();
  static GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();


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

    Widget publicationName = TextFormField(
      decoration: new InputDecoration(labelText: 'Name of Publication'),
      keyboardType: TextInputType.text,
      maxLines: 1,
      validator: (input) => input.isEmpty ? 'Name of publication is required.' : null,
      onSaved: (input) => widget.credentials['publicationName'] = input,
    );

    Widget followerCount = TextFormField(
      decoration: new InputDecoration(labelText: 'Follower Count'),
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      textCapitalization: TextCapitalization.none,
      validator: (input) => input.isEmpty ? 'Follower count is required.' : null,
      onSaved: (input) => widget.credentials['followerCount'] = input,
    );

    Widget website = TextFormField(
      decoration: new InputDecoration(labelText: 'Website'),
      keyboardType: TextInputType.url,
      validator: (input) => input.isEmpty ? 'Website is required.' : null,
      onSaved: (input) => widget.credentials['website'] = input,
    );

    Widget shortSummary = TextFormField(
      decoration: new InputDecoration(labelText: 'About - Short summary of your page'),
      keyboardType: TextInputType.multiline,
      validator: (input) => input.isEmpty ? 'Website is required.' : null,
      onSaved: (input) => widget.credentials['shortSummary'] = input,
    );

    Widget additionalNotes = TextFormField(
      decoration: new InputDecoration(labelText: 'Additional Notes'),
      keyboardType: TextInputType.multiline,
      onSaved: (input) => widget.credentials['additionalNotes'] = input,
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
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              child: new Text('Cancel',
                  style: new TextStyle(color: Colors.white)),

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
              onPressed: () {
                if (_validate()) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessSignUpThirdPage(image: widget.image, credentials: widget.credentials)));
                }
              },
              child: new Text('Next',
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
                    "Artists will see these account details, so answer with care.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25.0,
                        color: Color.fromRGBO(255, 160, 0, 1.0)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:5.0, bottom: 10.0),
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      publicationName,
                      followerCount,
                      website,
                      shortSummary,
                      additionalNotes
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