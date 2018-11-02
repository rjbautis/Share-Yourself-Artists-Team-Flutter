import 'login.dart';
import 'role.dart';
import 'home.dart';
import 'authentication.dart';
import 'artist-upload-image.dart';

import 'package:flutter/material.dart';

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
        setState(() {
          _userRole = Role.BUSINESS;    // TODO:// pass in the user's role from database query
        });
      }
    });
  }

  // If Sign in was successful, change userRole
  void _handleSuccess(String uid) {
    print("Success! Signed in");
    setState(() {
      _userRole = Role.BUSINESS;    // TODO: Rather than hardcoding, need to work with Firebase database plugin
    });
  }


  void _handleSignOut() {
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
        return new HomePage(authentication: widget.authentication, handleSignOut: _handleSignOut);
      } else if (_userRole == Role.ARTIST){
        return new HomePage(authentication: widget.authentication, handleSignOut: _handleSignOut);
      }
    // Otherwise, display login page
    } else {
      return new LoginPage(authentication: widget.authentication, handleSuccess: _handleSuccess);
    }
  }
}
