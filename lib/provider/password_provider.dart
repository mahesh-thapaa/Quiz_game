import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_game/controllers/password_controller.dart';

class PasswordProvider with ChangeNotifier {
  final _controller = PasswordController();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _success = false;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get success => _success;

  void clearState() {
    _isLoading = false;
    _errorMessage = '';
    _success = false;
    notifyListeners();
  }

  Future<bool> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    _success = false;
    notifyListeners();

    try {
      await _controller.changePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _success = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'wrong-password':
        return 'The current password you entered is incorrect.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'same-password':
        return 'The new password cannot be the same as the old one.';
      case 'weak-password':
        return 'The new password is too weak.';
      case 'requires-recent-login':
        return 'Please login again and try changing your password.';
      default:
        return 'Failed to change password. Please check your details.';
    }
  }
}
