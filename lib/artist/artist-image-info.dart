import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class ArtistImageInfo extends StatefulWidget{
//  final Authentication authentication;
//  final VoidCallback handleSignOut;
//  final String uid;

    final File image;
    final String uid;
    final String fileName;

//  ArtistImageInfo({@required this.authentication, this.handleSignOut, this.uid});

  ArtistImageInfo({Key key, this.image, this.uid, this.fileName}) : super(key: key);

  @override
  _ArtistImageInfoState createState() => _ArtistImageInfoState();
}

class _ArtistImageInfoState extends State<ArtistImageInfo> with TickerProviderStateMixin{
  static GlobalKey<FormState> form = new GlobalKey<FormState>();
  static GlobalKey _globalKey = new GlobalKey();
  Animation _animation;
  AnimationController _controller;

  double _width = double.infinity;

  String location = "";
  String downloadURL = "";

  //Parameters for database
  String artTitle = ""; //Prompt this
  String artistId = "";
  String artistName = ""; //Prompt this
  String description = ""; //Prompt this
  int uploadDate = 0;

  int _state = 0;

  bool _didItWork = false;
  bool done = false;

  _setDate()
  {
    var now = new DateTime.now().millisecondsSinceEpoch;
    uploadDate = now;
  }

  Future<String> uploadFile() async {

    bool check = false;

    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('${widget.uid}/${widget.fileName}');
    StorageUploadTask task = firebaseStorageRef.putFile(widget.image);

    downloadURL = await firebaseStorageRef.getDownloadURL();

    if(downloadURL != null || downloadURL != "")
    {
      print("\n");
      print("\n");
      print("In uploadfile");
      print("SUCCESS!!!!!!");
      check = true;
      print("\n");
      print("\n");
    }
    else{
      print("\n");
      print("\n");
      print("In uploadfile");
      print("FAIL");
      print("\n");
      print("\n");
    }

    print("--------------------\n");
    print("In uploadFile in second file\n");
    print("${widget.uid}");
    print("${widget.fileName}");
    print("$downloadURL");
    print("--------------------\n");

    setState(() {
      location = downloadURL;
      if(check)
        {
          done = true;
          _state = 2;
        }
      print("\n\nValue of done in uploadFile");
      print("$done");
    });

    return location;
  }

  Future _submit(bool value) async
  {
//    try
//    {
      await uploadFile();
      await _confirm();

      value = done;
//    }
//    catch(e){
//      print("\n");
//      print("\n");
//      print("FAIL");
//      print("\n");
//      print("\n");
//    }

  }

  Future _confirm() async
  {
    var loginForm = form.currentState;

    if(loginForm.validate())
    {
      loginForm.save();
    }

    _setDate();

    Firestore.instance.collection('art').document()
        .setData({ 'art_title': '$artTitle',
      'artist_id': '${widget.uid}',
      'artist_name': '$artistName',
      'description':'$description',
      'upload_date': uploadDate,
      //'url':'${widget.url}'});
      'url':'$location'});

    print("\n");
    print("\n");
    print("--------------------\n");
    print("Confirmed:");
    print("$artTitle");
    print("${widget.uid}");
    print("$artistName");
    print("$description");
    print("$uploadDate");
    print("$location");
    print("--------------------\n");
    print("\n");
    print("\n");
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Hi");

    Widget getArtTitle = TextFormField(
      decoration: new InputDecoration(labelText: "Artist Title"),
      keyboardType: TextInputType.text,
      maxLines:1,
      validator: (input) => input.isEmpty ? "Title is required." : null,
      onSaved: (input) => artTitle = input,
    );

    Widget getArtistName = TextFormField(
      decoration: new InputDecoration(labelText: "Artist Name"),
      keyboardType: TextInputType.text,
      maxLines:1,
      validator: (input) => input.isEmpty ? "Artist name is required." : null,
      onSaved: (input) => artistName = input,
    );

    Widget getDescription = TextFormField(
      decoration: new InputDecoration(labelText: "Description of Art"),
      keyboardType: TextInputType.text,
      maxLines: 5,
      validator: (input) => input.isEmpty ? "Description is required." : null,
      onSaved: (input) => description = input,
    );

    Widget submit = Container(
      padding: const EdgeInsets.only(top: 40.0),
      child: new MaterialButton(
        child: const Text('Submit'),
        color: Color.fromRGBO(255, 160, 0, 1.0),
        textColor: Colors.white,
        elevation: 4.0,
        onPressed: () async {
          await uploadFile();
          await _confirm();
        },
        minWidth: 200.0,
        height: 50.0, //Need to add onPressed event in order to make button active
      )
    );

    Widget setUpButtonChild() {
      print("\n\nValue of state in setUpButton");
      print("$_state");
      if (_state == 0) {
        return new Text(
          "Submit",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        );
      } else if (_state == 1) {
        return SizedBox(
          height: 36.0,
          width: 36.0,
          child: CircularProgressIndicator(
            value: null,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      } else if(_state == 2){
        return Icon(Icons.check, color: Colors.white);
      } else if(_state == 3){
        return Icon(Icons.close, color: Colors.white);
      }
    }

    void animateButton() {
      print("\n\nin Animate Button");
      //bool plswork = false;
      double initialWidth = _globalKey.currentContext.size.width;

      _controller =
          AnimationController(duration: Duration(milliseconds: 300), vsync: this);
      _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
        ..addListener(() {
          setState(() {
            _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
          });
        });
      _controller.forward();

      _submit(_didItWork);

      print("\n\nValue of done in animateButton");
      print("$done");

      print("\n\n////////////////////");
      print("Value of diditwork in animateButton");
      print("$_didItWork");

      setState(() {
        _state = 1;
      });

      if(_didItWork)
        {
          setState(() {
            _state = 2;
          });
          print("\n");
          print("\n");
          print("In diditWork");
          print("SUCCESS!!!!");
          print("\n");
          print("\n");
        }
        else{
//          Timer(Duration(milliseconds: 3300), ()
//          {
              setState(() {
                _state = 3;
              });
              print("\n");
              print("\n");
              print("In diditwork");
              print("FAIL!!!!");
              print("\n");
              print("\n");
            //});
        }
    }

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: new Text('Enter Art Information')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 160, 0, 1.0),
              ),
              accountName: new Text('Artist'),
              accountEmail: new Text('gmail.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Text('T'),
              ),
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
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: Image.asset('images/logo.png'),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top:20.0, bottom: 30.0),
            ),
            Form(
              key: form,
              child: Column(
                children: <Widget>[
                  getArtTitle,
                  getArtistName,
                  getDescription,
                ]
              )
            ),
            Padding(padding: const EdgeInsets.only(top: 25.0, bottom: 10.0)),
            Container(
              child: new PhysicalModel(
                elevation: 8.0,
                shadowColor: Colors.lightGreenAccent,
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(25.0),
                child: Container(
                  key: _globalKey,
                  height: 48.0,
                  width: _width,
                  child: new RaisedButton(
                    padding: EdgeInsets.all(0.0),
                    child: setUpButtonChild(),
                    onPressed: () {
                      setState(() {
                        if (_state == 0) {
                          animateButton();

                        }
                      });
                    },
                    elevation: 4.0,
                    color: Colors.lightGreen,
                  ),
                ),
              ),
            ),
            submit
          ],
        ),
      ),
    );
  }
}