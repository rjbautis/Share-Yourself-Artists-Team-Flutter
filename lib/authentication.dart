import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Returns boolean value if the user had previously signed in
  ///
  /// Checks if the [GoogleSignInAccount] or [FirebaseUser] instance is not null.
  Future<bool> alreadySignedIn() async {
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

  /// Returns the role of the user from in Firestore
  ///
  /// Performs a query against the 'users' collection and checks if the entry exists.
  /// If it does, return the role from the snapshot document.
  /// Otherwise, perform a transaction against the collection that creates a new document.
  Future<String> verifyUserDocument(String uid) async {
    print('the uid is $uid');

    final DocumentReference reference = Firestore.instance.collection('users').document(uid);
    DocumentSnapshot snapshot = await reference.get();

    if (snapshot.exists) {
      print(snapshot.data);
      return snapshot['role'];

    } else {
      print("User entry does not exist in Firestore.");

      var map = {
        "userId": "$uid",
        "role": "artist",
        "email": "dummyemail@ucsc.edu"
      };

      await Firestore.instance.runTransaction((transaction) async {
        try {
          await transaction.set(reference, map);
          print("Done creating user entry in Firestore.");
        } catch (e) {
          print("Firestore Exception: " + e);
          rethrow;
        }
      });
      return map['role'];
    }
  }

  Future<void> signOut() async {
    print("Inside signout");
    await _googleSignIn.signOut();
    await _fireBaseAuth.signOut();
  }
}