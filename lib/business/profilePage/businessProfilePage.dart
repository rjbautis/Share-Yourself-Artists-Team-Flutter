import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';
import 'package:share_yourself_artists_team_flutter/user/drawer.dart';

class BusinessProfilePage extends StatefulWidget {
  @override
  _BusinessProfilePageState createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  String _uid;

  String _name = "";
  String _email = "";
  String _publication = "";
  String _followers = "";
  String _website = "";
  String _about = "";
  String _wk = "";
  String _addNotes = "";
  String _join = "";

  int _nameFlag = 0;
  int _emailFlag = 0;
  int _pubFlag = 0;
  int _followFlag = 0;
  int _webFlag = 0;
  int _aboutFlag = 0;
  int _wkFlag = 0;
  int _addFlag = 0;
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

  Widget _checkPubFlag() {
    if (_pubFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Publication: $_publication"),
          ],
        ),
      );
    }
    _pubFlag = 0;
    return _emptyContainer();
  }

  Widget _checkFollowFlag() {
    if (_followFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Follower Count:  $_followers"),
          ],
        ),
      );
    }
    _followFlag = 0;
    return _emptyContainer();
  }

  Widget _checkWebFlag() {
    if (_webFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Website: $_website"),
          ],
        ),
      );
    }
    _webFlag = 0;
    return _emptyContainer();
  }

  Widget _checkAboutFlag() {
    if (_aboutFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("About: $_about"),
          ],
        ),
      );
    }
    _aboutFlag = 0;
    return _emptyContainer();
  }

  Widget _checkWKFlag() {
    if (_wkFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Worth Knowing: $_wk"),
          ],
        ),
      );
    }
    _wkFlag = 0;
    return _emptyContainer();
  }

  Widget _checkAddFlag() {
    if (_addFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Additional Notes: $_addNotes"),
          ],
        ),
      );
    }
    _addFlag = 0;
    return _emptyContainer();
  }

  Widget _checkJoinFlag() {
    if (_joinFlag == 0) {
      return new Container(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 40.0)),
            new Text("Joined On: $_join"),
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
//    int _join = snapshot.data.documents[index]['joined_on'];

    if (_isNull(snapshot.data.documents[index]['business_name'])) {
      _nameFlag = 1;
    } else {
      _name = snapshot.data.documents[index]['business_name'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['email'])) {
      _emailFlag = 1;
    } else {
      _email = snapshot.data.documents[index]['email'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['publication'])) {
      _pubFlag = 1;
    } else {
      _publication = snapshot.data.documents[index]['publication'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['follower_count'])) {
      _followFlag = 1;
    } else {
      _followers = snapshot.data.documents[index]['follower_count'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['website'])) {
      _webFlag = 1;
    } else {
      _website = snapshot.data.documents[index]['website'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['about'])) {
      _aboutFlag = 1;
    } else {
      _about = snapshot.data.documents[index]['about'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['worth_knowing'])) {
      _wkFlag = 1;
    } else {
      _wk = snapshot.data.documents[index]['worth_knowing'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['additional_notes'])) {
      _addFlag = 1;
    } else {
      _addNotes = snapshot.data.documents[index]['additional_notes'].toString();
    }

    if (_isNull(snapshot.data.documents[index]['upload_date'])) {
      _joinFlag = 1;
    } else {
      _join = snapshot.data.documents[index]['upload_date'].toString();
    }

    print("\n\n-------------\n\n");
    print("$_join");
    print("$_joinFlag");

    print("\n\n-------------\n\n");

//    DateTime upload = DateTime.fromMillisecondsSinceEpoch(_join, isUtc: false);
//    String dateString = upload.month.toString() +
//        '-' +
//        upload.day.toString() +
//        '-' +
//        upload.year.toString();

    return new Container(
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          _checkNameFlag(),
          _checkEmailFlag(),
          _checkPubFlag(),
          _checkFollowFlag(),
          _checkWebFlag(),
          _checkAboutFlag(),
          _checkWKFlag(),
          _checkAddFlag(),
          _checkJoinFlag(),

//          new Padding(padding: const EdgeInsets.only(top: 40.0)),
//          new Text("Join Date: $dateString"),
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
          title: new Text('View Business Profile'),
          backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
        ),
        drawer: NavDrawer(),
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
