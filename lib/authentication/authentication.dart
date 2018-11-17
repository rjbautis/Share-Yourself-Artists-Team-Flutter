import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  /// Returns boolean value if the user had previously signed in
  ///
  /// Checks if the [GoogleSignInAccount] or [FirebaseUser] instance is not null.
  static Future<bool> alreadySignedIn() async {
    final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount existingGoogleUser;
    FirebaseUser existingFireBaseUser = await _fireBaseAuth.currentUser();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      existingGoogleUser = account;
    });

    // Try to sign in silently (if user had already signed in with Google)
    await _googleSignIn.signInSilently();

    if (existingFireBaseUser != null || existingGoogleUser != null) {
      return true;
    }
    return false;
  }

  static Future<String> signInWithGoogleAndFireBase() async {
    final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final FirebaseUser user = await _fireBaseAuth.signInWithGoogle(
        idToken: googleAuth.idToken, accessToken: googleAuth.idToken);

    final FirebaseUser currentUser = await _fireBaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    return user.uid;
  }

  static Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user;
    final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;

    try {
      user = await _fireBaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      print(user);

      return user.uid;
    } catch (e) {
      print("Error signing in with email and password");
      print(e.toString());
      return "";
    }
  }

  /// Returns the role of the user from in Firestore
  ///
  /// Performs a query against the 'users' collection and returns role of user.
  /// Returns empty string otherwise
  static Future<String> verifyUserDocument(String uid) async {
    print('the uid is $uid');

    final DocumentReference reference =
        Firestore.instance.collection('users').document(uid);
    DocumentSnapshot snapshot = await reference.get();

    if (snapshot.exists) {
      print(snapshot.data);
      return snapshot['role'];
    }
    return '';
  }

  static Future<void> signOut() async {
    final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    print("Attempting to sign out user.");
    await _googleSignIn.signOut();
    await _fireBaseAuth.signOut();
  }

  static Future<String> createArtistAccount(Map<String, String> credentials) async {
    final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
    FirebaseUser user;

    try {
      user = await _fireBaseAuth
          .createUserWithEmailAndPassword(email: credentials['email'], password: credentials['password']);
    } catch (e) {
      print('Error when creating user: ${e.toString()}');
      return '';
    }

    assert(user != null);
    assert(await user.getIdToken() != null);

    String role = await Authentication.verifyUserDocument(user.uid);

    // If the user entry does not exist in the users collection, create that user
    if (role == '') {
      await Firestore.instance.collection('users').document(user.uid).setData({
        'credits': 0,
        'email': credentials['email'],
        'free_credits': 2,
        'name': credentials['name'],
        'role': 'artist',
        'upload_date': new DateTime.now().millisecondsSinceEpoch,
        'userId': user.uid
      });

      print('Finished creating user document for ${user.uid}');
    }

    return user.uid;
  }
}
