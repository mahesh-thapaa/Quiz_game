// lib/services/level_progess_services.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LevelProgressService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  /// Loads the number of stars earned for every level in a category
  static Future<Map<int, int>> loadAllLevelStars({required String category}) async {
    final uid = _uid;
    if (uid == null) return {};

    try {
      final snap = await _db
          .collection('user_progress')
          .doc(uid)
          .collection('categories')
          .doc(category)
          .collection('levels')
          .get();

      final Map<int, int> results = {};
      for (var doc in snap.docs) {
        final data = doc.data();
        final levelNum = data['levelNumber'] as int?;
        final stars = data['starsEarned'] as int?;
        if (levelNum != null && stars != null) {
          results[levelNum] = stars;
        }
      }
      return results;
    } catch (e) {
      debugPrint('❌ loadAllLevelStars error: $e');
      return {};
    }
  }

  /// Saves the stars earned for a specific level
  static Future<void> saveLevelStars({
    required String category,
    required int levelNumber,
    required int starsEarned,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      await _db
          .collection('user_progress')
          .doc(uid)
          .collection('categories')
          .doc(category)
          .collection('levels')
          .doc(levelNumber.toString())
          .set({
        'levelNumber': levelNumber,
        'starsEarned': starsEarned,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      debugPrint('✅ Progress saved: Cat:$category | Lvl:$levelNumber | Stars:$starsEarned');
    } catch (e) {
      debugPrint('❌ saveLevelStars error: $e');
    }
  }
}
