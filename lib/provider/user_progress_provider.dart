// ─────────────────────────────────────────────────────────────────────────────
// lib/models/user_progress_provider.dart
// ─────────────────────────────────────────────────────────────────────────────
// ✅ NO CHANGES NEEDED — your existing updateCoins() already works perfectly.
//
// When BonusService.claimBonus() returns the new total coins, DailyBonusCard
// calls:
//
//   context.read<UserProgressProvider>().updateCoins(newTotalCoins);
//
// Which hits this method in your provider:
//
//   void updateCoins(int newCoins) {
//     _coins = newCoins;   // ← replaces with new Firestore total
//     notifyListeners();   // ← top bar rebuilds instantly
//   }
//
// Your top bar widget just needs to read coins like this:
//
//   Consumer<UserProgressProvider>(
//     builder: (context, provider, _) {
//       return Text('${provider.coins}');  // ← auto-updates on claim
//     },
//   )
//
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProgressProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  int _coins = 0;
  int _xp = 0;
  int _level = 1;
  int _stars = 0;
  bool _loading = false;

  // ── Config ──────────────────────────────────────────────────────────────────
  static const int xpPerLevel = 100;
  static const int coinsPerCorrect = 5;
  static const int xpPerCorrect = 10;
  static const int coinsOnCompletion = 20;
  static const int xpOnCompletion = 30;
  static const int coinsOnStreakComplete = 50;

  // ── Getters ─────────────────────────────────────────────────────────────────
  int get coins => _coins;
  int get xp => _xp;
  int get level => _level;
  int get stars => _stars;
  bool get isLoading => _loading;
  double get xpProgress => (_xp % xpPerLevel) / xpPerLevel;
  int get currentLevelXP => _xp % xpPerLevel;
  int get maxLevelXP => xpPerLevel;

  String? get _uid => _auth.currentUser?.uid;

  // ── Load from Firestore ─────────────────────────────────────────────────────
  Future<void> loadFromFirestore() async {
    final uid = _uid;
    if (uid == null) return;

    _loading = true;
    notifyListeners();

    try {
      final doc = await _db.collection('user').doc(uid).get();
      final data = doc.data() ?? {};

      _coins = data['Coin'] as int? ?? 0;
      _xp = data['XP'] as int? ?? 0;
      _level = data['Level'] as int? ?? 1;
      _stars = data['Stars'] as int? ?? 0;
    } catch (e) {
      debugPrint('❌ loadFromFirestore: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Called on every correct answer ──────────────────────────────────────────
  Future<void> onCorrectAnswer() async {
    _coins += coinsPerCorrect;
    _xp += xpPerCorrect;
    _checkLevelUp();
    notifyListeners();
    await _sync();
  }

  // ── Called once when quiz ends ───────────────────────────────────────────────
  Future<void> onQuizCompleted({
    int correctAnswers = 0,
    int? customCoins,
    int? customXP,
    int earnedStars = 0,
  }) async {
    _coins += correctAnswers * coinsPerCorrect;
    _xp += correctAnswers * xpPerCorrect;
    _coins += customCoins ?? coinsOnCompletion;
    _xp += customXP ?? xpOnCompletion;
    _stars += earnedStars;
    _checkLevelUp();
    notifyListeners();
    await _sync();
  }

  // ── ✅ Called after daily bonus claim ────────────────────────────────────────
  // Receives the NEW total coins from Firestore (not just the bonus amount).
  // This guarantees the top bar always shows the correct Firestore value.
  void updateCoins(int newCoins) {
    _coins = newCoins;
    notifyListeners(); // ← top bar rebuilds automatically
  }

  // ── Called when 7-day streak is completed ───────────────────────────────────
  Future<void> onStreakCompleted() async {
    _coins += coinsOnStreakComplete;
    notifyListeners();
    await _sync();
  }

  // ── Internals ────────────────────────────────────────────────────────────────
  void _checkLevelUp() {
    final earned = (_xp ~/ xpPerLevel) + 1;
    if (earned > _level) _level = earned;
  }

  Future<void> _sync() async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _db.collection('user').doc(uid).update({
        'Coin': _coins,
        'XP': _xp,
        'Level': _level,
        'Stars': _stars,
      });
    } catch (e) {
      debugPrint('❌ _sync: $e');
    }
  }
}
