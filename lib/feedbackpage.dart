import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  final Map<String, dynamic> artInfo;

  FeedbackPage({@required this.artInfo});

  @override
  _FeedbackPageState createState() => new _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
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
      artImage = widget.artInfo["url"];
      artTitle = widget.artInfo["title"];
      artArtist = widget.artInfo["artist"];
      artReplied = widget.artInfo["replied"];
      artPaid = widget.artInfo["paid"];
      artUserID = widget.artInfo["id"];
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

  void _submitComment() {
    setState(() {
      // Things to submit
      // Comment, UserID, Date
      // submit the comment in the textbox
      if (comment == null || comment == "")
      {
        // display error message

      }
      print(_accepted);
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
      appBar: AppBar(
        title: Text('Submit Feedback'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: new Center(
        child: new ListView(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0)),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    height: MediaQuery.of(context).size.width*.75,
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
                          hintText: 'Your Response*'
                      ),
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
                              onChanged: _handleResponse
                          ),
                          Text('Accept'),
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                              value: -1,
                              groupValue: _radioValue,
                              onChanged: _handleResponse
                          ),
                          Text('Decline'),
                        ],
                      ),
                    ],
                  ),
                  new Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0)),
                  new Container(
                    width: MediaQuery.of(context).size.width*.75,
                    height: MediaQuery.of(context).size.width*.08,
                    child: new OutlineButton(
                      splashColor: _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                      textColor: _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                      child: new Text('Submit Response'),
                      onPressed: _submitComment,
                      borderSide: new BorderSide(
                        color: _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                      ),
                    ),
                  ),
                  new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
