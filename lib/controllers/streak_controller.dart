// lib/controllers/streak_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_game/models/home_models/streak_model.dart';
import 'package:timezone/timezone.dart' as tz;

class StreakController {
  static const String _collection = 'streaks';

  static const String streakTitle = '7 Day Streak';
  static const int totalDaysPerCycle = 7;

  static tz.Location get _ktm => tz.getLocation('Asia/Kathmandu');

  static DateTime _dateOnly(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  static Future<StreakModel> load() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) {
      return _newStreak();
    }

    final ref = FirebaseFirestore.instance
        .collection(_collection)
        .doc(user.uid);

    final snap = await ref.get();

    if (!snap.exists) {
      return _newStreak();
    }

    final data = snap.data() ?? {};

    return StreakModel(
      title: streakTitle,
      currentDay: data['currentDay'] as int? ?? 0,
      totalDays: totalDaysPerCycle,
      rewardClaimed: data['rewardClaimed'] as bool? ?? false,
      justCompleted: false,
    );
  }

  static Future<StreakModel> onLogin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) {
      return _newStreak();
    }

    final ref = FirebaseFirestore.instance
        .collection(_collection)
        .doc(user.uid);

    final snap = await ref.get();
    final data = snap.data() ?? {};

    final now = tz.TZDateTime.now(_ktm);
    final today = _dateOnly(now);
    final yesterday = today.subtract(const Duration(days: 1));

    int currentDay = data['currentDay'] as int? ?? 0;
    bool rewardClaimed = data['rewardClaimed'] as bool? ?? false;
    bool justCompleted = false;

    final String? lastLoginDate = data['lastLoginDate'] as String?;

    DateTime? lastDate;
    if (lastLoginDate != null) {
      lastDate = _dateOnly(DateTime.parse(lastLoginDate));
    }

    // First login ever
    if (lastDate == null) {
      currentDay = 1;
      rewardClaimed = false;
    }
    // Already logged today
    else if (lastDate == today) {
      if (currentDay == 0) currentDay = 1;
    }
    // Consecutive day
    else if (lastDate == yesterday) {
      if (currentDay >= totalDaysPerCycle) {
        // Completed yesterday -> start new cycle today
        currentDay = 1;
        rewardClaimed = false;
      } else {
        currentDay++;

        if (currentDay == totalDaysPerCycle) {
          justCompleted = true;
          rewardClaimed = false;
        }
      }
    }
    // Missed one or more days
    else {
      currentDay = 1;
      rewardClaimed = false;
    }

    await ref.set({
      'currentDay': currentDay,
      'rewardClaimed': rewardClaimed,
      'lastLoginDate': today.toIso8601String(),
      'updatedAt': FieldValue.serverTimestamp(),
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

    if (user == null || user.isAnonymous) return;

    await FirebaseFirestore.instance.collection(_collection).doc(user.uid).set({
      'rewardClaimed': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // IMPORTANT: keep 7/7 today, tomorrow becomes 1 automatically
  static Future<void> resetAfterCompletion() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) return;

    final now = tz.TZDateTime.now(_ktm);
    final today = _dateOnly(now);

    await FirebaseFirestore.instance.collection(_collection).doc(user.uid).set({
      'currentDay': totalDaysPerCycle,
      'rewardClaimed': true,
      'lastLoginDate': today.toIso8601String(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> reset() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) return;

    await FirebaseFirestore.instance
        .collection(_collection)
        .doc(user.uid)
        .delete();
  }

  static StreakModel _newStreak() {
    return const StreakModel(
      title: streakTitle,
      currentDay: 0,
      totalDays: totalDaysPerCycle,
      rewardClaimed: false,
      justCompleted: false,
    );
  }
}
