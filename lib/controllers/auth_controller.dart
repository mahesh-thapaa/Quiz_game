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

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<void> sendVerificationEmail() async {
    try {
      final user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        debugPrint('📧 Verification email sent to ${user.email}');
      }
    } catch (e) {
      debugPrint('❌ Failed to send verification email: $e');
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      await _auth.currentUser?.reload();

      final verified = _auth.currentUser?.emailVerified ?? false;

      notifyListeners();

      return verified;
    } catch (e) {
      debugPrint('❌ checkEmailVerified error: $e');

      return false;
    }
  }

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
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Reload user
      await credential.user?.reload();

      final freshUser = _auth.currentUser;

      if (freshUser != null && !freshUser.emailVerified) {
        _errorMessage = 'Please verify your email before logging in.';

        setLoading(false);

        return false;
      }

      setLoading(false);

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("LOGIN ERROR CODE: ${e.code}");

      debugPrint("LOGIN ERROR MSG: ${e.message}");

      _errorMessage = _friendlyError(e.code);

      setLoading(false);

      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';

      setLoading(false);

      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    setLoading(true);

    _errorMessage = '';

    try {
      final credential = await _auth.signInAnonymously();

      final uid = credential.user!.uid;

      debugPrint('👤 Anonymous Auth Success: UID = $uid');

      final userDoc = await _db.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        debugPrint('🆕 Creating new guest document...');

        await _db.collection('users').doc(uid).set({
          'uid': uid,
          'username': 'Guest',
          'bio': 'Playing as Guest',
          'Coin': 0,
          'XP': 0,
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
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Guest login Firebase error: ${e.code}');

      if (e.code == 'admin-restricted-operation') {
        _errorMessage = 'Anonymous sign-in is disabled in Firebase Console.';
      } else {
        _errorMessage = e.message ?? 'Guest login failed. Please try again.';
      }

      setLoading(false);

      return false;
    } catch (e) {
      debugPrint('❌ Guest login failed: $e');

      _errorMessage = 'Guest login failed: ${e.toString()}';

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
      final cleanUsername = username.trim().toLowerCase();

      final usernameDoc = await _db
          .collection('usernames')
          .doc(cleanUsername)
          .get();

      if (usernameDoc.exists) {
        final existingUid = usernameDoc.data()?['uid'];

        if (existingUid != null && existingUid != user?.uid) {
          _errorMessage = 'Username already taken';

          setLoading(false);

          return false;
        }
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password.trim(),
      );

      UserCredential userCredential;

      if (wasGuest) {
        debugPrint('🔗 Linking guest account...');

        userCredential = await user.linkWithCredential(credential);
      } else {
        debugPrint('🆕 Creating new account...');

        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      }

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        _errorMessage = 'Failed to create account.';

        setLoading(false);

        return false;
      }

      final uid = firebaseUser.uid;

      await firebaseUser.updateDisplayName(username.trim());

      await firebaseUser.reload();

      debugPrint('✨ Account Ready: UID = $uid');

      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'username': username.trim(),
        'email': email.trim(),
        'isGuest': false,

        if (!wasGuest) ...{
          'bio': '',
          'avatarUrl': '',
          'Coin': 0,
          'XP': 0,
          'Stars': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'CompletedSections': 0,
          'QuizLevelsInSection': 0,
        },
      }, SetOptions(merge: true));

      await _db.collection('usernames').doc(cleanUsername).set({'uid': uid});

      await StreakController.onLogin();

      await firebaseUser.sendEmailVerification();

      debugPrint('📧 Verification email sent to ${firebaseUser.email}');

      setLoading(false);

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ SIGNUP ERROR: ${e.code}');

      _errorMessage = _friendlyError(e.code);

      setLoading(false);

      return false;
    } catch (e) {
      debugPrint('❌ SIGNUP ERROR: $e');

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
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Incorrect email or password';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'No internet connection.';

      case 'email-already-in-use':
        return 'An account with this email already exists.';

      case 'weak-password':
        return 'Password must be at least 6 characters.';

      default:
        return 'Incorrect email or password';
    }
  }
}
