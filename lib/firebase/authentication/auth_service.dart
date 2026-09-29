import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// sign up
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      debugPrint("Sign up Error: $e");
      return null;
    }
  }

  /// sign in
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      debugPrint("Sign In Error: $e");
      return null;
    }
  }

  /// password recovery / reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      debugPrint("Reset Password Error $e");
      return false;
    }
  }

  /// Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      /// google initialized with Web Client ID
      await googleSignIn.initialize(
        serverClientId: '40882805489-e4m9j1mtkloe560iuf4rl9to5oa7ubjv.apps.googleusercontent.com',
      );

      /// new authenticate
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      /// access token scope authorization
      final List<String> scopes = ['email', 'profile'];
      final clientAuth = await googleUser.authorizationClient.authorizeScopes(
        scopes,
      );

      /// credential create for firebase
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
        accessToken: clientAuth.accessToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint("google sign-in error $e");
    }
    return null;
  }

  /// log out
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}
