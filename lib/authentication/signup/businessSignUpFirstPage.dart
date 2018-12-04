import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_yourself_artists_team_flutter/authentication/signup/businessSignUpSecondPage.dart';

class BusinessSignUpFirstPage extends StatefulWidget {
  @override
  _BusinessSignUpFirstPageState createState() =>
      _BusinessSignUpFirstPageState();
}

class _BusinessSignUpFirstPageState extends State<BusinessSignUpFirstPage> {
  static GlobalKey<FormState> _form = new GlobalKey<FormState>();
  static GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  File _current;
  File galleryFile;

  bool imagePicked = false;

  final _confirmPassword = TextEditingController();

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    print("You selected gallery image : " + galleryFile.path);
    setState(() {
      _current = galleryFile;
      imagePicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var credentials = {
      'name': '',
      'email': '',
      'password': '',
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
      decoration: new InputDecoration(labelText: 'Business Name'),
      keyboardType: TextInputType.text,
      maxLines: 1,
      style: new TextStyle(color: Colors.black),
      validator: (input) => input.isEmpty ? 'Name is required.' : null,
      onSaved: (input) => credentials['name'] = input,
    );

    Widget email = TextFormField(
      decoration: new InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      style: new TextStyle(color: Colors.black),
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
      style: new TextStyle(color: Colors.black),
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
      style: new TextStyle(color: Colors.black),
      validator: (password) {
        print('password is ${password}');
        if (password != _confirmPassword.text) {
          return 'Passwords do not match.';
        }
      },
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
              onPressed: () => Navigator.of(context).pop(),
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
              onPressed: () {
                if (_validate()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusinessSignUpSecondPage(
                                image: _current,
                                credentials: credentials,
                              )));
                }
              },
              child:
                  new Text('Next', style: new TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );

    Widget uploadLogoButton = Container(
      padding: const EdgeInsets.only(top: 40.0, bottom: 25.0),
      child: new MaterialButton(
        child: new Text('Upload Logo from Gallery'),
        color: Color.fromRGBO(255, 160, 0, 1.0),
        textColor: Colors.white,
        elevation: 4.0,
        onPressed: imageSelectorGallery,
        minWidth: 200.0,
        height: 50.0,
      ),
    );

    Widget displaySelectedFile(File file) {
      return new ConstrainedBox(
        constraints: new BoxConstraints(
            minWidth: 200.0,
            minHeight: 200.0,
            maxWidth: 200.0,
            maxHeight: 200.0),
        child: file == null
            ? new Text('Sorry nothing selected!!')
            : new Image.file(file),
      );
    }

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
                    "Get Paid Today with Share Yourself Artists's easy to use platform.",
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
                    children: <Widget>[
                      name,
                      email,
                      password,
                      confirmPassword,
                      uploadLogoButton,
                      imagePicked
                          ? displaySelectedFile(_current)
                          : new Container(),
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
