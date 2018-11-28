import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class EditBusiness extends StatefulWidget {
  EditBusiness();

  @override
  _EditBusinessState createState() => new _EditBusinessState();
}

class _EditBusinessState extends State<EditBusiness> {
  String _uid;
  String _businessName;
  String _email;
  String _about;
  String _additionalNotes;
  String _worthKnowing;
  String _theGood;
  String _publication;
  String _facebookUrl;
  String _instagramUrl;
  String _tumblrUrl;

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
    _getProfile();
  }

  Future _getProfile() async {
    DocumentSnapshot businessUser =
        await Firestore.instance.collection('users').document(_uid).get();

    setState(() {
      _businessName = businessUser['business_name'];
      _email = businessUser['email'];
      _facebookUrl = businessUser['facebook_url'];
      _instagramUrl = businessUser['instagram_url'];
      _publication = businessUser['publication'];
      _about = businessUser['about'];
      _additionalNotes = businessUser['additional_notes'];
      _tumblrUrl = businessUser['tumblr_url'];
      _worthKnowing = businessUser['worth_knowing'];
      _theGood = businessUser['theGood'];
    });
  }

  void _updateProfile() {

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
          ]
      ),
      body: new Column(children: <Widget>[
        TextFormField(
          initialValue: _businessName,
          decoration: InputDecoration(labelText: 'Business Name'),
          onSaved: (input) => _businessName = input,
        ),
        TextFormField(
          initialValue: _email,
          decoration: InputDecoration(labelText: 'Email'),
          onSaved: (input) => _email = input,
        ),
        TextFormField(
          initialValue: _about,
          maxLines: 8,
          decoration: InputDecoration(labelText: 'About'),
          onSaved: (input) => _about = input,
        ),
        TextFormField(
          initialValue: _additionalNotes,
          maxLines: 3,
          decoration: InputDecoration(labelText: 'Additional Notes'),
          onSaved: (input) => _additionalNotes = input,
        ),
      ]),
    );
  }
}
