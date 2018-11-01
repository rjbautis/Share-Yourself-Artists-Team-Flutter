import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  // Firebase and GoogleSignIn instances shared by all routes returned by Launch.dart
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Check sign in status (if user is logged in)
  Future<bool> alreadySignedIn() async {
    GoogleSignInAccount existingGoogleUser;
    FirebaseUser existingFireBaseUser = await _fireBaseAuth.currentUser();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      existingGoogleUser = account;
    });

    // Try to sign in silently (if user had already signed in with Google)
    await _googleSignIn.signInSilently();

    // If either Firebase user or Google user is not null then return the user already signed in
    if (existingFireBaseUser != null || existingGoogleUser != null) {
      return true;
    }
    return false;
  }

  // Sign in with Google using FireBase
  Future<String> signInWithGoogleAndFireBase() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final FirebaseUser user = await _fireBaseAuth.signInWithGoogle(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.idToken
    );

    final FirebaseUser currentUser = await _fireBaseAuth.currentUser();
    assert (user.uid == currentUser.uid);

    return user.uid;
  }

  // Sign in with Email and Password using FireBase
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser currentUser;

    try {
      currentUser = await _fireBaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return currentUser.uid;
    } catch (e) {
      print("Error signing in with email and password");
      return "";
    }
  }

  // Sign out from Google / Firebase
  Future<void> signOut() async {
    print("Inside signout");
    await _googleSignIn.disconnect();
    await _fireBaseAuth.signOut();
  }
}