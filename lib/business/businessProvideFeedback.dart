import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessProvideFeedback extends StatefulWidget {
  var artInfo;
  AsyncSnapshot<QuerySnapshot> snapshot;
  final index;

  BusinessProvideFeedback({@required this.artInfo, this.snapshot, this.index});

  @override
  _BusinessProvideFeedbackState createState() => new _BusinessProvideFeedbackState();
}

class _BusinessProvideFeedbackState extends State<BusinessProvideFeedback> {
  FocusNode _textFieldNode = new FocusNode();
  TextEditingController _controller = new TextEditingController();
  String comment;
  bool _submitEnabled = false;
  bool _accepted = false;
  int _radioValue = -1;

  String artImage;
  String artTitle;
  String artArtist;
  bool artReplied;
  bool artPaid;
  String artUserID;

  @override
  void initState() {
    super.initState();

    setState(() {
      artImage = widget.artInfo['art']['url'].toString();
      artTitle = widget.artInfo['art']['art_title'].toString();
      artArtist = widget.artInfo['art']['artist_name'].toString();
      //bool artReplied = widget.artInfo['replied'];
      artPaid = widget.artInfo['submitted_with_free_cerdit'];
      artUserID = widget.artInfo['art']['artist_id'].toString();
    });
  }

  void _handleResponse(int response) {
    setState(() {
      _radioValue = response;
      if (response == 1)
        _accepted = true;
      else
        _accepted = false;
    });
  }

  Future _submitComment() async {
    if (comment.length < 50) {
      /// TODO  display error message
      return;
    }

    String acceptVal = 'declined';
    if (_accepted)
      acceptVal = 'accepted';

    final DocumentReference postRef = widget.snapshot.data.documents[widget.index].reference;
    await Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = widget.snapshot.data.documents[widget.index]; //await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{'replied': true});
        await tx.update(postRef, <String, dynamic>{'submission_response.radios': acceptVal});
        await tx.update(postRef, <String, dynamic>{'submission_response.response': comment});
      }
    });
  }


  final commentBar = SnackBar(content: Text('Please write a longer response. (min. 50 characters)'));

  void onEditComplete() {
    comment = _controller.text;
    comment.isEmpty ? _submitEnabled = false : _submitEnabled = true;
    // bool hasFocus = _textFieldNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    _controller.addListener(onEditComplete);
    _textFieldNode.addListener(onEditComplete);

    return new Scaffold(
      appBar: AppBar(
        title: Text('Submit Feedback'),
        backgroundColor: Color.fromRGBO(255, 160, 0, 1.0),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: new Center(
        child: new ListView(children: <Widget>[
          new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0)),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: MediaQuery.of(context).size.width * .75,
                child: new Image.network(
                  artImage,
                  //'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1024px-Cat03.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),
              new Container(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                  alignment: FractionalOffset(.15, .85),
                  child: new Text(
                    artTitle + " by " + artArtist,
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.5,
                    //style: TextStyle(fontStyle: FontStyle.italic),
                  )),
              new Container(
                width: MediaQuery.of(context).size.width * .75,
                child: new TextField(
                  controller: _controller,
                  focusNode: _textFieldNode,
                  maxLines: 8,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      enabledBorder: new OutlineInputBorder(
                          borderSide:
                              new BorderSide(color: Colors.transparent)),
                      disabledBorder: new OutlineInputBorder(
                          borderSide:
                              new BorderSide(color: Colors.transparent)),
                      hintText: 'Your Response*'),
                ),
              ),
              new Column(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleResponse),
                      Text('Accept'),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                          value: -1,
                          groupValue: _radioValue,
                          onChanged: _handleResponse),
                      Text('Decline'),
                    ],
                  ),
                ],
              ),
              new Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0)),
              new Container(
                width: MediaQuery.of(context).size.width * .75,
                height: MediaQuery.of(context).size.width * .08,
                child: new OutlineButton(
                  splashColor:
                      _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                  textColor:
                      _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                  child: new Text('Submit Response'),
                  onPressed: () async {
                    await _submitComment();
                    Navigator.of(context).pop();
                  },
                  borderSide: new BorderSide(
                    color:
                        _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
            ],
          ),
        ]),
      ),
    );
  }
}
