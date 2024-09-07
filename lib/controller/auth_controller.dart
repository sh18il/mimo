import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mimo_to/model/auth_model.dart';
import 'package:mimo_to/service/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;
  UserModel? userModel;
  Future<User?> signup(BuildContext context, String username, String email,
      String password) async {
    user = await _authService.signup(context, username, email, password);
    notifyListeners();
    return user;
  }

  Future<User?> signin(
      BuildContext context, String email, String password) async {
    user = await _authService.signin(context, email, password);
    notifyListeners();
    return user;
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    await _authService.sendEmailVerification(context);
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    await _authService.forgotPassword(context, email);
  }

  Future<UserModel?> getUserData(BuildContext context, String userId) async {
    try {
      userModel = await _authService.getUserData(context, userId);
      notifyListeners();

      return userModel;
    } catch (e) {
      ShowSnackBar(context, "Error fetching user data: $e");
      return null;
    }
  }
}
