import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_yourself_artists_team_flutter/business/provideFeedback.dart';

void main() {

  test('getData() matches the expected values', () {

    Future _fetchArt() async {
      DocumentSnapshot artInfo = await Firestore.instance
          .collection('review_requests')
          .document('-LSlOrwP-Xhy5TjdT8Dk').get();

      BusinessProvideFeedback testPage = new BusinessProvideFeedback(
        artInfo: artInfo,
        index: 0,
        snapshot: null,
      );

      testPage.getData();

      String title = testPage.getTitle();
      String artist = testPage.getArtist();

      expect(title != null, true);
      expect(artist != null, true);

      expect(title, "unit");
      expect(artist, "test");
    }

    _fetchArt();
  });

}
