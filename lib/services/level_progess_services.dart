import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LevelProgressService {
  static final _db = FirebaseFirestore.instance;
  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static Future<void> saveLevelStars({
    required String category,
    required int levelNumber, // We pass the Grid Index (0-47) here
    required int starsEarned,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    await _db
        .collection('user')
        .doc(uid)
        .collection('level_progress')
        .doc('${category}_grid$levelNumber')
        .set({
          'levelNumber': levelNumber,
          'category': category,
          'starsEarned': starsEarned,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  static Future<Map<int, int>> loadAllLevelStars({
    required String category,
  }) async {
    final uid = _uid;
    if (uid == null) return {};
    final snap = await _db
        .collection('user')
        .doc(uid)
        .collection('level_progress')
        .where('category', isEqualTo: category)
        .get();

    final Map<int, int> result = {};
    for (final doc in snap.docs) {
      final data = doc.data();
      final level = data['levelNumber'] as int?;
      final stars = data['starsEarned'] as int?;
      if (level != null && stars != null) result[level] = stars;
    }
    return result;
  }
}
