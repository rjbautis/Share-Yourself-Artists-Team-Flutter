import 'login.dart';
import 'role.dart';
import 'home.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

class LaunchPage extends StatefulWidget {
  Role role;

  LaunchPage({this.role});

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  GoogleSignInAccount _user;
  Role _userRole;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      print("inside account ${account.toString()}");

      // TODO: _userRole is always null if the user quits the app (even if _user isn't null anymore).
      // Need to think of a way to store the previous _userRole/widget.role in memory (if possible)
      print("value of _userRole is ${_userRole}");
      setState(() {
        _user = account;
        widget.role = _userRole;
      });
    });
    googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn(Role role) async {
    try {
     // Important! Don't use keyword await for signIn() --> causes error
      googleSignIn.signIn();

      setState(() {
        _userRole = role;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    print("Signed out");

    await googleSignIn.disconnect();

    // Set State of widget by changing Role to NOTSIGNEDIN for login page
    setState(() {
      _userRole = Role.NOTSIGNEDIN;
    });
  }


  @override
  Widget build(BuildContext context) {
    print("The role inside build is ${widget.role}");

    if (_user != null) {
      if (widget.role == Role.BUSINESS) {
        return new HomePage(handleSignOut: _handleSignOut);
      } else {
        print("Test");
        return new HomePage(handleSignOut: _handleSignOut,);
      }
    } else {
      return new LoginPage(handleSignIn: _handleSignIn,);
    }
  }
}
