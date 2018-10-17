import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: new MyHomePage(title: 'SYA CRUD App'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _display = "";
  var list = [10];

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
    http.Response response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"), //This JSON file is an array
        headers: {"Accept": "application/json"});
    List data = json.decode(response.body);
    print(data[2]['userId'].toString());
    setState(() {
      _display = data[2]['userId'].toString();
    });
  }

  Future<Null> _read() async { //<> means return type, Null = void
    http.Response response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"), //This JSON file is an array
        headers: {"Accept": "application/json"});
    List data = json.decode(response.body);
    print(data[2]['id'].toString());
    setState(() {
      _display = data[2]['id'].toString();
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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

