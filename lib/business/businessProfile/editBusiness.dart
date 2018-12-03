import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class EditBusiness extends StatefulWidget {
  EditBusiness();

  @override
  _EditBusinessState createState() => new _EditBusinessState();

  Future getData(String uid) async => await _EditBusinessState()._getData(uid);
  String getBusinessName() => _EditBusinessState()._businessName;
}

class _EditBusinessState extends State<EditBusiness> {
  static GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  String _uid;
  TextEditingController _businessNameController;
  TextEditingController _publicationController;
  TextEditingController _followerCountController;
  TextEditingController _websiteController;
  TextEditingController _aboutController;
  TextEditingController _worthKnowingController;
  TextEditingController _additionalNotesController;

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
        _getData(_uid);
      });
    });
  }

  Future _getData(String uid) async {
    DocumentSnapshot business =
        await Firestore.instance.collection('users').document(uid).get();

    _businessName = business['business_name'];
    _publication = business['publication'];
    _followerCount = business['follower_count'];
    _website = business['website'];
    _about = business['about'];
    _worthKnowing = business['worth_knowing'];
    _additionalNotes = business['additional_notes'];
  }

  Future onEditBusinessNameComplete() async {
    _businessName = _businessNameController.text;
  }

  Future onEditPublicationComplete() async {
    _publication = _publicationController.text;
  }

  Future onEditFollowerCountComplete() async {
    _followerCount = _followerCountController.text;
  }

  Future onEditWebsiteComplete() async {
    _website = _websiteController.text;
  }

  Future onEditAboutComplete() async {
    _about = _aboutController.text;
  }

  Future onEditWorthKnowingComplete() async {
    _worthKnowing = _worthKnowingController.text;
  }

  Future onEditAdditionalNotesComplete() async {
    _additionalNotes = _additionalNotesController.text;
  }

  Widget _buildProfile(AsyncSnapshot<QuerySnapshot> snapshot) {
    _businessNameController = new TextEditingController(
        text: snapshot.data.documents[0]['business_name'].toString());
    _publicationController = new TextEditingController(
        text: snapshot.data.documents[0]['publication'].toString());
    _followerCountController = new TextEditingController(
        text: snapshot.data.documents[0]['follower_count'].toString());
    _websiteController = new TextEditingController(
        text: snapshot.data.documents[0]['website'].toString());
    _aboutController = new TextEditingController(
        text: snapshot.data.documents[0]['about'].toString());
    _worthKnowingController = new TextEditingController(
        text: snapshot.data.documents[0]['worth_knowing'].toString());
    _additionalNotesController = new TextEditingController(
        text: snapshot.data.documents[0]['additional_notes'].toString());

    _businessNameController.addListener(onEditBusinessNameComplete);
    _publicationController.addListener(onEditPublicationComplete);
    _followerCountController.addListener(onEditFollowerCountComplete);
    _websiteController.addListener(onEditWebsiteComplete);
    _aboutController.addListener(onEditAboutComplete);
    _worthKnowingController.addListener(onEditWorthKnowingComplete);
    _additionalNotesController.addListener(onEditAdditionalNotesComplete);

    return new Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: <Widget>[
          Container(
            child: Text('Edit Profile',
                style:
                    new TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600)),
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
          ),
          TextFormField(
            controller: _businessNameController,
            decoration: InputDecoration(labelText: 'Business Name'),
          ),
          TextFormField(
            controller: _publicationController,
            decoration: InputDecoration(labelText: 'Publication'),
          ),
          TextFormField(
            controller: _followerCountController,
            decoration: InputDecoration(labelText: 'Follower Count'),
          ),
          TextFormField(
            controller: _websiteController,
            decoration: InputDecoration(labelText: 'Website'),
          ),
          TextFormField(
            controller: _aboutController,
            maxLines: 8,
            decoration: InputDecoration(labelText: 'About'),
          ),
          TextFormField(
            controller: _worthKnowingController,
            maxLines: 3,
            decoration: InputDecoration(labelText: 'Worth Knowing'),
          ),
          TextFormField(
            controller: _additionalNotesController,
            maxLines: 3,
            decoration: InputDecoration(labelText: 'Additional Notes'),
          ),
        ]));
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
                  content: new Text('Profile updated',
                      style: new TextStyle(color: Colors.black)),
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
          if (!snapshot.hasData)
            return new Text('Loading...',
                style: new TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600));
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
