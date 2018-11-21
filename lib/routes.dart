import 'package:flutter/material.dart';
import 'package:share_yourself_artists_team_flutter/artist/artist-upload-image.dart';
import 'package:share_yourself_artists_team_flutter/authentication/artistSignUp.dart';
import 'package:share_yourself_artists_team_flutter/authentication/businessSignUp/businessSignUpFirstPage.dart';
import 'package:share_yourself_artists_team_flutter/authentication/forgotPassword.dart';
import 'package:share_yourself_artists_team_flutter/authentication/login.dart';
import 'package:share_yourself_artists_team_flutter/business/feedbacklist.dart';

final routes = {
  '/artist': (BuildContext context) => new ArtistUploadImage(),
  '/artistSignUp': (BuildContext context) => new ArtistSignUpPage(),
  '/business': (BuildContext context) => new FeedbackList(),
  '/businessSignUpFirst': (BuildContext context) => new BusinessSignUpFirstPage(),
  '/forgotPassword': (BuildContext context) => new ForgotPasswordPage(),
  '/': (BuildContext context) => new LoginPage()
};
