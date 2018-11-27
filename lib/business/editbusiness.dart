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
  String _email;
  String _facebookUrl;
  String _instagramUrl;
  String _publication;
  String _about;
  String _additionalNotes;
  String _tumblrUrl;
  String _worthKnowing;
  String _theGood;

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

  Widget _buildEditProfile(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    _getProfile();
    return new Card(
      child: TextFormField(
        decoration: InputDecoration(hintText: _businessName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
            title: Text('Edit Profile'),
            backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
            iconTheme: IconThemeData(color: Colors.black)),
        body: new StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .where('userId', isEqualTo: _uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading...');
            return new Container(
                child: ListView.builder(
              itemBuilder: (BuildContext ctxt, int index) =>
                  _buildEditProfile(context, snapshot),
              itemCount: 1,
            ));
          },
        ),
      ),
    );
  }
}
