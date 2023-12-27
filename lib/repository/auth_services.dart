import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/utils/utils.dart';

class AuthService {
  UserCredential? user;
  Future<UserCredential?> createUser(
      BuildContext context, Map<String, String> data) async {
    try {
      user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email']!,
        password: data['password']!,
      );
      return user;
    } catch (e) {
      throw FirebaseAuthException(
          message: "Sign Up Failed", code: e.toString());
    }
  }

  Future<void> loginUser(Map<String, String> data) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email']!,
        password: data['password']!,
      );
    } catch (e) {
      throw FirebaseAuthException(message: "Login Error", code: e.toString());
    }
  }

  Future<dynamic> logOut (BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
