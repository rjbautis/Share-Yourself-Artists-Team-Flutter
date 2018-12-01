import 'package:pinch_zoom_image/pinch_zoom_image.dart';
import 'package:flutter/material.dart';

class ArtistViewArt extends StatefulWidget {
  var snapshot;
  int index;

  ArtistViewArt({@required this.snapshot, this.index});

  @override
  _ArtistViewArtState createState() => new _ArtistViewArtState();
}

class _ArtistViewArtState extends State<ArtistViewArt> {
  String artImage;
  String artTitle;
  String artDescription;

  @override
  void initState() {
    super.initState();
    setState(() {
      artImage = widget.snapshot.data.documents[widget.index]['url'].toString();
      artTitle =
          widget.snapshot.data.documents[widget.index]['art_title'].toString();
      artDescription = widget
          .snapshot.data.documents[widget.index]['description']
          .toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Image.asset('images/logo.png'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: new Center(
        child: new ListView(children: <Widget>[
          new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0)),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new PinchZoomImage(
                image: new Image.network(
                  artImage,
                  fit: BoxFit.fitWidth,
                ),
              ),
              new ListTile(
                title: Text(
                  artTitle,
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  artDescription,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
