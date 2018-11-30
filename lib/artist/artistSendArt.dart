import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/selectBusiness.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

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
  String _bUID = 'n/a';
  String _busName = 'n/a';
  String _busEmail = 'n/a';

  String artImage;
  String artTitle;
  String artDescription;
  String artUserID;
  String artistName;
  String artistEmail;
  int uploadDate;

  int credits;
  int freeCredits;

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
      artistName = widget
          .snapshot.data.documents[widget.index]['artist_name'].toString();
      uploadDate = widget.snapshot.data.documents[widget.index]['upload_date'];

      loadUid().then((uid) {
        artUserID = uid;
        _getArtistInfo();
      });
    });
  }

  Future<void> _submitArtwork() async {
    bool freeCerd = true;

    /*if (freeCredits > 0)
    {
      freeCerd = true;
      _decrementFree();
    } else if (credits > 0)
    {
      freeCerd = false;
      _decrementPaid();
    } else
    {
      /// TODO Display Error Message
      print('Not enough credits');
      return null;
    }*/

    await Firestore.instance.collection('review_requests').document().setData(
        {
          'art':{
            'art_title': artTitle,
            'artist_id': artUserID,
            'artist_name': artistName,
            'description': artDescription,
            'upload_date': uploadDate,
            'url': artImage,
          },

          'artist_email': artistEmail,

          'businessId': {
            'business_email': _busEmail,
            'business_name': _busName,
            'userId': _bUID,
          },

          'read_byartist': false,
          'refunded': 0,
          'replied': false,
          'submitted_with_free_cerdit': freeCerd,
        });

    Navigator.pop(context);
  }

  Future _getArtistInfo() async {
    DocumentSnapshot artist =
    await Firestore.instance.collection('users').document(artUserID).get();
    if (artist.exists) {
      print("exists");
      setState(() {
        artistEmail = artist['email'];
        credits = artist['credits'];
        freeCredits = artist['free_credits'];
      });
    }
  }

  Future<void> _decrementFree() async {
    /// TODO Decrement free_credit count

  }

  Future<void> _decrementPaid() async {
    /// TODO Decrement credit count

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
        _busEmail = businessInfo[2];
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
