// lib/screens/streak/streak_logic.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_game/models/home_models/streak_model.dart';

class LoginStreakResult {
  final StreakModel streak;
  final bool justCompletedCycle;

  LoginStreakResult({required this.streak, required this.justCompletedCycle});
}

class StreakLogic {
  static const String _streakPath = 'streaks';
  static const String streakTitle = '7 Day Streak';
  static const int totalDaysPerCycle = 7;

  // ── Helper: strip time, keep date only ─────────────────────────────────────
  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  static Future<StreakModel> load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('📖 StreakLogic.load() - Reading from Firestore');
    debugPrint('   User ID: ${user.uid}');
    debugPrint('   Path: $_streakPath/${user.uid}');

    final ref = FirebaseFirestore.instance.collection(_streakPath).doc(user.uid);
    final snapshot = await ref.get();

    debugPrint('');
    debugPrint('📦 Raw snapshot data:');
    debugPrint('   → snapshot.exists: ${snapshot.exists}');
    debugPrint('   → snapshot.data(): ${snapshot.data()}');

    if (!snapshot.exists) {
      debugPrint('   ⚠️  No data found in database - creating new streak');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('');
      return _createNewStreak();
    }

    final data = snapshot.data();
    if (data == null) {
      debugPrint('   ⚠️  Data is NULL - creating new streak');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('');
      return _createNewStreak();
    }

    debugPrint('');
    debugPrint('📊 Parsed database fields:');
    debugPrint('   → All keys: ${data.keys.toList()}');
    debugPrint(
      '   → currentDay (raw): ${data['currentDay']} (type: ${data['currentDay'].runtimeType})',
    );
    debugPrint('   → lastLoginDate: ${data['lastLoginDate']}');
    debugPrint('   → totalDays: ${data['totalDays']}');
    debugPrint('   → updatedAt: ${data['updatedAt']}');

    final currentDayValue = data['currentDay'] as int? ?? 0;
    debugPrint('');
    debugPrint('✅ Final currentDay being returned: $currentDayValue');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('');

    return StreakModel(
      title: streakTitle,
      currentDay: currentDayValue,
      totalDays: totalDaysPerCycle,
    );
  }

  static Future<LoginStreakResult> onLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    debugPrint('');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('🔄 StreakLogic.onLogin() - Processing login');
    debugPrint('   User ID: ${user.uid}');

    final ref = FirebaseFirestore.instance.collection(_streakPath).doc(user.uid);
    final snapshot = await ref.get();

    debugPrint('');
    debugPrint('📦 Raw snapshot from database:');
    debugPrint('   → exists: ${snapshot.exists}');
    debugPrint('   → data(): ${snapshot.data()}');

    final today = _dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    Map<String, dynamic> currentData = {};
    if (snapshot.exists) {
      currentData = snapshot.data() ?? {};
    }

    final currentDayFromDB = currentData['currentDay'] as int? ?? 0;
    final String? lastLoginDateStr = currentData['lastLoginDate'] as String?;

    debugPrint('');
    debugPrint('📊 Current data from database:');
    debugPrint('   → currentDay: $currentDayFromDB');
    debugPrint('   → lastLoginDate: $lastLoginDateStr');
    debugPrint('');
    debugPrint('📅 Today: $today');
    debugPrint('📅 Yesterday: $yesterday');

    // Parse stored date and strip time
    final DateTime? lastDateOnly = lastLoginDateStr != null
        ? _dateOnly(DateTime.parse(lastLoginDateStr))
        : null;

    debugPrint('📅 lastDateOnly (parsed): $lastDateOnly');

    int currentDay = currentDayFromDB;
    bool justCompletedCycle = false;

    debugPrint('');
    debugPrint('🔍 Login logic check:');

    if (lastDateOnly == null) {
      // First ever login
      debugPrint('   → Case: FIRST EVER LOGIN (no lastLoginDate in DB)');
      debugPrint('   → Setting: currentDay = 1');
      currentDay = 1;
    } else if (lastDateOnly == today) {
      // Already logged in today → do nothing
      debugPrint('   → Case: ALREADY LOGGED IN TODAY');
      debugPrint('   → Setting: NO CHANGE (currentDay stays $currentDay)');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('');
      return LoginStreakResult(
        streak: StreakModel(
          title: streakTitle,
          currentDay: currentDay,
          totalDays: totalDaysPerCycle,
        ),
        justCompletedCycle: false,
      );
    } else if (lastDateOnly == yesterday) {
      // Consecutive day → increment
      debugPrint('   → Case: CONSECUTIVE DAY (logged in yesterday)');
      currentDay = (currentDay % totalDaysPerCycle) + 1;
      debugPrint(
        '   → Subcase: Incrementing (was $currentDayFromDB, now $currentDay)',
      );

      // Check if we just completed the cycle
      if (currentDay == 1) {
        justCompletedCycle = true;
        debugPrint('   → ✅ CYCLE COMPLETED! Resetting to day 1');
      }
    } else {
      // Missed one or more days → reset
      debugPrint('   → Case: MISSED DAYS (gap between last login)');
      debugPrint('   → Setting: RESET to day 1');
      currentDay = 1;
    }

    debugPrint('');
    debugPrint('💾 Final values before saving to DB:');
    debugPrint('   → currentDay: $currentDay');
    debugPrint('   → lastLoginDate: ${today.toIso8601String()}');
    debugPrint('   → justCompletedCycle: $justCompletedCycle');

    await ref.set({
      'currentDay': currentDay,
      'lastLoginDate': today.toIso8601String(),
      'totalDays': totalDaysPerCycle,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    debugPrint('');
    debugPrint('✅ Saved to Firestore Database');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('');

    return LoginStreakResult(
      streak: StreakModel(
        title: streakTitle,
        currentDay: currentDay,
        totalDays: totalDaysPerCycle,
      ),
      justCompletedCycle: justCompletedCycle,
    );
  }

  static Future<void> reset() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance.collection(_streakPath).doc(user.uid);
    await ref.delete();
  }

  static StreakModel _createNewStreak() {
    return const StreakModel(
      title: streakTitle,
      currentDay: 0,
      totalDays: totalDaysPerCycle,
    );
  }
}
