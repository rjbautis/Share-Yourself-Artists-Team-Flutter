import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/artistDash.dart';
import 'package:share_yourself_artists_team_flutter/authentication/artistSignUp.dart';
import 'package:share_yourself_artists_team_flutter/authentication/businessSignUp/businessSignUpFirstPage.dart';
import 'package:share_yourself_artists_team_flutter/authentication/forgotPassword.dart';
import 'package:share_yourself_artists_team_flutter/authentication/login.dart';
import 'package:share_yourself_artists_team_flutter/business/businessDash.dart';
import 'package:share_yourself_artists_team_flutter/business/editbusiness.dart';
import 'package:share_yourself_artists_team_flutter/business/editbusiness.dart';

final routes = {
  '/artist': (BuildContext context) => new ArtistDash(),
  '/artistSignUp': (BuildContext context) => new ArtistSignUpPage(),
  '/business': (BuildContext context) => new BusinessDash(),
  '/businessSignUpFirst': (BuildContext context) =>
      new BusinessSignUpFirstPage(),
  '/forgotPassword': (BuildContext context) => new ForgotPasswordPage(),
  '/businessSignUp': (BuildContext context) => new BusinessSignUpPage(),
  '/editBusiness': (BuildContext context) => new EditBusiness(),
  '/': (BuildContext context) => new LoginPage()
};
