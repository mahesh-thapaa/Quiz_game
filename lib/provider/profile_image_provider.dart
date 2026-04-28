import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileImageProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String _avatarUrl = '';
  bool _isLoading = false;

  String get avatarUrl => _avatarUrl;
  bool get isLoading => _isLoading;

  String? get _uid => _auth.currentUser?.uid;

  /// Loads the current user's avatar URL from Firestore
  Future<void> loadAvatar() async {
    final uid = _uid;
    if (uid == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _db.collection('user').doc(uid).get();
      if (doc.exists) {
        _avatarUrl = doc.data()?['avatarUrl'] as String? ?? '';
      }
    } catch (e) {
      debugPrint('❌ loadAvatar error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Manually update the avatar URL in state (called after successful upload)
  void setAvatarUrl(String url) {
    _avatarUrl = url;
    notifyListeners();
  }

  /// Clear the avatar URL in state (called after deletion)
  void removeAvatar() {
    _avatarUrl = '';
    notifyListeners();
  }

  /// Clear all state (on logout)
  void clear() {
    _avatarUrl = '';
    _isLoading = false;
    notifyListeners();
  }
}
