import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessSelect extends StatefulWidget {
  BusinessSelect();

  @override
  _BusinessSelectState createState() => new _BusinessSelectState();
}

class _BusinessSelectState extends State<BusinessSelect> {
  TextEditingController _controller = new TextEditingController();
  double _screenWidth;
  double _screenHeight;
  String _searchTerm = "";

  @override
  void initState() {
    super.initState();
  }

  Widget _buildList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    String name = snapshot.data.documents[index]['business_name'].toString();
    String uid = snapshot.data.documents[index]['userId'].toString();
    String email = snapshot.data.documents[index]['email'].toString();
    String theGood = snapshot.data.documents[index]['the_good'].toString();

    if (!name.toLowerCase().contains(_searchTerm.toLowerCase())) {
      return null;
    }

    var _children = <Widget>[
      new ListTile(
        title: Text(name, style: TextStyle(fontSize: 17.0, letterSpacing: 0.5)),
        subtitle: Text(theGood),
        onTap: () {
          List<String> selectedBus = new List(3);
          selectedBus[0] = name;
          selectedBus[1] = uid;
          selectedBus[2] = email;
          Navigator.of(context).pop(selectedBus);
        },
      ),
      new Divider(
        height: 15.0,
      )
    ];

    // Return the ListTile with a Divider at the bottom
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _children,
    );
  }

  void _search() {
    setState(() {
      _searchTerm = _controller.text.toLowerCase();
    });

    //build(context);
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Select a Business';
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _controller.addListener(_search);

    return Scaffold(
      appBar: AppBar(
        title: new Image.asset('images/logo.png'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: new Container(
        child: new StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .where("role", isEqualTo: "business")
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading...');
            return new Container(
              child: ListView.builder(
                itemBuilder: (BuildContext ctxt, int index) =>
                    _buildList(context, snapshot, index),
                itemCount: snapshot.data.documents.length,
              ),
            );
          },
        ),
      ),
    );
  }
}
