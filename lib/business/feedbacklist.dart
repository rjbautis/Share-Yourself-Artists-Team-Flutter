import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_yourself_artists_team_flutter/authentication/authentication.dart';
import 'package:share_yourself_artists_team_flutter/business/feedbackpage.dart';

class FeedbackList extends StatefulWidget {
  final String uid;
  final Authentication authentication;
  final VoidCallback handleSignOut;

  FeedbackList({@required this.uid, this.authentication, this.handleSignOut});

  @override
  _FeedbackListState createState() => new _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  double _screenWidth;
  List<dynamic> _arts;
  List<dynamic> _newArts;
  List<dynamic> _repliedArts;
  int _numNew = 0;
  int _numReplied = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _reviewBuiler(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    String artImage = snapshot.data.documents[index]['art']['url'].toString();
    String artTitle = snapshot.data.documents[index]['art']['art_title'].toString();
    String artArtist = snapshot.data.documents[index]['art']['artist_name'].toString();
    //bool artReplied = snapshot.data.documents[index]['replied'];
    bool artPaid = snapshot.data.documents[index]['submitted_with_free_cerdit'];
    String artUserID = snapshot.data.documents[index]['art']['artist_id'].toString();

    var art = snapshot.data.documents[index];

    if (artPaid == null)
      artPaid = false;

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
            ),
            subtitle:
            Text(artArtist, textAlign: TextAlign.center),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.attach_money,
                color: artPaid ? Colors.green : Colors.grey,
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
                  _navigateFeedback(art);
                },
              )
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildRepliedCard(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    String artImage = snapshot.data.documents[index]['art']['url'].toString();
    String artTitle = snapshot.data.documents[index]['art']['art_title'].toString();
    String artArtist = snapshot.data.documents[index]['art']['artist_name'].toString();
    String accepted = snapshot.data.documents[index]['submission_response.radios'].toString().toLowerCase();
    bool artPaid = snapshot.data.documents[index]['submitted_with_free_cerdit'];
    String artUserID = snapshot.data.documents[index]['art']['artist_id'].toString();
    bool _accepted = false;

    if (accepted.compareTo('accepted') == 1)
      _accepted = true;

    if (artPaid == null)
      artPaid = false;

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
            ),
            subtitle:
                Text(artArtist, textAlign: TextAlign.center),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.attach_money,
                color: artPaid ? Colors.green : Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: _screenWidth * .3),
              ),
              Icon(
                _accepted ? Icons.check_circle : Icons.not_interested,
                color: _accepted ? Colors.green :  Colors.red,
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

  void _navigateFeedback (var art) {
    // create new FeedbackPage
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FeedbackPage(
                artInfo: art,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Submitted Artwork';
    _screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            bottom: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text('New'),
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
                        new Text('Replied'),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
                        new Icon(Icons.done_all),
                      ],
                    ),
                  ),
                ]),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 160, 0, 1.0),
                  ),
                  accountName: new Text('Business'),
                  accountEmail: new Text('gmail.com'),
                  currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Text('T'),
                  ),
                ),
                ListTile(
                  title: new Text('Log Out'),
                  onTap: () async {
                    await widget.authentication.signOut();
                    widget.handleSignOut();
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            /*new ListView.builder(
              itemBuilder: (BuildContext ctxt, int index) =>
                  _buildNewCard(ctxt, index),
              itemCount: _numNew,
            ),*/
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('review_requests')
                  .where('businessId.userId', isEqualTo: '${widget.uid}')
                  .where('replied', isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text('Loading...');
                return new Container(
                  child: ListView.builder(
                    itemBuilder: (BuildContext ctxt, int index) =>
                        _reviewBuiler(context, snapshot, index),
                    itemCount: snapshot.data.documents.length,
                  ),
                );
              },
            ),
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('review_requests')
                  .where('businessId.userId', isEqualTo: '${widget.uid}')
                  .where('replied', isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text('Loading...');
                return new Container(
                  child: ListView.builder(
                    itemBuilder: (BuildContext ctxt, int index) =>
                        _buildRepliedCard(context, snapshot, index),
                    itemCount: snapshot.data.documents.length,
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
