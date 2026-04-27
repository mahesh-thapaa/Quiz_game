import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/controllers/streak_controller.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    setLoading(true);
    _errorMessage = '';

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _friendlyError(e.code);
      setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      setLoading(false);
      return false;
    }
  }

  /// Guest Login: Persistent anonymous session
  Future<bool> signInAnonymously() async {
    setLoading(true);
    _errorMessage = '';
    try {
      final credential = await _auth.signInAnonymously();
      final uid = credential.user!.uid;
      debugPrint('👤 Anonymous Auth Success: UID = $uid');

      // Ensure a basic user document exists for the guest
      final userDoc = await _db.collection('user').doc(uid).get();
      if (!userDoc.exists) {
        debugPrint('🆕 Creating new guest document in Firestore...');
        await _db.collection('user').doc(uid).set({
          'username': 'Guest',
          'bio': 'Playing as Guest',
          'Coin': 0,
          'XP': 0,
          'Level': 1,
          'Stars': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'CompletedSections': 0,
          'QuizLevelsInSection': 0,
          'isGuest': true,
        });
        debugPrint('✅ Guest document created successfully.');
      } else {
        debugPrint('🏠 Existing guest document found.');
      }

      setLoading(false);
      return true;
    } catch (e) {
      debugPrint('❌ Guest login failed: $e');
      _errorMessage = 'Guest login failed. Please try again.';
      setLoading(false);
      return false;
    }
  }

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
    required UserProgressProvider provider,
  }) async {
    setLoading(true);
    _errorMessage = '';

    final user = _auth.currentUser;
    final bool wasGuest = user != null && user.isAnonymous;

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password.trim(),
      );

      UserCredential userCredential;

      if (wasGuest) {
        debugPrint('🔗 Linking guest account to email: $email');
        // This upgrades the anonymous account to a permanent one
        // The UID stays the SAME, so all Firestore data stays!
        userCredential = await user.linkWithCredential(credential);
      } else {
        debugPrint('🆕 Creating new fresh account...');
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      }

      final uid = userCredential.user!.uid;
      debugPrint('✨ Account Ready: UID = $uid');

      // Update or Create user record
      await _db.collection('user').doc(uid).set({
        'username': username.trim(),
        'email': email.trim(),
        if (!wasGuest) ...{
          'bio': '',
          'Coin': 0,
          'XP': 0,
          'Level': 1,
          'Stars': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'CompletedSections': 0,
          'QuizLevelsInSection': 0,
        }
      }, SetOptions(merge: true));

      // Initialize streak
      await StreakController.onLogin();

      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _friendlyError(e.code);
      setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      setLoading(false);
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    _errorMessage = '';
    if (email.isEmpty || !email.contains('@')) {
      _errorMessage = 'Enter your email above to reset password.';
      notifyListeners();
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      _errorMessage = _friendlyError(e.code);
      notifyListeners();
      rethrow;
    } catch (e) {
      _errorMessage = 'Something went wrong.';
      notifyListeners();
      rethrow;
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
