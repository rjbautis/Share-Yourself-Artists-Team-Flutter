import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_storage/firebase_storage.dart';


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

//  static Future<String> signInWithFacebookAndFireBase() async {
//    final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
//    final FacebookLogin _facebook = FacebookLogin();
//
//    _facebook.loginBehavior = FacebookLoginBehavior.webViewOnly;
//
//    print('ji');
//
//    final FacebookLoginResult result = await _facebook.logInWithReadPermissions(['email']);
//
//    final FirebaseUser user = await _fireBaseAuth.signInWithFacebook(
//        accessToken: result.accessToken.token);
//
//    final FirebaseUser currentUser = await _fireBaseAuth.currentUser();
//    assert(user.uid == currentUser.uid);
//
//    return user.uid;
//  }

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

  static Future resetPassword(String email) async {
    final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
    await _fireBaseAuth.sendPasswordResetEmail(email: email);
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
      var data = {
        'credits': 0,
        'email': credentials['email'],
        'free_credits': 2,
        'name': credentials['name'],
        'role': 'artist',
        'upload_date': new DateTime.now().millisecondsSinceEpoch,
        'userId': user.uid,
        'instagram': credentials['instagram']
      };

      final filteredCredentials = _filterData(data);

      await Firestore.instance.collection('users').document(user.uid).setData(filteredCredentials);
      print('Finished creating user document for ${user.uid}');
    }

    return user.uid;
  }

  static Future<String> createBusinessAccount(Map<String, String> credentials, File image) async {
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

    // Upload logo to storage
    String logoUrl = await uploadFile(image, user.uid, 'logo', 'logo.png');
    String role = await Authentication.verifyUserDocument(user.uid);

    // If the user entry does not exist in the users collection, create that user
    if (role == '' && logoUrl != null) {
      var data = {
        'about': credentials['shortSummary'],
        'additional_notes': credentials['additionalNotes'],
        'business_name': credentials['name'],
        'email': credentials['email'],
        'facebook_url': credentials['facebook'],
        'follower_count': credentials['followerCount'],
        'instagram_url': credentials['instagram'],
        'publication': credentials['publicationName'],
        'role': 'business',
        'the_good': 'todo',
        'tumblr_url': credentials['tumblr'],
        'upload_date': new DateTime.now().millisecondsSinceEpoch,
        'url': logoUrl,
        'userId': user.uid,
        'worth_knowing': 'todo'
      };

      final filteredCredentials = _filterData(data);

      print(filteredCredentials);

      await Firestore.instance.collection('users').document(user.uid).setData(filteredCredentials);
      print('Finished creating user document for ${user.uid}');
    }

    return user.uid;
  }

  // Filter out all keys with empty string (i.e. optional)
  static Map<String, Object> _filterData(Map<String, Object> data) {
    return new Map.fromIterable(
        data.keys.where(
                (key) =>  data[key].toString() != ''),
        value: (key) => data[key]
    );
  }

  static Future<String> uploadFile(File image, String name, String dir, String pathLocation) async {
    String path;
    if (dir != '') {
      path = '$name/$dir/$pathLocation';
    } else {
      path = '$name/$pathLocation';
    }
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(path);
    StorageUploadTask task = firebaseStorageRef.putFile(image);

    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;

    // Try again if not successful
    while (!task.isSuccessful) {
      print('upload not complete, trying again');
      storageTaskSnapshot = await task.onComplete;
    }

    String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();

    if(downloadURL != null || downloadURL != "")
    {
      print("\n");
      print("\n");
      print("In uploadfile");
      print("SUCCESS!!!!!!");
      print("\n");
      print("\n");
    }
    else{
      print("\n");
      print("\n");
      print("In uploadfile");
      print("FAIL");
      print("\n");
      print("\n");
      return null;
    }
    return downloadURL;
  }

}
