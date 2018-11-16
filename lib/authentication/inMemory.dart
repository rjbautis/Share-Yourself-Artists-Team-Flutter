import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Saves the role and uid of logged-in user in memory
Future savePreferences(String role, String uid) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString('role', role);
  await sharedPreferences.setString('uid', uid);
}

Future<String> loadRole() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print('The role saved from disk is ' + sharedPreferences.getString('role'));
  return sharedPreferences.getString('role');
}

Future<String> loadUid() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print('The uid saved from disk is ' + sharedPreferences.getString('uid'));
  return sharedPreferences.getString('uid');
}

Future resetPreferences() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString('role', '');
  await sharedPreferences.setString('uid', '');
}
