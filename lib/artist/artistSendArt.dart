import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/selectBusiness.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class ArtistSendArt extends StatefulWidget {
  var snapshot;
  int index;

  ArtistSendArt({@required this.snapshot, this.index});

  @override
  _ArtistSendArtState createState() => new _ArtistSendArtState();
}

class _ArtistSendArtState extends State<ArtistSendArt> {
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

  int _freeCredits;
  int _paidCredits;
  bool freeSubmit;
  bool paid = false;

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
      artistName = widget.snapshot.data.documents[widget.index]['artist_name']
          .toString();
      uploadDate = widget.snapshot.data.documents[widget.index]['upload_date'];

      loadUid().then((uid) {
        artUserID = uid;
        _getArtistInfo();
      });
    });
  }

  Future<void> _submitArtwork() async {
    _reduceCredits();

    if (!paid) {
      /// TODO: Display an error snackbar
      print('not submitted');
      return;
    }

    await Firestore.instance.collection('review_requests').document().setData({
      'art': {
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
      'submitted_with_free_cerdit': freeSubmit,
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
        _paidCredits = artist['credits'];
        _freeCredits = artist['free_credits'];
      });
    }
  }

  Future _reduceCredits() async {
    DocumentReference ref =
        Firestore.instance.collection('users').document(artUserID);

    int fc = _freeCredits;
    int pc = _paidCredits;

    bool _paid = false;
    bool _freeSubmit = false;

    if (fc == null) fc = 0;

    if (pc == null) pc = 0;

    if (fc > 0) {
      fc--;
      await Firestore.instance
          .collection('users')
          .document(artUserID)
          .updateData({'free_credits': fc});
      _paid = true;
      _freeSubmit = true;
    } else {
      print("\n\nERROR in freeCredits: can't deduct from 0 credits\n\n");
    }

    if (pc > 0 && !paid) {
      pc--;
      await Firestore.instance
          .collection('users')
          .document(artUserID)
          .updateData({'credits': pc});
      _paid = true;
      _freeSubmit = false;
    } else {
      print("\n\nERROR in paidCredits: can't deduct from 0 credits\n\n");
    }

    setState(() {
      _freeCredits = fc;
      _paidCredits = pc;
      paid = _paid;
      freeSubmit = _freeSubmit;
    });
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
        title: new Image.asset('images/logo.png'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
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
              new ListTile(
                title: Text('Available Free Credits'),
                subtitle: Text(_freeCredits.toString()),
              ),
              new ListTile(
                title: Text('Available Credits'),
                subtitle: Text(_paidCredits.toString()),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
