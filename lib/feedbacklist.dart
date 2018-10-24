import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedbackList extends StatefulWidget {

  @override
  _FeedbackListState createState() => new _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  FocusNode _textFieldNode = new FocusNode();
  TextEditingController _controller = new TextEditingController();
  String comment;
  String _imageUrl = 'https://vignette.wikia.nocookie.net/citrus/images/6/60/No_Image_Available.png/revision/latest/scale-to-width-down/480?cb=20170129011325';
  bool _submitEnabled = false;

  @override
  void initState() {
    setState(() {
      _fetchImage();
    });
  }

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

  void _submitComment() {
    setState(() {
      // Things to submit
      // Comment, UserID, Date
      // submit the comment in the textbox
      if (comment == null || comment == "")
      {
        // display error message

      }
      print(comment);
    });
  }

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
      body: new Center(
        child: new ListView(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0)),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    height: MediaQuery.of(context).size.width*.75,
                    child: new Image.network(
                      _imageUrl,
                      //'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1024px-Cat03.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(5.0)),
                  new Container(
                      alignment: FractionalOffset(.15, .85),
                      child: new Text(
                        'Le Chat',
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.5,
                        //style: TextStyle(fontStyle: FontStyle.italic),
                      )
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width*.75,
                    child: new TextField(
                      controller: _controller,
                      focusNode: _textFieldNode,
                      maxLines: 8,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          enabledBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.transparent)
                          ),
                          disabledBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.transparent)
                          ),
                          hintText: 'Submit feedback.'
                      ),
                    ),
                  ),
                  new Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0)),
                  new Container(
                    width: MediaQuery.of(context).size.width*.75,
                    height: MediaQuery.of(context).size.width*.08,
                    child: new OutlineButton(
                      splashColor: _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                      textColor: _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                      child: new Text('Edit Info'),
                      onPressed: _submitComment,
                      borderSide: new BorderSide(
                        color: _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                      ),
                    ),
                  ),
                  new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0)),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
