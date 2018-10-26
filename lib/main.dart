import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new MyHomePage(title: 'SYA CRUD App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _display = "";

  Widget futureWidgetGet() {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      // if(snapshot.hasData){return new Text(display);}    //does not display updated text
      if (_display != null) {
        return new Text(_display);
      }
      return new Text("no data yet");
    });
  }

  Future<Null> _create() async { //<> means return type, Null = void
    var url = "https://us-central1-sya-dummy.cloudfunctions.net/testFunction";
    http.post(url, body: {"name": "Franz", "age": "10"})
        .then((response) {
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");
    });
  }

  Future<Null> _read() async { //<> means return type, Null = void
    http.Response response = await http.get(
        Uri.encodeFull("https://us-central1-sya-dummy.cloudfunctions.net/getUserData"), //This JSON file is an array
        headers: {"Accept": "application/json"});
    Map<String, dynamic> data = json.decode(response.body);
    print(data['userID'].toString());
    setState(() {
      _display = data['userID'].toString();
    });
  }

  Future<Null> _update() async { //<> means return type, Null = void
    http.Response response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"), //This JSON file is an array
        headers: {"Accept": "application/json"});
    List data = json.decode(response.body);
    print(data[2]['title'].toString());

    setState(() {
      _display = data[2]['title'].toString();
    });
  }

  Future<Null> _delete() async { //<> means return type, Null = void
    http.Response response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"), //This JSON file is an array
        headers: {"Accept": "application/json"});
    List data = json.decode(response.body);
    print(data[2]['body'].toString());
    setState(() {
      _display = data[2]['body'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text("Function Call: $_display"),
            new MaterialButton(
              child: const Text('Create'),
              color: Colors.red,
              textColor: Colors.white,
              elevation: 4.0,
              onPressed: _create,
              minWidth: 200.0,
              height: 50.0,//Need to add onPressed event in order to make button active
            ),
            new MaterialButton(
              child: const Text('Read'),
              color: Colors.purple,
              textColor: Colors.white,
              elevation: 4.0,
              onPressed: _read,
              minWidth: 200.0,
              height: 50.0,//Need to add onPressed event in order to make button active
            ),
            new MaterialButton(
              child: const Text('Update'),
              color: Colors.green,
              textColor: Colors.white,
              elevation: 4.0,
              onPressed: _update,
              minWidth: 200.0,
              height: 50.0,//Need to add onPressed event in order to make button active
            ),
            new MaterialButton(
              child: const Text('Delete'),
              color: Colors.blue,
              textColor: Colors.white,
              elevation: 4.0,
              onPressed: _delete,
              minWidth: 200.0,
              height: 50.0,//Need to add onPressed event in order to make button active
            ),
            //futureWidgetPost()
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//HTTP Notes
//200+ means the request has succeeded.
//300+ means the request is redirected to another URL
//400+ means an error that originates from the client has occurred
//500+ means an error that originates from the server has occurred

