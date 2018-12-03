import 'package:flutter_test/flutter_test.dart';
import 'package:share_yourself_artists_team_flutter/authentication/inMemory.dart';

void main (){
  test('Tests saving and loading data', () {
    Future _testMemory () async {
      savePreferences('dev', 'tester');

      String role = await loadRole();
      String uid = await loadUid();

      expect(role, 'dev');
      expect(uid, 'tester');

      resetPreferences();
    }

    _testMemory();
  });
}