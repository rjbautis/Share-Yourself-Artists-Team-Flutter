import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class ArtistImageInfo extends StatefulWidget{
    final File image;
    final String uid;
    final String fileName;

  ArtistImageInfo({Key key, this.image, this.uid, this.fileName}) : super(key: key);

  @override
  _ArtistImageInfoState createState() => _ArtistImageInfoState();
}

class _ArtistImageInfoState extends State<ArtistImageInfo> with TickerProviderStateMixin{
  static GlobalKey<FormState> form = new GlobalKey<FormState>();
  static GlobalKey _globalKey = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

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

  int _progressState = 0;
  bool _didItWork = false;

  bool correctTitle = true;
  bool correctName = true;
  bool correctDesc = true;

  final int SUBMIT = 0;
  final int INPROGRESS = 1;
  final int SUCCESS = 2;
  

  Future<String> _handleUpload() async {
    print('${widget.uid} ${widget.fileName}');

    String downloadUrl = await Authentication.uploadFile(widget.image, widget.uid, null, widget.fileName);
    bool check = downloadUrl != null ? true : false;

    // If there exists a downloadUrl, set the state to the checkmark
    if (check) {
      setState(() {
        _progressState = SUCCESS;
      });
      return downloadUrl;

    } else {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: new Text(
            'There was a problem with uploading, please try again.'),
        duration: Duration(seconds: 4),
      ));
      setState(() {
        _progressState = SUBMIT;
      });
      return null;
    }

  }

  Future<bool> _postToArtCollection(bool value) async  {
    String downloadUrl = await _handleUpload();

    if (downloadUrl == null) {
      return false;
    }

    await _confirm(downloadUrl);
    return true;
  }

  Future _confirm(String downloadUrl) async {
    print('trying to store in art collection');

    await Firestore.instance.collection('art').document().setData(
      { 'art_title': artTitle,
        'artist_id': '${widget.uid}',
        'artist_name': artistName,
        'description': description,
        'upload_date': new DateTime.now().millisecondsSinceEpoch,
        'url': downloadUrl
      });

    print('sucessfully stored in art collection');
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool _validate() {
      var loginForm = form.currentState;

      if (loginForm.validate()) {
        loginForm.save();
        return true;
      }
      return false;
    }

    Widget getArtTitle = TextFormField(
      decoration: new InputDecoration(labelText: "Artist Title"),
      keyboardType: TextInputType.text,
      maxLines:1,
      validator: (input) {
        if (input.isEmpty) {
          return "Title is required.";
        }
        return null;
      },
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


    Widget setUpButtonChild() {
      if (_progressState == SUBMIT) {
        return new Text(
          "Submit",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        );
      } else if (_progressState == INPROGRESS) {
        return SizedBox(
          height: 36.0,
          width: 36.0,
          child: CircularProgressIndicator(
            value: null,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      } else if(_progressState == SUCCESS){
        return Icon(Icons.check, color: Colors.white);
      } else{
        return Icon(Icons.close, color: Colors.white);
      }
    }

    Future animateButton() async {
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

      // Set circular progress bar while submitting the artwork
      setState(() {
        _progressState = INPROGRESS;
      });

      _didItWork = await _postToArtCollection(_didItWork);

      // If everything was successful, reset the state of the progress and pop
      if(_didItWork) {
        print("In _postToArtCollection");
        print("SUCCESS!!!!");

        setState(() {
          _progressState = SUCCESS;
        });

        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop('done');
        });


      } else {
        print('Submitting to not work');
        _scaffoldState.currentState.showSnackBar(SnackBar(
          content: new Text(
              'There was a problem with uploading, please try again.'),
          duration: Duration(seconds: 4),
        ));
        setState(() {
          _progressState = SUBMIT;
        });
      }
    }

    return new Scaffold(
      key: _scaffoldState,
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
                shadowColor: Colors.orangeAccent,
                color: Color.fromRGBO(255, 160, 0, 1.0),
                borderRadius: BorderRadius.circular(25.0),
                child: Container(
                  key: _globalKey,
                  height: 48.0,
                  width: _width,
                  child: new RaisedButton(
                    padding: EdgeInsets.all(0.0),
                    child: setUpButtonChild(),
                    onPressed: () async {
                      if(_validate()) {
                        if (_progressState == SUBMIT) {
                          await animateButton();
                        }
                      }
                    },
                    elevation: 4.0,
                    color: Color.fromRGBO(255, 160, 0, 1.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}