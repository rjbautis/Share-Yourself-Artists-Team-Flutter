import 'package:flutter_test/flutter_test.dart';
import 'package:share_yourself_artists_team_flutter/artist/artistProfile/editArtist.dart';

void main() {
  EditArtist testArtist = new EditArtist();

  test('getData() for businesses matches the expected values', () {
    Future _getUser() async {
      await testArtist.getData('928uyJ9NQzeVwoJucuOuHF9epAp2');
      String artistEmail = testArtist.getArtistName();
      expect(artistEmail, "yilang@ucsc.edu");
    }

    _getUser();
  });
}
