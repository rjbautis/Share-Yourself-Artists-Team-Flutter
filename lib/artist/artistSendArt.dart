import 'package:flutter/material.dart';

class ArtistSendArt extends StatefulWidget {
  var snapshot;
  int index;

  ArtistSendArt({@required this.snapshot, this.index});

  @override
  _ArtistSendArtState createState() => new _ArtistSendArtState();
}

class _ArtistSendArtState extends State<ArtistSendArt> {
  FocusNode _textFieldNode = new FocusNode();
  TextEditingController _controller = new TextEditingController();
  String comment;
  bool _submitEnabled = false;
  bool _accepted = false;
  int _radioValue = -1;

  String artImage;
  String artTitle;
  String artDescription;
  String artUserID;

  @override
  void initState() {
    super.initState();
    setState(() {
      artImage = widget.snapshot.data.documents[widget.index]['url'].toString();
      artTitle =
          widget.snapshot.data.documents[widget.index]['art_title'].toString();
      artDescription = widget
          .snapshot.data.documents[widget.index]['description']
          .toString();
    });
  }

  void _submitComment() {
    if (comment.length < 50) {
      // display error message
      return;
    }

    setState(() {
      // Things to submit
      // Comment, UserID, Date
      // submit the comment in the textbox
      print(_accepted);
      print(comment);
    });
  }

  final commentBar = SnackBar(
      content: Text('Please write a longer response. (min. 50 characters)'));

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
        title: Text('Send to Business'),
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
                    artTitle + " - " + artDescription,
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.5,
                    //style: TextStyle(fontStyle: FontStyle.italic),
                  )),
              new Container(
                width: MediaQuery.of(context).size.width * .75,

                /// TODO Some way to select a business
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
                  child: new Text('Submit Artwork'),
                  onPressed: _submitComment,
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
