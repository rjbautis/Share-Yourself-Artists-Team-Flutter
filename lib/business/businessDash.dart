import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';
import 'package:share_yourself_artists_team_flutter/business/businessProvideFeedback.dart';
import 'package:share_yourself_artists_team_flutter/user/drawer.dart';

class BusinessDash extends StatefulWidget {
  @override
  _BusinessDashState createState() => new _BusinessDashState();
}

class _BusinessDashState extends State<BusinessDash> {
  bool refresh = false;
  double _screenWidth;
  String _uid;

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

  // Builds the card for the new artworks
  Widget _buildNewArtCard(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, int index, int length) {
    int newIndex = length - index - 1;

    String artImage =
        snapshot.data.documents[newIndex]['art']['url'].toString();
    String artTitle =
        snapshot.data.documents[newIndex]['art']['art_title'].toString();
    String artArtist =
        snapshot.data.documents[newIndex]['art']['artist_name'].toString();
    //bool artReplied = snapshot.data.documents[index]['replied'];
    bool artFree =
        snapshot.data.documents[newIndex]['submitted_with_free_cerdit'];
    String artUserID =
        snapshot.data.documents[newIndex]['art']['artist_id'].toString();

    var art = snapshot.data.documents[newIndex];

    if (artFree == null) artFree = false;

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
                style: TextStyle(fontSize: 18.0),
            ),
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
              IconButton(
                icon: Icon(
                  Icons.reply,
                  color: Colors.orange,
                ),
                tooltip: 'Respond',
                onPressed: () {
                  _navigateFeedback(art, snapshot, newIndex);
                },
              )
            ],
          ),
        ],
      ),
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
              style: TextStyle(fontSize: 18.00, letterSpacing: 0.5)
            ),
            subtitle: Text(artArtist, textAlign: TextAlign.center,),
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
    );
  }

  void _navigateFeedback(
      var art, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    // create new FeedbackPage
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BusinessProvideFeedback(
                artInfo: art,
                snapshot: snapshot,
                index: index,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Submitted Artwork';
    _screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: new Image.asset('images/logo.png'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          bottom: TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text('New', style: TextStyle(fontSize: 17.0)),
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
                      new Text('Replied', style: TextStyle(fontSize: 17.0)),
                      new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
                      new Icon(Icons.done_all),
                    ],
                  ),
                ),
              ]),
        ),
        drawer: NavDrawer(),
        body: TabBarView(children: [
          new StreamBuilder(
            stream: Firestore.instance
                .collection('review_requests')
                .where('businessId.userId', isEqualTo: '${_uid}')
                .where('replied', isEqualTo: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    Text("No New Requests"),
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
                      _buildNewArtCard(context, snapshot, index,
                          snapshot.data.documents.length),
                  itemCount: snapshot.data.documents.length,
                ),
              );
            },
          ),
          new StreamBuilder(
            stream: Firestore.instance
                .collection('review_requests')
                .where('businessId.userId', isEqualTo: '${_uid}')
                .where('replied', isEqualTo: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    Text("No Replied Arts"),
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
        ]),
      ),
    );
  }
}
