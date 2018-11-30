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

  String _name = "";
  int _fc = 0;
  int _pc = 0;
  String _email = "";
  int _join = 0;

  int _nameFlag = 0;
  int _fcFlag = 0;
  int _pcFlag = 0;
  int _emailFlag = 0;
  int _joinFlag = 0;

  Widget _emptyContainer() {
    return new Container(
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Padding(padding: const EdgeInsets.only(top: 0.0)),
        ],
      ),
    );
  }

  Widget _checkNameFlag() {
    if (_nameFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Name: $_name"),
          ],
        ),
      );
    }
    _nameFlag = 0;
    return _emptyContainer();
  }

  Widget _checkFCFlag() {
    if (_fcFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Free Credits: $_fc"),
          ],
        ),
      );
    }
    _fcFlag = 0;
    return _emptyContainer();
  }

  Widget _checkPCFlag() {
    if (_pcFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Paid Credits: $_pc"),
          ],
        ),
      );
    }
    _pcFlag = 0;
    return _emptyContainer();
  }

  Widget _checkEmailFlag() {
    if (_emailFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Email: $_email"),
          ],
        ),
      );
    }
    _emailFlag = 0;
    return _emptyContainer();
  }

  Widget _checkJoinFlag() {
    if (_joinFlag == 0) {
      DateTime upload =
          DateTime.fromMillisecondsSinceEpoch(_join, isUtc: false);
      String dateString = upload.month.toString() +
          '-' +
          upload.day.toString() +
          '-' +
          upload.year.toString();

      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Join Date: $dateString"),
          ],
        ),
      );
    }
    _joinFlag = 0;
    return _emptyContainer();
  }

  bool _isNull(String arg) {
    if (identical(arg, "null") || identical(arg, '') || arg == null) {
      return true;
    }
    return false;
  }

  Widget _buildList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    if (_isNull(snapshot.data.documents[index]['name'])) {
      _nameFlag = 1;
    } else {
      _name = snapshot.data.documents[index]['name'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['free_credits'])) {
      _fcFlag = 1;
    } else {
      _fc = snapshot.data.documents[index]['free_credits'];
    }

    if (_isNull(snapshot.data.documents[index]['credits'])) {
      _pcFlag = 1;
    } else {
      _pc = snapshot.data.documents[index]['credits'];
    }

    if (_isNull(snapshot.data.documents[index]['email'])) {
      _emailFlag = 1;
    } else {
      _email = snapshot.data.documents[index]['email'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['upload_date'])) {
      _joinFlag = 1;
    } else {
      _join = snapshot.data.documents[index]['upload_date'];
    }

    return new Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _checkNameFlag(),
          _checkFCFlag(),
          _checkPCFlag(),
          _checkEmailFlag(),
          _checkJoinFlag(),
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
          title: new Text('My Account'),
          backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
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
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
