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
  bool _cardView = false;
  String _searchTerm = "";

  @override
  void initState() {
    super.initState();
  }

  Widget _buildList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    String name = snapshot.data.documents[index]['business_name'].toString();
    String uid = snapshot.data.documents[index]['userId'].toString();

    if (!name.toLowerCase().contains(_searchTerm.toLowerCase())) {
      return null;
    }

    return new ListTile(
      title: Text(name),
      subtitle: Text(uid),
      onTap: () {
        List<String> selectedBus = new List(2);
        selectedBus[0] = name;
        selectedBus[1] = uid;
        Navigator.of(context).pop(selectedBus);
      },
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
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: new Container(
        width: _screenWidth,
        height: _screenHeight,
        child: new ListView(
          children: <Widget>[
            /*new Container(
              width: _screenWidth * .80,
              child: new TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: '  Search...',
                ),
              ),
            ),*/
            new Container(
              height: _screenHeight, // - 123,
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
          ],
        ),
      ),
    );
  }
}
