import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/artist-upload-image.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/login.dart';
import 'package:share_yourself_artists_team_flutter/authentication/role.dart';
import 'package:share_yourself_artists_team_flutter/business/feedbacklist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchPage extends StatefulWidget {
  final Authentication authentication;

  LaunchPage({@required this.authentication});

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Role _userRole;
  String _uid;

  @override
  void initState() {
    super.initState();

    // On init, check if the user had already signed in or not
    widget.authentication.alreadySignedIn().then((isSignedIn) {
      if (isSignedIn) {
        loadRole().then((String role) {
          if (role != '') {
            setState(() {
              _userRole = role == 'business' ? Role.BUSINESS : Role.ARTIST;
            });
          }
        });
        loadUid().then((String uid) {
          if (uid != '') {
            setState(() {
              _uid = uid;
            });
          }
        });
      }
    });
  }

  Future<void> savePreferences(String role, String uid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('role', role);
    await sharedPreferences.setString('uid', uid);
  }

  Future<String> loadRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print('The role saved from disk is ' + sharedPreferences.getString('role'));

    return sharedPreferences.getString('role');
  }

  Future<String> loadUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print('The uid saved from disk is ' + sharedPreferences.getString('uid'));

    return sharedPreferences.getString('uid');
  }

  // If Sign in was successful, change userRole
  void _handleSuccess(String uid) async {
    String role;
    print("Successful authentication. Now trying to verify user in Firestore.");

    role = await widget.authentication.verifyUserDocument(uid);

    await savePreferences(role, uid);

    setState(() {
      _userRole = role == 'business' ? Role.BUSINESS : Role.ARTIST;
      _uid = uid;
    });
  }

  void _handleSignOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('role', '');
    await sharedPreferences.setString('uid', '');


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
        return new FeedbackList(
            uid: _uid,
            authentication: widget.authentication,
            handleSignOut: _handleSignOut);
      } else if (_userRole == Role.ARTIST) {
        return new ArtistUploadImage(
            authentication: widget.authentication,
            handleSignOut: _handleSignOut);
      }
    } else {
      // Otherwise, display login page
      return new LoginPage(
          authentication: widget.authentication, handleSuccess: _handleSuccess);
    }
  }
}
