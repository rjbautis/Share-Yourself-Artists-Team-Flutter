import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/artistSendArt.dart';
import 'package:share_yourself_artists_team_flutter/artist/artistUploadImage.dart';
import 'package:share_yourself_artists_team_flutter/artist/artistViewArt.dart';
import 'package:share_yourself_artists_team_flutter/artist/artistViewReply.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';
import 'package:share_yourself_artists_team_flutter/user/drawer.dart';

class ArtistDash extends StatefulWidget {
  ArtistDash();

  @override
  _ArtistDashState createState() => new _ArtistDashState();
}

class _ArtistDashState extends State<ArtistDash> {
  static GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  bool refresh = false;
  double _screenWidth;
  bool _cardView = true;
  String _uid;

  @override
  void initState() {
    super.initState();

    // Grab the saved uid of current user from memory
    loadUid().then((uid) {
      print('init: current uid: ${uid}');
      _uid = uid;
    });
  }

  void _navigateUpload() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArtistUploadImage()),
    );
  }

  void _navigateSend(AsyncSnapshot<QuerySnapshot> snapshot, int index) async {
    final sent = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ArtistSendArt(
                snapshot: snapshot,
                index: index,
              )),
    );

    bool _snackBar = false;

    if (sent != null) {
      _snackBar = sent;
    }

    if (_snackBar) {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: new Text('Sent!'),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.green,
      ));
    }
  }

  void _viewArt(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ArtistViewArt(
                snapshot: snapshot,
                index: index,
              )),
    );
  }

  Widget _buildList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,
      int index, int len) {
    int newIndex = len - index - 1;
    String artImage = snapshot.data.documents[newIndex]['url'].toString();
    String artTitle = snapshot.data.documents[newIndex]['art_title'].toString();
    String artDescription =
        snapshot.data.documents[newIndex]['description'].toString();
    int uploadDate = snapshot.data.documents[newIndex]['upload_date'];

    DateTime upload =
        DateTime.fromMillisecondsSinceEpoch(uploadDate, isUtc: false);
    String dateString = upload.month.toString() +
        '-' +
        upload.day.toString() +
        '-' +
        upload.year.toString();

    if (!_cardView) {
      return new Column(
        children: <Widget>[
          Dismissible(
            // Show a red background as the item is swiped away
            background: Container(
              color: Colors.green,
            ),
            key: Key(artTitle + Random().nextInt(1000000).toString()),
            onDismissed: (direction) async {
              // send to business
              await _navigateSend(snapshot, newIndex);
            },
            child: ListTile(
              title: Text(artTitle),
              subtitle: Text(artDescription),
            ),
          ),
          new Divider(
            height: 15.0,
          ),
        ],
      );
    } else {
      return new Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: _screenWidth * .1),
            ),
            Image.network(
              artImage,
              width: MediaQuery.of(context).size.width * .75,
            ),
            ListTile(
              title: Text(
                artTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, letterSpacing: 0.5),
              ),
              subtitle: Text(
                dateString,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  artDescription,
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.send),
                  color: Color.fromRGBO(255, 160, 0, 1.0),
                  onPressed: () async {
                    await _navigateSend(snapshot, newIndex);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void _navReplyDescription(
      AsyncSnapshot<QuerySnapshot> snapshot, int index) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ArtistViewReply(
                snapshot: snapshot,
                index: index,
              )),
    );
  }

  // Builds the card for the replied artwork tab
  Widget _buildRepliedCard(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, int index, int length) {
    int newIndex = length - index - 1;

    String artImage =
        snapshot.data.documents[newIndex]['art']['url'].toString();
    String artTitle =
        snapshot.data.documents[newIndex]['art']['art_title'].toString();
    String artArtist =
        snapshot.data.documents[newIndex]['art']['artist_name'].toString();
    String accepted = snapshot
        .data.documents[newIndex]['submission_response']['radios']
        .toString()
        .toLowerCase();
    bool artFree =
        snapshot.data.documents[newIndex]['submitted_with_free_cerdit'];

    bool _accepted = false;

    if (accepted.compareTo('accepted') == 0) _accepted = true;

    if (artFree == null) artFree = false;

    return new GestureDetector(
      onTap: () async {
        await _navReplyDescription(snapshot, newIndex);
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: _screenWidth * .1),
            ),
            Image.network(
              artImage,
              width: MediaQuery.of(context).size.width * .75,
            ),
            ListTile(
              title: Text(artTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, letterSpacing: 0.5)),
              subtitle: Text(artArtist, textAlign: TextAlign.center),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.attach_money,
                  color: artFree ? Colors.grey : Colors.green,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: _screenWidth * .3),
                ),
                Icon(
                  _accepted ? Icons.check_circle : Icons.not_interested,
                  color: _accepted ? Colors.green : Colors.red,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Dashboard';
    _screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: new Image.asset('images/logo.png'),
          bottom: TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text('My Art', style: TextStyle(fontSize: 17.0)),
                      new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
                      new Icon(Icons.inbox),
                    ],
                  ),
                ),
                Tab(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text('Responses'),
                      new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
                      new Icon(Icons.arrow_back),
                    ],
                  ),
                ),
              ]),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: _cardView ? Icon(Icons.list) : Icon(Icons.image),
              onPressed: () {
                setState(() {
                  _cardView = !_cardView;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () {
                _navigateUpload();
              },
            ),
          ],
        ),
        drawer: NavDrawer(),
        body: TabBarView(
          children: <Widget>[
            StreamBuilder(
              stream: Firestore.instance
                  .collection('art')
                  .where('artist_id', isEqualTo: '${_uid}')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Loading..."),
                    ],
                  );
                }
                if (snapshot.data.documents.length == 0) {
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("No Art, Why don't you upload some!"),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            refresh = !refresh;
                          });
                        },
                        color: Colors.lightBlue,
                      ),
                    ],
                  );
                }
                return new Container(
                  child: ListView.builder(
                    itemBuilder: (BuildContext ctxt, int index) => _buildList(
                        context,
                        snapshot,
                        index,
                        snapshot.data.documents.length),
                    itemCount: snapshot.data.documents.length,
                  ),
                );
              },
            ),
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('review_requests')
                  .where('art.artist_id', isEqualTo: '${_uid}')
                  .where('replied', isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Loading...", style: TextStyle(fontSize: 17.0)),
                    ],
                  );
                }
                if (snapshot.data.documents.length == 0) {
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("No Responses"),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            refresh = !refresh;
                          });
                        },
                        color: Colors.lightBlue,
                      ),
                    ],
                  );
                }
                return new Container(
                  child: ListView.builder(
                    itemBuilder: (BuildContext ctxt, int index) =>
                        _buildRepliedCard(context, snapshot, index,
                            snapshot.data.documents.length),
                    itemCount: snapshot.data.documents.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
