import 'package:flutter_test/flutter_test.dart';
import 'package:share_yourself_artists_team_flutter/artist/artistProfile/editArtist.dart';
import 'package:share_yourself_artists_team_flutter/business/businessProfile/editBusiness.dart';

void main() {
  EditBusiness testBusiness = new EditBusiness();
  EditArtist testArtist = new EditArtist();

  test('getData() for businesses matches the expected values', () {
    Future _getUser() async {
      await testBusiness.getData('yekGAvzU5fZKh49e6w0tJuRmFFg1');
      await testArtist.getData('928uyJ9NQzeVwoJucuOuHF9epAp2');

      String businessName = testBusiness.getBusinessName();
      String artistName = testArtist.getArtistName();

      expect(businessName == null, false);
      expect(artistName == null, false);
    }

    _getUser();
  });
}
