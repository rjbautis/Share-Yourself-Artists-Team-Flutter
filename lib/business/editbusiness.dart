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
  String _business_name;

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

  Widget _buildEditProfile(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    String businessName = snapshot.data.documents[0]['business_name'].toString();
    String email = snapshot.data.documents[0]['email'].toString();
    String facebookUrl = snapshot.data.documents[0]['facebook_url'].toString();
    String instagramUrl = snapshot.data.documents[0]['instagram_url'].toString();
    String publication = snapshot.data.documents[0]['publication'].toString();
    String about = snapshot.data.documents[0]['about'].toString();
    String additionalNotes = snapshot.data.documents[0]['additional_notes'].toString();
    String tumblrUrl = snapshot.data.documents[0]['tumblr_url'].toString();
    String worthKnowing = snapshot.data.documents[0]['worth_knowing'].toString();
    String theGood = snapshot.data.documents[0]['theGood'].toString();

    return new Card(
      child: TextFormField (
        decoration: InputDecoration(
          hintText: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
          iconTheme: IconThemeData(color: Colors.black)
        ),
        body: new StreamBuilder(
          stream: Firestore.instance.collection('users')
              .where('userId', isEqualTo: _uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading...');
            return new Container(
              child: ListView.builder(
                itemBuilder: (BuildContext ctxt, int index) =>
                    _buildEditProfile(context, snapshot),
                itemCount: 1,
              )
            );
          },
        ),
      ),
    );
  }
}
