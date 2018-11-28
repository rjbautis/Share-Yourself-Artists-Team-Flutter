import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class EditBusiness extends StatefulWidget {
  EditBusiness();

  @override
  _EditBusinessState createState() => new _EditBusinessState();
}

class _EditBusinessState extends State<EditBusiness> {
  String _uid;
  String _businessName;
  String _publication;
  String _followerCount;
  String _website;
  String _about;
  String _worthKnowing;
  String _additionalNotes;

  @override
  void initState() {
    super.initState();

    // Grab the saved uid of current user from memory
    loadUid().then((uid) {
      print('init: current uid: ${uid}');
      setState(() {
        _uid = uid;
      });
    });
  }

  Future _getProfile(AsyncSnapshot<QuerySnapshot> snapshot) async {
    setState(() {
      _businessName = snapshot.data.documents[0]['business_name'].toString();
      _publication = snapshot.data.documents[0]['publication'].toString();
      _followerCount = snapshot.data.documents[0]['follower_count'].toString();
      _website = snapshot.data.documents[0]['website'].toString();
      _about = snapshot.data.documents[0]['about'].toString();
      _worthKnowing = snapshot.data.documents[0]['worth_knowing'].toString();
      _additionalNotes =
          snapshot.data.documents[0]['additional_notes'].toString();
    });
  }

  Widget _buildProfile(AsyncSnapshot<QuerySnapshot> snapshot) {
    _getProfile(snapshot);

    return new Column(children: <Widget>[
      TextFormField(
        initialValue: _businessName,
        decoration: InputDecoration(labelText: 'Business Name'),
        onSaved: (input) => setState(() {
              _businessName = input;
            }),
      ),
      TextFormField(
        initialValue: _publication,
        decoration: InputDecoration(labelText: 'Publication'),
        onSaved: (input) => _publication = input,
      ),
      TextFormField(
        initialValue: _followerCount,
        decoration: InputDecoration(labelText: 'Follower Count'),
        onSaved: (input) => _followerCount = input,
      ),
      TextFormField(
        initialValue: _website,
        decoration: InputDecoration(labelText: 'Website'),
        onSaved: (input) => _website = input,
      ),
      TextFormField(
        initialValue: _about,
        maxLines: 8,
        decoration: InputDecoration(labelText: 'About'),
        onSaved: (input) => _about = input,
      ),
      TextFormField(
        initialValue: _worthKnowing,
        maxLines: 3,
        decoration: InputDecoration(labelText: 'Worth Knowing'),
        onSaved: (input) => _worthKnowing = input,
      ),
      TextFormField(
        initialValue: _additionalNotes,
        maxLines: 3,
        decoration: InputDecoration(labelText: 'Additional Notes'),
        onSaved: (input) => _additionalNotes = input,
      ),
    ]);
  }

  Future _updateProfile() async {
    await Firestore.instance.collection('users').document(_uid).updateData({
      'business_name': _businessName,
      'publication': _publication,
      'follower_count': _followerCount,
      'website': _website,
      'about': _about,
      'worth_knowing': _worthKnowing,
      'additional_notes': _additionalNotes
    });

    print('sucessfully updated business profile');
    print(_businessName);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _updateProfile();
                Navigator.pop(context);
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
