// lib/controllers/level_progress_services.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LevelProgressService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  /// Loads the number of stars and best score earned for every level in a category
  static Future<Map<int, Map<String, int>>> loadAllLevelProgress({
    required String category,
  }) async {
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

      final Map<int, Map<String, int>> results = {};
      for (var doc in snap.docs) {
        final data = doc.data();
        final levelNum = data['levelNumber'] as int?;
        final stars = data['starsEarned'] as int? ?? 0;
        final score = data['bestScore'] as int? ?? 0;
        if (levelNum != null) {
          results[levelNum] = {'stars': stars, 'bestScore': score};
        }
      }
      return results;
    } catch (e) {
      debugPrint('❌ loadAllLevelProgress error: $e');
      return {};
    }
  }

  /// Saves the stars and best score earned for a specific level
  static Future<void> saveLevelProgress({
    required String category,
    required int levelNumber,
    required int starsEarned,
    required int bestScore,
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
        'bestScore': bestScore,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint(
        '✅ Progress saved: Cat:$category | Lvl:$levelNumber | Stars:$starsEarned | Score:$bestScore',
      );
    } catch (e) {
      debugPrint('❌ saveLevelStars error: $e');
    }
  }
}
