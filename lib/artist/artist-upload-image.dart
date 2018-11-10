import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
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

  String location = "";
  String _display = "";

  String _baseName = "";

  void enableUpload() {
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('$user/$fileName.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(_current);
  }

  Future<String> uploadFile() async {
    StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('${widget.uid}/$_baseName');
    StorageUploadTask task = firebaseStorageRef.putFile(_current);

    location = await firebaseStorageRef.getDownloadURL();

    setState(() {
      _display = location;
    });
    print("File available at $location");

    return location;
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
      });
    }

    imageSelectorCamera() async {
      cameraFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
      print("You selected camera image : " + cameraFile.path);
      setState(() {
        _current = cameraFile;
      });
    }

    Widget displaySelectedFile(File file) {
      return new ConstrainedBox(
        constraints: new BoxConstraints(
            minWidth: 100.0,
            minHeight: 200.0,
            maxWidth: 200.0,
            maxHeight: 300.0),
        child: file == null
            ? new Text('Sorry nothing selected!!')
            : new Image.file(file),
      );
    }

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: new Text('Upload Art')),
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
                Navigator.of(context).pushReplacementNamed('/login');
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
                height:
                    50.0, //Need to add onPressed event in order to make button active
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
                height:
                    50.0, //Need to add onPressed event in order to make button active
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40.0),
              child: new MaterialButton(
                child: const Text('Upload to Database'),
                color: Color.fromRGBO(255, 160, 0, 1.0),
                textColor: Colors.white,
                elevation: 4.0,
                onPressed: uploadFile,
                minWidth: 200.0,
                height:
                    50.0, //Need to add onPressed event in order to make button active
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 25.0, bottom: 10.0)),
            Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: new Text("Download URL: $_display"),
              //Need to add onPressed event in order to make button active
            ),
          ],
        ),
      ),
    );
  }
}
