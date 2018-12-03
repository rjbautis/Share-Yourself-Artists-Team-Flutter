import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/profilePage/editArtist.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class ArtistProfilePage extends StatefulWidget {
  @override
  _ArtistProfilePageState createState() => _ArtistProfilePageState();
}

class _ArtistProfilePageState extends State<ArtistProfilePage> {
  String _uid;
  String _photoUrl = '';

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
            new Padding(
                padding:
                    const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0)),
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

  Widget _profilePic() {
//    (_photoUrl != '')
////        ? new CircleAvatar(
////            backgroundImage: new NetworkImage(_photoUrl),
////          )
////        : new CircleAvatar(
////            backgroundColor: Colors.white,
////            child: new Icon(Icons.person),
////          );

    return new Container(
        margin: const EdgeInsets.all(15.0),
        padding:
            const EdgeInsets.only(top: 3.0, bottom: 3.0, right: 3.0, left: 3.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.black)),
        child: new Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 25.0, bottom: 20.0),
                child: new Text("Test Profile",
                    textAlign: TextAlign.center, style: new TextStyle())),
          ],
        ));
  }

  Widget _buildList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    if (_isNull(snapshot.data.documents[index]['name'])) {
      _nameFlag = 1;
    } else {
      _name = snapshot.data.documents[index]['name'].toString();
    }

    if (snapshot.data.documents[index]['free_cerdits'] == null) {
      _fcFlag = 1;
    } else {
      _fc = snapshot.data.documents[index]['free_cerdits'];
    }

    if (snapshot.data.documents[index]['credits'] == null) {
      _pcFlag = 1;
    } else {
      _pc = snapshot.data.documents[index]['credits'];
    }

    if (_isNull(snapshot.data.documents[index]['email'])) {
      _emailFlag = 1;
    } else {
      _email = snapshot.data.documents[index]['email'].toString();
    }

    if (snapshot.data.documents[index]['upload_date'] == null) {
      _joinFlag = 1;
    } else {
      _join = snapshot.data.documents[index]['upload_date'];
    }

    print("$_uid");
    print("\n\n --------------- \n\n");
    print("$_name");
    print("\n\n --------------- \n\n");

    return new Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 25.0, bottom: 20.0),
          ),
          _profilePic(),
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
          ),
          new Container(
            height: 1.5,
            color: Colors.grey,
            padding: EdgeInsets.only(top: 10.0, right: 3.0, left: 3.0),
            margin: EdgeInsets.only(right: 25.0, left: 25.0),
          ),
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

    Authentication.getUserInfo().then((userInfo) {
      setState(() {
        _photoUrl = userInfo['photoUrl'];
      });
    });

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
        title: new Image.asset('images/logo.png'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditArtist()),
              );
            },
          ),
        ],
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
