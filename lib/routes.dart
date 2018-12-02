import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/artistDash.dart';
import 'package:share_yourself_artists_team_flutter/artist/profilePage/artistProfilePage.dart';
import 'package:share_yourself_artists_team_flutter/artist/profilePage/editArtist.dart';
import 'package:share_yourself_artists_team_flutter/authentication/artistSignUp.dart';
import 'package:share_yourself_artists_team_flutter/authentication/businessSignUp/businessSignUpFirstPage.dart';
import 'package:share_yourself_artists_team_flutter/authentication/forgotPassword.dart';
import 'package:share_yourself_artists_team_flutter/authentication/login.dart';
import 'package:share_yourself_artists_team_flutter/business/businessDash.dart';
import 'package:share_yourself_artists_team_flutter/business/profilePage/businessProfilePage.dart';
import 'package:share_yourself_artists_team_flutter/business/profilePage/editBusiness.dart';
import 'package:share_yourself_artists_team_flutter/info/about.dart';
import 'package:share_yourself_artists_team_flutter/info/support.dart';

final routes = {
  '/artist': (BuildContext context) => new ArtistDash(),
  '/artistSignUp': (BuildContext context) => new ArtistSignUpPage(),
  '/business': (BuildContext context) => new BusinessDash(),
  '/businessSignUpFirst': (BuildContext context) =>
      new BusinessSignUpFirstPage(),
  '/forgotPassword': (BuildContext context) => new ForgotPasswordPage(),
  '/artistProfilePage': (BuildContext context) => new ArtistProfilePage(),
  '/businessProfilePage': (BuildContext context) => new BusinessProfilePage(),
  '/editBusiness': (BuildContext context) => new EditBusiness(),
  '/editArtist': (BuildContext context) => new EditArtist(),
  '/about': (BuildContext context) => new AboutPage(),
  '/support': (BuildContext context) => new SupportPage(),
  '/': (BuildContext context) => new LoginPage()
};
