import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Updates the user's password after re-authenticating with the current password.
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in.',
      );
    }

    if (currentPassword == newPassword) {
      throw FirebaseAuthException(
        code: 'same-password',
        message: 'New password must be different from the old one.',
      );
    }

    // 1. Re-authenticate the user
    AuthCredential credential = EmailAuthProvider.credential(
      email: email.trim(),
      password: currentPassword,
    );

    try {
      // This is required by Firebase for sensitive actions like password change
      await user.reauthenticateWithCredential(credential);

      // 2. Update the password
      await user.updatePassword(newPassword);
      
      debugPrint('✅ Password updated successfully for user: ${user.uid}');
    } catch (e) {
      debugPrint('❌ changePassword error: $e');
      rethrow;
    }
  }
}
