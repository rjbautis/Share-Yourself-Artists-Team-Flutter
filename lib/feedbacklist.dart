import 'feedbackpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedbackList extends StatefulWidget {
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

    _getArtworks();
  }

  Future<void> _getArtworks() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            'https://us-central1-sya-dummy.cloudfunctions.net/getArtworks'),
        headers: {"Accept": "application/json"});
    Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      _arts = data["result"];
      _newArts = _arts.where((a) => a["replied"] == false).toList();
      _repliedArts = _arts.where((a) => a["replied"] == true).toList();

      _numNew = _newArts.length;
      _numReplied = _repliedArts.length;
    });
  }

  Widget _buildNewCard(BuildContext ctxt, int index) {
    Map<String, dynamic> artwork = _newArts[index];
    String artImage = artwork["url"];
    String artTitle = artwork["title"];
    String artArtist = artwork["artist"];
    bool artReplied = artwork["replied"];
    bool artPaid = artwork["paid"];
    String artUserID = artwork["id"];

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
                Text(artArtist + " " + artUserID, textAlign: TextAlign.center),
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
                  color: artReplied ? Colors.grey : Colors.orange,
                ),
                tooltip: 'Respond',
                onPressed: () {
                  _navigateFeedback(index);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepliedCard(BuildContext ctxt, int index) {
    Map<String, dynamic> artwork = _repliedArts[index];
    String artImage = artwork["url"];
    String artTitle = artwork["title"];
    String artArtist = artwork["artist"];
    bool artPaid = artwork["paid"];
    String artUserID = artwork["id"];

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
                Text(artArtist + " " + artUserID, textAlign: TextAlign.center),
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
                Icons.not_interested,
                color: Colors.red,
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

  void _navigateFeedback(int index) {
    // create new FeedbackPage
    print(index);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FeedbackPage(
                artInfo: _newArts[index],
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
            backgroundColor: Colors.orangeAccent,
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
          body: TabBarView(children: [
            new ListView.builder(
              itemBuilder: (BuildContext ctxt, int index) =>
                  _buildNewCard(ctxt, index),
              itemCount: _numNew,
            ),
            new ListView.builder(
              itemBuilder: (BuildContext ctxt, int index) =>
                  _buildRepliedCard(ctxt, index),
              itemCount: _numReplied,
            ),
          ]),
        ),
      ),
    );
  }
}
