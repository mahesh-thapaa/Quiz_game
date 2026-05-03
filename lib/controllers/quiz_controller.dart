import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';
import 'package:quiz_game/controllers/level_progess_services.dart';

class QuizController {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetches all questions and progress for a specific category
  static Future<Map<String, dynamic>> loadQuizData({
    required String categoryId,
    required String firestoreName,
    String? quizId,
  }) async {
    final Map<String, List<QuizQuestion>> questionsByLevel = {};
    final Map<int, String> levelDocIds = {};
    final Map<int, String> bonusSlotToDocId = {};

    try {
      // 1. Load progress
      final progress = await LevelProgressService.loadAllLevelStars(
        category: categoryId,
      );

      // 2. Fetch Quiz Metadata from Firestore
      DocumentSnapshot? quizDoc;

      if (quizId != null && quizId.isNotEmpty && quizId.length > 15) {
        // Fetch directly by ID if it looks like a Firestore ID
        final snap = await _db.collection('quizzes').doc(quizId).get();
        if (snap.exists) quizDoc = snap;
      }

      if (quizDoc == null) {
        // Fallback to category search
        final quizSnap = await _db
            .collection('quizzes')
            .where('category', isEqualTo: firestoreName)
            .limit(1)
            .get();
        if (quizSnap.docs.isNotEmpty) quizDoc = quizSnap.docs.first;
      }

      if (quizDoc != null) {
        final levelsSnap = await quizDoc.reference.collection('levels').get();

        int bonusCounter = 0;
        for (var doc in levelsSnap.docs) {
          final data = doc.data();

          // Try to get level number from field, fallback to doc ID
          int num = data['levelNumber'] ?? int.tryParse(doc.id) ?? 0;
          final bool isBonus = data['isBonus'] ?? false;

          if (isBonus) {
            bonusSlotToDocId[bonusCounter++] = doc.id;
          } else if (num > 0) {
            levelDocIds[num] = doc.id;
          }
        }
      }

      return {
        'progress': progress,
        'levelDocIds': levelDocIds,
        'bonusSlotToDocId': bonusSlotToDocId,
        'quizDocReference': quizDoc?.reference, // Store for future question fetching
      };
    } catch (e) {
      debugPrint('❌ QuizController Error: $e');
      return {
        'progress': {},
        'levelDocIds': {},
        'bonusSlotToDocId': {},
      };
    }
  }

  /// Fetches questions for a specific level document ID on-demand
  static Future<List<QuizQuestion>> fetchQuestionsForLevelId({
    required DocumentReference quizDocRef,
    required String levelDocId,
  }) async {
    try {
      final qSnap = await quizDocRef
          .collection('levels')
          .doc(levelDocId)
          .collection('questions')
          .get();
      return qSnap.docs.map((q) => QuizQuestion.fromMap(q.data())).toList();
    } catch (e) {
      debugPrint('❌ fetchQuestionsForLevelId Error: $e');
      return [];
    }
  }

  /// Fetches questions from all categories and shuffles them for Quick Quiz
  static Future<Map<String, dynamic>> loadQuickQuizData({
    required int userLevel,
    required int userCoins,
  }) async {
    final Map<String, List<QuizQuestion>> questionsByLevel = {};
    final Map<int, String> levelDocIds = {};
    final Map<int, String> bonusSlotToDocId = {};
    const String categoryId = 'quick_quiz';

    try {
      final progress = await LevelProgressService.loadAllLevelStars(
        category: categoryId,
      );

      // 1. Core categories (always unlocked)
      final List<String> categories = [
        'Player Quiz',
        'Stadium Quiz',
        'Jersey Quiz',
        'Logo Master',
      ];

      // 2. Conditional categories (Home)
      if (userLevel >= 5) categories.add('Legend Quiz');
      if (userCoins >= 1000) categories.add('National Quiz');
      if (userLevel >= 7) categories.add('Manager Quiz');
      if (userCoins >= 5000) categories.add('Transfer Quiz');

      // 3. Discover categories
      if (userLevel >= 9) categories.add("Ballon d'Or Quiz");
      if (userCoins >= 10000) categories.add('World Cup');
      if (userLevel >= 11) categories.add('Goalkeeper Legends');
      if (userCoins >= 20000) categories.add('Golden Boot');

      List<QuizQuestion> allQuestions = [];

      for (String cat in categories) {
        final quizSnap = await _db
            .collection('quizzes')
            .where('category', isEqualTo: cat)
            .limit(1)
            .get();

        if (quizSnap.docs.isNotEmpty) {
          final levelsSnap = await quizSnap.docs.first.reference
              .collection('levels')
              .limit(10) // Take more levels for more variety
              .get();

          for (var doc in levelsSnap.docs) {
            final qSnap = await doc.reference.collection('questions').get();
            allQuestions.addAll(
              qSnap.docs.map((q) => QuizQuestion.fromMap(q.data())).toList(),
            );
          }
        }
      }

      allQuestions.shuffle();

      // Distribute shuffled questions into regular levels and bonus levels
      const int questionsPerLevel = 10;
      int maxGridPos = 48; // Max grid positions

      int regularCounter = 1;
      int bonusCounter = 0;

      for (int pos = 1; pos <= maxGridPos; pos++) {
        final start = (pos - 1) * questionsPerLevel;
        final end = pos * questionsPerLevel;

        if (end > allQuestions.length) break; // Stop if we run out of questions

        final levelId = 'quick_level_$pos';
        questionsByLevel[levelId] = allQuestions.sublist(start, end);

        if (pos % 6 == 0) {
          bonusSlotToDocId[bonusCounter++] = levelId;
        } else {
          levelDocIds[regularCounter++] = levelId;
        }
      }

      return {
        'progress': progress,
        'questionsByLevel': questionsByLevel,
        'levelDocIds': levelDocIds,
        'bonusSlotToDocId': bonusSlotToDocId,
      };
    } catch (e) {
      debugPrint('❌ loadQuickQuizData Error: $e');
      return {
        'progress': {},
        'questionsByLevel': {},
        'levelDocIds': {},
        'bonusSlotToDocId': {},
      };
    }
  }

  /// Calculates the gameplay title (e.g. LEVEL 1 or BONUS LEVEL 1)
  static String getLevelTitle(int gridPos, {String? categoryId}) {
    if (gridPos % 6 == 0) {
      return "BONUS LEVEL ${gridPos ~/ 6}";
    } else {
      return "LEVEL ${gridPos - (gridPos ~/ 6)}";
    }
  }

  /// Determines if a specific grid position is a bonus level
  static bool isBonusLevel(int gridPos, {String? categoryId}) {
    return gridPos % 6 == 0;
  }
}
