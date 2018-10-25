import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedbackList extends StatefulWidget {

  @override
  _FeedbackListState createState() => new _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  String _imageUrl = 'https://vignette.wikia.nocookie.net/citrus/images/6/60/No_Image_Available.png/revision/latest/scale-to-width-down/480?cb=20170129011325';

  //@override
  //void initState() {

  //}

  Future<Null> _fetchImage() async {
    http.Response response = await http.get(
        Uri.encodeFull('https://us-central1-sya-dummy.cloudfunctions.net/getChat'),
        headers: {"Accept": "application/json"});
    Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      try {
        _imageUrl = data['url'].toString();
      } catch (e){
        _imageUrl = 'https://vignette.wikia.nocookie.net/citrus/images/6/60/No_Image_Available.png/revision/latest/scale-to-width-down/480?cb=20170129011325';
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
      title: title,
      home: Scaffold(

        appBar: AppBar(
          title: Text(title),
        ),
        body: new ListView(
            children: <Widget>[
              ListTile(
                leading: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1024px-Cat03.jpg',
                  height: 40.0,
                ),
                title: Text('Submitted Art 1'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo),
                title: Text('Submitted Art 2'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo),
                title: Text('Submitted Art 3'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo),
                title: Text('Submitted Art 4'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo),
                title: Text('Submitted Art 5'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo),
                title: Text('Submitted Art 6'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo),
                title: Text('Submitted Art 7'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo),
                title: Text('Submitted Art 8'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo),
                title: Text('Submitted Art 9'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
              ListTile(
                leading: Icon(Icons.insert_photo),
                title: Text('Submitted Art 10'),
                subtitle: Text('Artist Name/Other info'),
                onTap: () { _navigateFeedback(); },
                onLongPress: () { _showOptions(); },
              ),
            ]
        ),
      ),
    );
  }
}
