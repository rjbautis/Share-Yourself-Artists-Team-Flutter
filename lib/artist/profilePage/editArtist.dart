import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class EditArtist extends StatefulWidget {
  EditArtist();

  @override
  _EditArtistState createState() => new _EditArtistState();
}

class _EditArtistState extends State<EditArtist> {
  static GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  String _uid;
  TextEditingController _artistNameController;
  TextEditingController _instagramController;

  String _artistName;
  String _instagram;

  @override
  void initState() {
    super.initState();

    // Grab the saved uid of current user from memory
    loadUid().then((uid) {
      print('init: current uid: ${uid}');
      setState(() {
        _uid = uid;
      });
      _getProfile();
    });
  }

  Future _getProfile() async {
    DocumentSnapshot artist =
        await Firestore.instance.collection('users').document(_uid).get();
    if (artist.exists) {
      print("exists");
      setState(() {
        _artistName = artist['name'];
        _instagram = artist['instagram'];
      });
    }
  }

  Future onEditArtistNameComplete() async {
    _artistName = _artistNameController.text;
  }

  Future onEditInstagramComplete() async {
    _instagram = _instagramController.text;
  }

  Widget _buildProfile(AsyncSnapshot<QuerySnapshot> snapshot) {
    _artistNameController = new TextEditingController(
        text: snapshot.data.documents[0]['name'].toString());
    _instagramController = new TextEditingController(
        text: snapshot.data.documents[0]['instagram'].toString());

    _artistNameController.addListener(onEditArtistNameComplete);
    _instagramController.addListener(onEditInstagramComplete);

    return new Column(children: <Widget>[
      Container(
        child: Text('Submit Feedback',
            style: new TextStyle(
              fontSize: 25.0,
            )),
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 30.0, bottom: 0.0),
      ),
      TextFormField(
        controller: _artistNameController,
        decoration: InputDecoration(labelText: 'Artist Name'),
      ),
      TextFormField(
        controller: _instagramController,
        decoration: InputDecoration(labelText: 'Instagram'),
      ),
    ]);
  }

  Future _updateProfile() async {
    await Firestore.instance.collection('users').document(_uid).updateData({
      'name': _artistName,
      'instagram': _instagram,
    });

    print('sucessfully updated artist profile');
    print(_artistName);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
          title: new Image.asset('images/logo.png'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _updateProfile();
                _scaffoldState.currentState.showSnackBar(SnackBar(
                  content: new Text('Profile updated'),
                  duration: Duration(seconds: 4),
                  backgroundColor: Colors.green,
                ));
              },
            ),
          ]),
      body: new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('userId', isEqualTo: '${_uid}')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return new Container(
            child: ListView.builder(
              itemBuilder: (BuildContext ctxt, int index) =>
                  _buildProfile(snapshot),
              itemCount: 1,
            ),
          );
        },
      ),
    );
  }
}
