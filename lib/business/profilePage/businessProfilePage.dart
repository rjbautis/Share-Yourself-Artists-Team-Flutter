import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';
import 'package:share_yourself_artists_team_flutter/user/drawer.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';

class BusinessProfilePage extends StatefulWidget {
  @override
  _BusinessProfilePageState createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  String _uid;
  String _photoUrl;

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
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text("Name:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Text("$_name", textAlign: TextAlign.right, style: TextStyle(fontSize: 18.0)),
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
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text("Email:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Text("$_email", textAlign: TextAlign.right, style: TextStyle(fontSize: 18.0)),
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
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text("Publication:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Text("$_publication", textAlign: TextAlign.right, style: TextStyle(fontSize: 18.0)),
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
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text("Follower Count:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Text("$_followers", textAlign: TextAlign.right, style: TextStyle(fontSize: 18.0)),
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
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text("Website:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Text("$_website", textAlign: TextAlign.right, style: TextStyle(fontSize: 18.0)),
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
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("About:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Padding(padding: EdgeInsets.only(right:10.0)),
            new Expanded(
              child: Column(
                children: <Widget>[
                  new Text("$_about", textAlign: TextAlign.right, style: TextStyle(fontSize: 18.0,)),
                ],
              ),
              flex: 3,
            ),
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
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Worth Knowing:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Padding(padding: EdgeInsets.only(right:10.0)),
            new Expanded(
                child: Column(
                  children: <Widget>[
                    new Text("$_wk", textAlign: TextAlign.right, style: TextStyle(fontSize: 18.0)),
                  ],
              ),
              flex: 3,
            ),
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
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Additional Notes:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Padding(padding: EdgeInsets.only(right:10.0)),
            new Expanded(
              child: Column(
                children: <Widget>[
                  new Text("$_addNotes", textAlign: TextAlign.right, style: TextStyle(fontSize: 18.0,)),
                ],
              ),
              flex: 3,
            ),
          ],
        ),
      );
    }
    if (_addFlag == 0) {
      return new Container(
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text("Additional Notes:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Text("$_addNotes", textAlign: TextAlign.right, style: TextStyle(fontSize: 18.0)),
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
        padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text("Joined On:", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0)),
            new Text("$_join", textAlign: TextAlign.right),
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
    return new Container(
        width: 190.0,
        height: 190.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image:  (_photoUrl != '') ? new NetworkImage(_photoUrl) : new Icon(Icons.person)

            )
        )
    );

//    return new Container(
//        margin: const EdgeInsets.all(15.0),
//        padding:
//        const EdgeInsets.only(top: 3.0, bottom: 3.0, right: 3.0, left: 3.0),
//        decoration:
//        new BoxDecoration(border: new Border.all(color: Colors.black)),
//        child: new Column(
//          children: <Widget>[
//            Padding(
//                padding: EdgeInsets.only(
//                    left: 8.0, right: 8.0, top: 25.0, bottom: 20.0),
//                child: new Text("Test Profile",
//                    textAlign: TextAlign.center, style: new TextStyle(fontSize: 20.0))),
//          ],
//        ));
  }

  Widget _buildList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
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

    return new Container(
      child: Column(
        //mainAxisSize: MainAxisSize.min,
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
          _checkEmailFlag(),
          _checkPubFlag(),
          _checkFollowFlag(),
          _checkWebFlag(),
          _checkAboutFlag(),
          _checkWKFlag(),
          _checkAddFlag(),
          _checkJoinFlag(),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),

//          new Padding(padding: const EdgeInsets.only(top: 40.0)),
//          new Text("Join Date: $dateString"),
        ],
      ),
    );
  }
  //}

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
              Navigator.of(context).pushReplacementNamed('/editBusiness');
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
