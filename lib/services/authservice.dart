import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/screens/loading_page.dart';
import 'package:firebase_authentication/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future signUp(String email, String password, String name, File? file) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        final imageUrl = await DBService().uploadFile(file);
        await DBService(uid: user.uid).storeUsertoDB(email, name, imageUrl);
      }
      return user;
    } on FirebaseAuthException catch (_) {
      return null;
    }
  }

  void showDialogue(BuildContext context) {
    showDialog(
        context: context, builder: (BuildContext context) => LoadingPage());
  }

  void hideProgressDialogue(BuildContext context) {
    Navigator.of(context).pop(LoadingPage());
  }

  Future signinWithGoogle() async {
    try {
      final googleUSer = await googleSignIn.signIn();
      final googleAuth = await googleUSer?.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(cred);
      User? user = userCredential.user;
      if (user != null) {
        await DBService(uid: user.uid).storeUsertoDB(
            googleUSer!.email, googleUSer.displayName!, googleUSer.photoUrl!);
      }
      return user;
    } on Exception catch (_) {
      return null;
    }
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (_) {
      return null;
    }
  }

  Future signOut() async {
    try {
      if (googleSignIn.currentUser != null) {
        await googleSignIn.disconnect();
      }
      await _auth.signOut();
    } on FirebaseAuthException catch (_) {
      log("Something is wrong");
    }
  }
}
