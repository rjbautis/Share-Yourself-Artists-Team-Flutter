import 'login.dart';
import 'role.dart';
import 'authentication.dart';
import 'feedbacklist.dart';
import 'artist-upload-image.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchPage extends StatefulWidget {
  final Authentication authentication;

  LaunchPage({@required this.authentication});

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Role _userRole;

  @override
  void initState() {
    super.initState();

    // On init, check if the user had already signed in or not
    widget.authentication.alreadySignedIn().then((isSignedIn) {
      if (isSignedIn) {

        loadPreferences().then((String role) {
          if (role != '') {
            setState(() {
              _userRole = role == 'business' ? Role.BUSINESS : Role.ARTIST;
            });
          }
        });
      }
    });
  }

  Future<void> savePreferences(String role) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('role', role);
  }

  Future<String> loadPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print('the role saved from disk is ' + sharedPreferences.getString('role'));

    return sharedPreferences.getString('role');
  }

  // If Sign in was successful, change userRole
  void _handleSuccess(String uid) async {
    String role;
    print("Successful authentication. Now trying to verify user in Firestore.");

    role = await widget.authentication.verifyUserDocument(uid);

    await savePreferences(role);

    setState(() {
      _userRole = role == 'business' ? Role.BUSINESS : Role.ARTIST;
    });
  }


  void _handleSignOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('role', '');

    // Set state of widget by changing Role back to null for login page
    setState(() {
      _userRole = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    print("The role inside build is ${_userRole}");

    // If the user has an associated role, then display the appropriate page
    if (_userRole != null) {
      if (_userRole == Role.BUSINESS) {
        return new FeedbackList(authentication: widget.authentication, handleSignOut: _handleSignOut);
      } else if (_userRole == Role.ARTIST){
        return new ArtistUploadImage(authentication: widget.authentication, handleSignOut: _handleSignOut);

      }
    // Otherwise, display login page
    } else {
      return new LoginPage(authentication: widget.authentication, handleSuccess: _handleSuccess);
    }
  }
}
