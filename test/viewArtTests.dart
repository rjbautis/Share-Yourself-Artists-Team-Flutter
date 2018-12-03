import 'package:test/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_yourself_artists_team_flutter/artist/viewArt.dart';

void main () {
  Stream<QuerySnapshot> snap = Firestore.instance
      .collection('review_requests')
      .where('art.artist_id', isEqualTo: '928uyJ9NQzeVwoJucuOuHF9epAp2')
      .snapshots();

  ArtistViewArt testArt = new ArtistViewArt(snapshot: snap, index: 0,);

  test('getData() matches the expected values', () {
    //String title =
  });
}