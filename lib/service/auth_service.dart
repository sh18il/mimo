import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mimo_to/model/auth_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signup(BuildContext context, String username, String email,
      String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          username: username,
          email: email,
          uid: user.uid,
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toJson());

        await sendEmailVerification(context);
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.message.toString());
      return null;
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      ShowSnackBar(context, "Email verification sent");
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.message!);
    }
  }

  Future<User?> signin(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.message.toString());
      return null;
    }
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to send email')),
      );
    }
  }

  Future<UserModel?> getUserData(BuildContext context, String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      ShowSnackBar(context, "Getting data error: $e");
    }
    return null;
  }
}

void ShowSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
