import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/artist-upload-image.dart';
import 'package:share_yourself_artists_team_flutter/authentication/artistSignUp.dart';
import 'package:share_yourself_artists_team_flutter/authentication/businessSignUp.dart';
import 'package:share_yourself_artists_team_flutter/authentication/login.dart';
import 'package:share_yourself_artists_team_flutter/business/feedbacklist.dart';
import 'package:share_yourself_artists_team_flutter/business/editbusiness.dart';

final routes = {
  '/login': (BuildContext context) => new LoginPage(),
  '/artist': (BuildContext context) => new ArtistUploadImage(),
  '/artistSignUp': (BuildContext context) => new ArtistSignUpPage(),
  '/business': (BuildContext context) => new FeedbackList(),
  '/businessSignUp': (BuildContext context) => new BusinessSignUpPage(),
  '/editBusiness': (BuildContext context) => new EditBusiness(),
  '/': (BuildContext context) => new LoginPage()
};
