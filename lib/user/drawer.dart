import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String _name = '';
  String _email = '';
  String _photoUrl = '';

  @override
  void initState() {
    super.initState();

    // Save the user's information to use in drawer
    Authentication.getUserInfo().then((userInfo) {
      setState(() {
        _name = userInfo['displayName'];
        _email = userInfo['email'];
        _photoUrl = userInfo['photoUrl'];
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 160, 0, 1.0),
            ),
            accountName: (_name != '') ?
                new Text(_name, style: TextStyle(fontSize: 18.0)) :
                new Text('User', style: TextStyle(fontSize: 17.0)),
            accountEmail: (_email != '') ?
                new Text(_email, style: TextStyle(fontSize: 15.0),) :
                null,
            currentAccountPicture: (_photoUrl != '') ?
                new CircleAvatar(
                  backgroundImage: new NetworkImage(_photoUrl),
                ) :
                new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Icon(Icons.person),
                ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: new Text('Home', style: TextStyle(fontSize: 15.0),),
            onTap: () async {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: new Text('Profile'),
            onTap: () async {
              String _role = await loadRole();
              print('the role is $_role');
              if (_role == 'artist') {
                Navigator.of(context).pushNamed('/artistProfilePage');
              } else if (_role == 'business') {
                Navigator.of(context).pushNamed('/businessProfilePage');
              }
            },
          ),
          Divider(),
          ListTile(
            title: new Text('About Us'),
            onTap: () {
              Navigator.of(context).pushNamed('/about');
            },
          ),
          ListTile(
            title: new Text('Support'),
            onTap: () {
              Navigator.of(context).pushNamed('/support');
            },
          ),
          ListTile(
            leading: Icon(Icons.undo),
            title: new Text('Log Out'),
            onTap: () async {
              await Authentication.signOut();
              resetPreferences();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
