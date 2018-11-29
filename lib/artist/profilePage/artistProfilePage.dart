import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class ArtistProfilePage extends StatefulWidget {
  @override
  _ArtistProfilePageState createState() => _ArtistProfilePageState();
}

class _ArtistProfilePageState extends State<ArtistProfilePage> {
  String _uid;

  Widget _buildList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    String _name = snapshot.data.documents[index]['name'].toString();
    int _fc = snapshot.data.documents[index]['free_credits'];
    int _pc = snapshot.data.documents[index]['credits'];
    String _email = snapshot.data.documents[index]['email'].toString();
    int _join = snapshot.data.documents[index]['upload_date'];


    print(snapshot.data.documents[index].toString());



    print("\n\n-------------\n\n");
    print("$_name");
    print("\n\n-------------\n\n");

    DateTime upload = DateTime.fromMillisecondsSinceEpoch(_join, isUtc: false);
    String dateString = upload.month.toString() +
        '-' +
        upload.day.toString() +
        '-' +
        upload.year.toString();

    return new Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Padding(padding: const EdgeInsets.only(top: 40.0)),
          new Text("Name: $_name"),
          new Padding(padding: const EdgeInsets.only(top: 40.0)),
          new Text("Free Credits: $_fc"),
          new Padding(padding: const EdgeInsets.only(top: 40.0)),
          new Text("Paid Credits: $_pc"),
          new Padding(padding: const EdgeInsets.only(top: 40.0)),
          new Text("Email:  $_email"),
          new Padding(padding: const EdgeInsets.only(top: 40.0)),
          new Text("Join Date: $dateString"),
        ],
      ),
    );
  }
  //}

  @override
  void initState() {
    super.initState();

    // Grab the saved uid of current user from memory
    loadUid().then((uid) {
      print('init: current uid: $uid');
      setState(() {
        _uid = uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('View Profile'),
          backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 160, 0, 1.0),
                ),
                accountName: new Text('Artist'),
                accountEmail: new Text('gmail.com'),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Text('T'),
                ),
              ),
              ListTile(
                title: new Text('View Profile'),
                onTap: () async {
                  Navigator.of(context).pushNamed('/artistProfilePage');
                },
              ),
              ListTile(
                title: new Text('Log Out'),
                onTap: () async {
                  await Authentication.signOut();
                  resetPreferences();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .where('userId', isEqualTo: '$_uid')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading...');
            return new Container(
              child: ListView.builder(
                itemBuilder: (BuildContext ctxt, int index) =>
                    _buildList(context, snapshot, index),
                itemCount: snapshot.data.documents.length,
              ),
            );
          },
        ),
    );
  }
}
