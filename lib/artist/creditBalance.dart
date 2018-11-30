import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

class CreditStore extends StatefulWidget {

  @override
  _CreditStoreState createState() => _CreditStoreState();

}

class _CreditStoreState extends State<CreditStore>
{

  String _uid;
  String _tempUID = "03qvS7nVXFZ4Mm07jZjcKcJSUxW2";

  int _freeCredits;
  int _paidCredits;

  Future _getCredits() async{
    DocumentSnapshot ds = await Firestore.instance.collection('users').document('$_uid').get();
    int fc = ds['free_credits'];
    int pc = ds['credits'];

    setState(() {
      _freeCredits = fc;
      _paidCredits = pc;
    });

  }

  Future _reduceCredits() async{

    _getCredits();

    DocumentReference ref = Firestore.instance.collection('users').document('$_uid');

    int fc = _freeCredits;
    int pc = _paidCredits;

    if(fc > 0)
    {

      fc--;
      await Firestore.instance.collection('users').document('$_uid').updateData({ 'free_credits': fc});

    }
    else
    {
      print("\n\nERROR in freeCredits: can't deduct from 0 credits\n\n");
    }

    if(pc > 0)
    {
      pc--;
      await Firestore.instance.collection('users').document('$_uid').updateData({ 'credits': pc});
    }
    else
    {
      print("\n\nERROR in paidCredits: can't deduct from 0 credits\n\n");
    }

    setState(() {
      _freeCredits = fc;
      _paidCredits = pc;
    });

  }

  @override
  void initState() {
    super.initState();

    // Grab the saved uid of current user from memory
    loadUid().then((uid) {
      print('init: current uid: $uid');
      setState(() {
        _uid = uid;
      });
    });
  }

  Widget _displayCredits(){
    return new Container(
        child: Column(
          children: <Widget>[
            new Padding( padding: const EdgeInsets.only(top: 40.0)),
            new Text("Credit Balance for User $_uid"),
            new Padding( padding: const EdgeInsets.only(top: 40.0)),
            new Text("Free Credits: $_freeCredits"),
            new Padding( padding: const EdgeInsets.only(top: 40.0)),
            new Text("Paid Credits: $_paidCredits"),

          ],
        )
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: new Text('Buy Credits')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 160, 0, 1.0),
              ),
              accountName: new Text('Artist'),
              accountEmail: new Text('gmail.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Text('T'),
              ),
            ),
            ListTile(
              title: new Text('Log Out'),
              onTap: () async {
                Navigator.pop(
                    context); // Need to pop context (specifically for this page)

//                await widget.authentication.signOut();
//                widget.handleSignOut();
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: Image.asset('images/logo.png'),
              padding: const EdgeInsets.all(20.0),
            ),
            _displayCredits(),
            Container(
              padding: const EdgeInsets.only(top: 40.0),
              child: new MaterialButton(
                child: const Text('Get Credits'),
                color: Color.fromRGBO(255, 160, 0, 1.0),
                textColor: Colors.white,
                elevation: 4.0,
                onPressed: () async{
                  await _getCredits();
                },
                minWidth: 200.0,
                height: 50.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40.0),
              child: new MaterialButton(
                child: const Text('Reduce Credits'),
                color: Color.fromRGBO(255, 160, 0, 1.0),
                textColor: Colors.white,
                elevation: 4.0,
                onPressed: () async{
                  await _reduceCredits();
                },
                minWidth: 200.0,
                height: 50.0,
              ),
            ),
          ],
        ),
      ),
    );

  }

}