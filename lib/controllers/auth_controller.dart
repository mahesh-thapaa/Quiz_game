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

  /// Returns true if the currently signed-in user has verified their email.
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// Sends (or re-sends) a verification email to the current user.
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

  /// Reloads the Firebase user token and returns true if email is now verified.
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

      // ✅ Block unverified email users
      if (credential.user != null && !credential.user!.emailVerified) {
        _errorMessage =
            'Please verify your email before logging in. Check your inbox.';
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

  /// Guest Login: Persistent anonymous session
  Future<bool> signInAnonymously() async {
    setLoading(true);
    _errorMessage = '';
    try {
      final credential = await _auth.signInAnonymously();
      final uid = credential.user!.uid;
      debugPrint('👤 Anonymous Auth Success: UID = $uid');

      // Ensure a basic user document exists for the guest
      final userDoc = await _db.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        debugPrint('🆕 Creating new guest document in Firestore...');
        await _db.collection('users').doc(uid).set({
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
      debugPrint('❌ Guest login Firebase error: ${e.code} - ${e.message}');
      if (e.code == 'admin-restricted-operation') {
        _errorMessage =
            'Anonymous sign-in is disabled in your Firebase console. Please enable it in: Firebase Console -> Authentication -> Sign-in method.';
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

      // 1. Check if username is already taken
      final usernameDoc = await _db
          .collection('usernames')
          .doc(cleanUsername)
          .get();
      if (usernameDoc.exists) {
        final existingUid = usernameDoc.data()?['uid'];
        // If it's taken by someone ELSE, it's an error
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
        debugPrint('🔗 Linking guest account to email: $email');
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

      // Update or Create user record in 'users' collection
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'username': username.trim(),
        'email': email.trim(),
        'isGuest': false, // ✅ Convert to a fully registered user (no longer guest)
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

      // 2. Reserve the username
      await _db.collection('usernames').doc(cleanUsername).set({'uid': uid});

      // Initialize streak
      await StreakController.onLogin();

      // 📧 Send verification email so we know the address is real
      await userCredential.user?.sendEmailVerification();
      debugPrint('📧 Verification email sent to ${userCredential.user?.email}');

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
