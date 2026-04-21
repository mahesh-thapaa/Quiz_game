// lib/screens/streak/streak_logic.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quiz_game/models/home_models/streak_model.dart';

class LoginStreakResult {
  final StreakModel streak;
  final bool justCompletedCycle;

  LoginStreakResult({required this.streak, required this.justCompletedCycle});
}

class StreakLogic {
  static const String _streakPath = 'streaks';
  static const int totalDaysPerCycle = 7;

  // ── Helper: strip time, keep date only ─────────────────────────────────────
  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  static Future<StreakModel> load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final ref = FirebaseDatabase.instance.ref('$_streakPath/${user.uid}');
    final snapshot = await ref.get();

    if (!snapshot.exists) return _createNewStreak();

    final data = snapshot.value as Map?;
    if (data == null) return _createNewStreak();

    return StreakModel(
      title: 'Daily Login Streak',
      currentDay: data['currentDay'] as int? ?? 0,
      totalDays: totalDaysPerCycle,
    );
  }

  static Future<LoginStreakResult> onLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final ref = FirebaseDatabase.instance.ref('$_streakPath/${user.uid}');
    final snapshot = await ref.get();

    final today = _dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    Map currentData = {};
    if (snapshot.exists) {
      currentData = snapshot.value as Map? ?? {};
    }

    int currentDay = currentData['currentDay'] as int? ?? 0;
    final String? lastLoginDateStr = currentData['lastLoginDate'] as String?;

    // Parse stored date and strip time
    final DateTime? lastDateOnly = lastLoginDateStr != null
        ? _dateOnly(DateTime.parse(lastLoginDateStr))
        : null;

    bool justCompletedCycle = false;

    debugPrint('📅 today: $today');
    debugPrint('📅 lastDateOnly: $lastDateOnly');
    debugPrint('📅 yesterday: $yesterday');

    if (lastDateOnly == null) {
      // First ever login
      debugPrint('🆕 First login → day 1');
      currentDay = 1;
    } else if (lastDateOnly == today) {
      // Already logged in today → do nothing
      debugPrint('✅ Already logged in today → no change');
      return LoginStreakResult(
        streak: StreakModel(
          title: 'Daily Login Streak',
          currentDay: currentDay,
          totalDays: totalDaysPerCycle,
        ),
        justCompletedCycle: false,
      );
    } else if (lastDateOnly == yesterday) {
      // Consecutive day → increment
      currentDay = (currentDay % totalDaysPerCycle) + 1;
      debugPrint('🔥 Consecutive day → currentDay: $currentDay');
      if (currentDay == 1) {
        justCompletedCycle = true;
        debugPrint('🎉 Cycle complete!');
      }
    } else {
      // Missed one or more days → reset
      debugPrint('💔 Missed days → reset to day 1');
      currentDay = 1;
    }

    await ref.set({
      'currentDay': currentDay,
      'lastLoginDate': today.toIso8601String(),
      'totalDays': totalDaysPerCycle,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return LoginStreakResult(
      streak: StreakModel(
        title: 'Daily Login Streak',
        currentDay: currentDay,
        totalDays: totalDaysPerCycle,
      ),
      justCompletedCycle: justCompletedCycle,
    );
  }

  static Future<void> reset() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseDatabase.instance.ref('$_streakPath/${user.uid}');
    await ref.remove();
  }

  static StreakModel _createNewStreak() {
    return const StreakModel(
      title: 'Daily Login Streak',
      currentDay: 0,
      totalDays: totalDaysPerCycle,
    );
  }
}
