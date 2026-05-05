
import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Adding scopes as recommended in google_sign_in examples.
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  User? _user;

  User? get currentUser => _user;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e, s) {
      developer.log(
        'Sign-in with email failed',
        name: 'AuthService',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e, s) {
      developer.log(
        'Create user with email failed',
        name: 'AuthService',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        developer.log('Google sign-in cancelled by user', name: 'AuthService');
        return null; // User cancelled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // The accessToken and idToken getters should exist.
      // If the error persists, it's an environment issue.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e, s) {
      developer.log(
        'Sign-in with Google failed',
        name: 'AuthService',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e, s) {
       developer.log(
        'Error signing out',
        name: 'AuthService',
        error: e,
        stackTrace: s,
      );
    }
  }
}
