import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArtistViewReply extends StatefulWidget {
  var snapshot;
  int index;

  ArtistViewReply({@required this.snapshot, this.index});

  @override
  _ArtistViewReplyState createState() => new _ArtistViewReplyState();
}

class _ArtistViewReplyState extends State<ArtistViewReply> {
  String artImage;
  String artTitle;
  String artDescription;
  bool accepted;
  bool artFree;

  String busName;
  String busEmail;
  String response;

  @override
  void initState() {
    super.initState();
    setState(() {
      artImage =
          widget.snapshot.data.documents[widget.index]['art']['url'].toString();
      artTitle = widget
          .snapshot.data.documents[widget.index]['art']['art_title']
          .toString();
      artDescription = widget
          .snapshot.data.documents[widget.index]['art']['description']
          .toString();

      busName = widget
          .snapshot.data.documents[widget.index]['businessId']['business_name']
          .toString();
      busEmail = widget
          .snapshot.data.documents[widget.index]['businessId']['business_email']
          .toString();
      response = widget.snapshot.data
          .documents[widget.index]['submission_response']['response']
          .toString();
      String _accepted = widget.snapshot.data
          .documents[widget.index]['submission_response']['radios']
          .toString()
          .toLowerCase();
      artFree = widget.snapshot.data.documents[widget.index]
          ['submitted_with_free_cerdit'];

      accepted = false;

      if (_accepted.compareTo('accepted') == 0) accepted = true;

      if (artFree == null) artFree = false;
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
              new Container(
                height: MediaQuery.of(context).size.width * .75,
                child: new Image.network(
                  artImage,
                  fit: BoxFit.fitWidth,
                ),
              ),
              new ListTile(
                title: Text(artTitle),
                subtitle: Text(artDescription),
              ),
              new Padding(padding: EdgeInsets.fromLTRB(5.0, 15.0, 0.0, 0.0)),
              new ListTile(
                title: accepted
                    ? Text('Accepted by ' + busName)
                    : Text('Declined by ' + busName),
                subtitle: Text(busEmail),
              ),
              new Padding(padding: EdgeInsets.fromLTRB(5.0, 15.0, 0.0, 0.0)),
              new ListTile(
                title: Text('Response:'),
                subtitle: Text(response),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
