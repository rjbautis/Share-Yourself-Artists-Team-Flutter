import 'package:flutter_test/flutter_test.dart';
import 'package:share_yourself_artists_team_flutter/business/businessProfile/editBusiness.dart';

void main() {
  EditBusiness testBusiness = new EditBusiness();

  test('getData() for businesses matches the expected values', () {
    Future _getUser() async {
      await testBusiness.getData('yekGAvzU5fZKh49e6w0tJuRmFFg1');
      String businessEmail = testBusiness.getBusinessName();
      expect(businessEmail, "test@gmail.com");
    }

    _getUser();
  });
}
