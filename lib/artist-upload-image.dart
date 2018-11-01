import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "package:http/http.dart" as http;

class ArtistUploadImage extends StatefulWidget {
  @override
  _ArtistUploadImageState createState() => _ArtistUploadImageState();
}

class _ArtistUploadImageState extends State<ArtistUploadImage> {
  File galleryFile;
  File cameraFile;
  File _current;

  File sampleImage;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    //display image selected from gallery
//    imageSelectorGallery() async {
//      galleryFile = await ImagePicker.pickImage(
//        source: ImageSource.gallery,
//      );
//      print("You selected gallery image : " + galleryFile.path);
//      setState(() {_current = galleryFile;});
//    }
//
//    imageSelectorCamera() async {
//      cameraFile = await ImagePicker.pickImage(
//        source: ImageSource.camera,
//        //maxHeight: 50.0,
//        //maxWidth: 50.0,
//      );
//      print("You selected camera image : " + cameraFile.path);
//      setState(() {_current = cameraFile;});
//    }
//
//    Future<Null> _uploadGalleryImage() async { //<> means return type, Null = void
//      var url = "https://us-central1-sya-dummy.cloudfunctions.net/testFunction";
//      http.post(url, body:
//        { "photo": galleryFile != null ? 'data:image/png;base64,' +
//          base64Encode(galleryFile.readAsBytesSync()) : '',
//      })
//          .then((response) {
//        debugPrint("Response status: ${response.statusCode}");
//        debugPrint("Response body: ${response.body}");
//      });
//    }
//
//    Rect myRect = const Offset(1.0, 2.0) & const Size(3.0, 4.0);
//
//
//
//    Widget displaySelectedFile(File file) {
//      return new SizedBox(
//        width: MediaQuery.of(context).size.width*.50,
//        child: file == null
//            ? new Text('Sorry nothing selected!!')
//            : new Image.file(file),
//      );
//    }
//
//
//    return new Scaffold(
//      resizeToAvoidBottomPadding: false,
//      body: Container(
//        padding: const EdgeInsets.all(20.0),
//        child: Column(
//          children: <Widget>[
//            Container(
//              child: Image.asset('images/logo.png'),
//              padding: const EdgeInsets.all(20.0),
//            ),
////            Container(
////              child: new Text(
////                "Upload a New Piece",
////                textAlign: TextAlign.center,
////                style: const TextStyle(
////                    fontSize: 25.0,
////                    color: Color.fromRGBO(255, 160, 0, 1.0)),
////              ),
////              padding: const EdgeInsets.only(top: 15.0),
////            ),
//            displaySelectedFile(_current),
//            Container(
//              padding: const EdgeInsets.only(top: 40.0),
//              child: new MaterialButton(
//                child: const Text('Upload Image from Gallery'),
//                color: Color.fromRGBO(255, 160, 0, 1.0),
//                textColor: Colors.white,
//                elevation: 4.0,
//                onPressed: imageSelectorGallery,
//                minWidth: 200.0,
//                height: 50.0, //Need to add onPressed event in order to make button active
//              ),
//            ),
//            Container(
//              padding: const EdgeInsets.only(top: 40.0),
//              child: new MaterialButton(
//                child: const Text('Upload Image from Camera'),
//                color: Color.fromRGBO(255, 160, 0, 1.0),
//                textColor: Colors.white,
//                elevation: 4.0,
//                onPressed: imageSelectorCamera,
//                minWidth: 200.0,
//                height: 50.0, //Need to add onPressed event in order to make button active
//              ),
//            ),
//            Container(
//              padding: const EdgeInsets.only(top: 40.0),
//              child: new MaterialButton(
//                child: const Text('Upload to Database'),
//                color: Color.fromRGBO(255, 160, 0, 1.0),
//                textColor: Colors.white,
//                elevation: 4.0,
//                onPressed: _uploadGalleryImage,
//                minWidth: 200.0,
//                height: 50.0, //Need to add onPressed event in order to make button active
//              ),
//            ),
//            Padding(padding: const EdgeInsets.only(top:25.0, bottom:25.0)),
//
//          ],
//        ),
//      ),
//    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Image Upload'),
        centerTitle: true,
      ),
      body: new Center(
        child: sampleImage == null ? Text('Select an image') : enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height: 300.0, width: 300.0),
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload'),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () {
              final StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child('test2.jpg');
              final StorageUploadTask task =
              firebaseStorageRef.putFile(sampleImage);

            },
          )
        ],
      ),
    );
  }
  }