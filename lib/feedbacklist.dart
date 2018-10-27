import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedbackList extends StatefulWidget {
  @override
  _FeedbackListState createState() => new _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  String _imageUrl =
      'https://vignette.wikia.nocookie.net/citrus/images/6/60/No_Image_Available.png/revision/latest/scale-to-width-down/480?cb=20170129011325';
  double _screenWidth;
  var _names = ['Le Chat', "Die Katze", 'The Cat', 'El Gato'];

  //@override
  //void initState() {

  //}

  Future<Null> _fetchImage() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            'https://us-central1-sya-dummy.cloudfunctions.net/getChat'),
        headers: {"Accept": "application/json"});
    Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      try {
        _imageUrl = data['url'].toString();
      } catch (e) {
        _imageUrl =
            'https://vignette.wikia.nocookie.net/citrus/images/6/60/No_Image_Available.png/revision/latest/scale-to-width-down/480?cb=20170129011325';
      }
    });
  }

  Widget _buildCard(BuildContext ctxt, int index) {
    return new Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: _screenWidth*.1),
          ),
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1024px-Cat03.jpg',
            width: MediaQuery.of(context).size.width * .75,
          ),
          ListTile(
            title: Text(
              _names[index],
              textAlign: TextAlign.center,
            ),
            subtitle:
                Text('Artist Name/Other Info', textAlign: TextAlign.center),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.attach_money,
                color: Colors.green,
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
                  _navigateFeedback();
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  void _navigateFeedback() {
    // will eventually take artists ID to fetch the right info
    Navigator.pushNamed(context, "/feedback");
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Submitted Artwork';
    _screenWidth = MediaQuery.of(context).size.width;

    new ListTileTheme(
      textColor: Colors.deepPurple,
    );

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: TabBar(tabs: [
              Tab(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('New'),
                    new Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
                    new Icon(Icons.error_outline),
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
                  _buildCard(ctxt, index),
              itemCount: _names.length,
            ),
            new Icon(Icons.done_all),
          ]),
        ),
      ),
    );
  }
}
