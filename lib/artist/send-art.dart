import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/selectBusiness.dart';

class SendArt extends StatefulWidget {
  var snapshot;
  int index;

  SendArt({@required this.snapshot, this.index});

  @override
  _SendArtState createState() => new _SendArtState();
}

class _SendArtState extends State<SendArt> {
  FocusNode _textFieldNode = new FocusNode();
  TextEditingController _controller = new TextEditingController();
  String comment;
  bool _submitEnabled = false;
  String _bUID = 'n/a';
  String _busName = 'n/a';

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

  void _submitArtwork() {
    /// TODO Submit the art to a business
    Navigator.pop(context);
  }

  Future _navBusiness() async {
    final businessInfo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BusinessSelect()),
    );

    setState(() {
      if (businessInfo != null) {
        _busName = businessInfo[0];
        _bUID = businessInfo[1];
        _submitEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                ),
              ),
              new Padding(padding: EdgeInsets.fromLTRB(5.0, 30.0, 0.0, 0.0)),
              new Container(
                width: MediaQuery.of(context).size.width * .75,
                height: MediaQuery.of(context).size.width * .08,
                child: new OutlineButton(
                  splashColor: Colors.deepOrangeAccent,
                  textColor: Colors.deepOrangeAccent,
                  child: new Text('Select a Business'),
                  onPressed: () async {
                    await _navBusiness();
                  },
                  borderSide: new BorderSide(
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              new Text(
                'Sent to: ' + _busName,
              ),
              new Padding(padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0)),
              new Container(
                width: MediaQuery.of(context).size.width * .75,
                height: MediaQuery.of(context).size.width * .08,
                child: new OutlineButton(
                  splashColor:
                      _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                  textColor:
                      _submitEnabled ? Colors.deepOrangeAccent : Colors.grey,
                  child: new Text('Submit Artwork'),
                  onPressed: () {
                    _submitArtwork();
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
