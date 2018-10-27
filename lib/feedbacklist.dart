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

  void _navigateFeedback() {
    // will eventually take artists ID to fetch the right info
    Navigator.pushNamed(context, "/feedback");
  }

  void _showOptions() {
    // show an alert dialog to show options for this list element
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Submitted Artwork';

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
            new ListView(children: <Widget>[
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1024px-Cat03.jpg',
                      width: MediaQuery.of(context).size.width * .75,
                    ),
                    ListTile(
                      title: Text(
                        'Le Chat',
                        textAlign: TextAlign.center,
                      ),
                      subtitle:
                          Text('Artist Name', textAlign: TextAlign.center),
                    ),
                    Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    ),
                    ButtonTheme.bar(
                      child: ButtonBar(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.reply,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              _navigateFeedback();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            new Icon(Icons.done_all),
          ]),
        ),
      ),
    );
  }
}
