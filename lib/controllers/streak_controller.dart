// lib/controllers/streak_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_game/models/home_models/streak_model.dart';

class StreakController {
  static const String _streakPath = 'streaks';
  static const String streakTitle = '7 Day Streak';
  static const int totalDaysPerCycle = 7;

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  static Future<StreakModel> load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return _createNewStreak();

    final ref = FirebaseFirestore.instance
        .collection(_streakPath)
        .doc(user.uid);
    final snapshot = await ref.get();

    if (!snapshot.exists) return _createNewStreak();

    final data = snapshot.data();
    if (data == null) return _createNewStreak();

    return StreakModel(
      title: streakTitle,
      currentDay: data['currentDay'] as int? ?? 0,
      totalDays: totalDaysPerCycle,
      rewardClaimed: data['rewardClaimed'] as bool? ?? false,
    );
  }

  static Future<StreakModel> onLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return _createNewStreak();

    final ref = FirebaseFirestore.instance
        .collection(_streakPath)
        .doc(user.uid);
    final snapshot = await ref.get();

    final today = _dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    Map<String, dynamic> currentData = snapshot.data() ?? {};
    int currentDay = currentData['currentDay'] as int? ?? 0;
    bool rewardClaimed = currentData['rewardClaimed'] as bool? ?? false;
    final String? lastLoginDateStr = currentData['lastLoginDate'] as String?;

    final DateTime? lastDateOnly = lastLoginDateStr != null
        ? _dateOnly(DateTime.parse(lastLoginDateStr))
        : null;

    bool justCompleted = false;

    if (lastDateOnly == null) {
      currentDay = 1;
      rewardClaimed = false;
    } else if (lastDateOnly == today) {
      // Already logged in today - just return current state
      // 🚀 BOOTSTRAP: If it's somehow 0 (new user or old reset logic), start at Day 1
      if (currentDay == 0) currentDay = 1;
    } else if (lastDateOnly == yesterday) {
      // Consecutive day
      if (currentDay >= totalDaysPerCycle) {
        // Cycle completed previously, reset for new cycle
        currentDay = 1;
        rewardClaimed = false;
      } else {
        currentDay++;
        if (currentDay == totalDaysPerCycle) {
          justCompleted = true;
          rewardClaimed = false;
        }
      }
    } else {
      // Missed days - reset
      currentDay = 1;
      rewardClaimed = false;
    }

    await ref.set({
      'currentDay': currentDay,
      'lastLoginDate': today.toIso8601String(),
      'totalDays': totalDaysPerCycle,
      'rewardClaimed': rewardClaimed,
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    return StreakModel(
      title: streakTitle,
      currentDay: currentDay,
      totalDays: totalDaysPerCycle,
      rewardClaimed: rewardClaimed,
      justCompleted: justCompleted,
    );
  }

  static Future<void> claimReward() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance
        .collection(_streakPath)
        .doc(user.uid);
    await ref.update({'rewardClaimed': true});
  }

  static Future<void> reset() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection(_streakPath)
        .doc(user.uid)
        .delete();
  }

  static Future<void> resetAfterCompletion() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance
        .collection(_streakPath)
        .doc(user.uid);
    await ref.set({
      'currentDay': totalDaysPerCycle,
      'rewardClaimed': true,
      'lastLoginDate': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  static StreakModel _createNewStreak() {
    return const StreakModel(
      title: streakTitle,
      currentDay: 0,
      totalDays: totalDaysPerCycle,
      rewardClaimed: false,
    );
  }
}
