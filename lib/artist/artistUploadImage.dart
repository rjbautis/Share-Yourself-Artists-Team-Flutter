import 'dart:io';

import 'package:share_yourself_artists_team_flutter/artist/artistImageInfo.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class ArtistUploadImage extends StatefulWidget {
  @override
  _ArtistUploadImageState createState() => _ArtistUploadImageState();
}

class _ArtistUploadImageState extends State<ArtistUploadImage> {
  File galleryFile;
  File cameraFile;
  File _current;

  String downloadURL = "";
  String _baseName = "";
  String _uID = "";

  bool imagePicked = false;

  @override
  void initState()
  {
    super.initState();

    loadUid().then((uid) {
      _uID = uid;
    });
  }


  @override
  Widget build(BuildContext context) {
    //display image selected from gallery
    imageSelectorGallery() async {
      galleryFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      print("You selected gallery image : " + galleryFile.path);
      setState(() {
        _current = galleryFile;
        _baseName = path.basename(_current.path);
        imagePicked = true;
      });
    }

    imageSelectorCamera() async {
      cameraFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
      print("You selected camera image : " + cameraFile.path);
      setState(() {
        _current = cameraFile;
        imagePicked = true;
      });
    }

    Widget displaySelectedFile(File file) {
      return new ConstrainedBox(
        constraints: new BoxConstraints(
            minWidth: 200.0,
            minHeight: 300.0,
            maxWidth: 200.0,
            maxHeight: 300.0),
        child: file == null
            ? new Text('Sorry nothing selected!!')
            : new Image.file(file),
      );
    }

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: new Text('Upload Art'),
        backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: Image.asset('images/logo.png'),
              padding: const EdgeInsets.all(20.0),
            ),
            Padding(padding: const EdgeInsets.only(bottom: 25.0)),
            displaySelectedFile(_current),
            Container(
              padding: const EdgeInsets.only(top: 40.0),
              child: new MaterialButton(
                child: const Text('Upload Image from Gallery'),
                color: Color.fromRGBO(255, 160, 0, 1.0),
                textColor: Colors.white,
                elevation: 4.0,
                onPressed: imageSelectorGallery,
                minWidth: 200.0,
                height: 50.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40.0),
              child: new MaterialButton(
                child: const Text('Upload Image from Camera'),
                color: Color.fromRGBO(255, 160, 0, 1.0),
                textColor: Colors.white,
                elevation: 4.0,
                onPressed: imageSelectorCamera,
                minWidth: 200.0,
                height: 50.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40.0),
              child: new MaterialButton(
                //child: const Text('Upload to Database'),
                child: const Text('Next'),
                color: imagePicked ? Color.fromRGBO(255, 160, 0, 1.0) : Colors.grey,
                textColor: Colors.white,
                elevation: 4.0,
                onPressed: () async {
                  if (imagePicked == false) {
                    return null;
                  }
                  else {
                    final finishedUploading = await Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistImageInfo(image:_current, uid: _uID, fileName:_baseName)));
                    if (finishedUploading == 'done') {
                      print('Finally finished uploading');

                      // Reset the state of the current file to null, so that it won't show up after pop()
                      setState(() {
                        _current = null;
                      });
                    }
                  }
                  },
                minWidth: 200.0,
                height: 50.0,
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 25.0, bottom: 10.0)),
            Container(
              padding: const EdgeInsets.only(top: 10.0),
            ),
          ],
        ),
      ),
    );
  }
}
