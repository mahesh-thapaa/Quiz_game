import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';
import 'package:quiz_game/services/level_progess_services.dart';

class QuizController {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetches all questions and progress for a specific category
  static Future<Map<String, dynamic>> loadQuizData({
    required String categoryId,
    required String firestoreName,
  }) async {
    final Map<String, List<QuizQuestion>> questionsByLevel = {};
    final Map<int, String> levelDocIds = {};
    final Map<int, String> bonusSlotToDocId = {};

    // 1. Load progress
    final progress = await LevelProgressService.loadAllLevelStars(
      category: categoryId,
    );

    // 2. Fetch Quiz Metadata from Firestore
    final quizSnap = await _db
        .collection('quizzes')
        .where('category', isEqualTo: firestoreName)
        .limit(1)
        .get();

    if (quizSnap.docs.isNotEmpty) {
      final levelsSnap = await quizSnap.docs.first.reference
          .collection('levels')
          .orderBy('order')
          .get();

      int bonusCounter = 0;
      for (var doc in levelsSnap.docs) {
        final data = doc.data();
        final int num = data['levelNumber'] ?? 0;
        final bool isBonus = data['isBonus'] ?? false;

        if (isBonus) {
          bonusSlotToDocId[bonusCounter++] = doc.id;
        } else {
          levelDocIds[num] = doc.id;
        }

        final qSnap = await doc.reference.collection('questions').orderBy('order').get();
        questionsByLevel[doc.id] = qSnap.docs.map((q) => QuizQuestion.fromMap(q.data())).toList();
      }
    }

    return {
      'progress': progress,
      'questionsByLevel': questionsByLevel,
      'levelDocIds': levelDocIds,
      'bonusSlotToDocId': bonusSlotToDocId,
    };
  }

  /// Calculates the gameplay title (e.g. LEVEL 1 or BONUS LEVEL 1)
  static String getLevelTitle(int gridPos) {
    if (gridPos % 6 == 0) {
      return "BONUS LEVEL ${gridPos ~/ 6}";
    } else {
      return "LEVEL ${gridPos - (gridPos ~/ 6)}";
    }
  }

  /// Determines if a specific grid position is a bonus level
  static bool isBonusLevel(int gridPos) => gridPos % 6 == 0;
}
