// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/home/bars/bonus_servies.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlreadyClaimedException implements Exception {}

class BonusService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  // ── Check if today's bonus is already claimed ─────────────────────────────
  static Future<bool> hasClaimedToday() async {
    final uid = _uid;
    if (uid == null) return false;

    final doc = await _db.collection('user').doc(uid).get();
    final data = doc.data();
    if (data == null) return false;

    final lastClaimed = data['lastBonusClaimed'];
    if (lastClaimed == null) return false;

    final lastDate = (lastClaimed as Timestamp).toDate();
    final now = DateTime.now();

    // Same calendar day = already claimed
    return lastDate.year == now.year &&
        lastDate.month == now.month &&
        lastDate.day == now.day;
  }

  // ── Claim bonus: add coins to Firestore, return NEW total coins ───────────
  static Future<int> claimBonus({int bonusCoins = 100}) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    final ref = _db.collection('user').doc(uid);

    // Run inside a transaction so coins are always accurate
    final newCoins = await _db.runTransaction<int>((txn) async {
      final snap = await txn.get(ref);
      final data = snap.data() ?? {};

      // Guard: double-claim check inside transaction
      final lastClaimed = data['lastBonusClaimed'];
      if (lastClaimed != null) {
        final lastDate = (lastClaimed as Timestamp).toDate();
        final now = DateTime.now();
        final alreadyClaimed =
            lastDate.year == now.year &&
            lastDate.month == now.month &&
            lastDate.day == now.day;
        if (alreadyClaimed) throw AlreadyClaimedException();
      }

      final currentCoins = data['Coin'] as int? ?? 0;
      final updated = currentCoins + bonusCoins;

      txn.update(ref, {
        'Coin': updated, // ✅ adds to existing coins
        'lastBonusClaimed': FieldValue.serverTimestamp(), // ✅ marks today
      });

      return updated; // returns NEW total
    });

    return newCoins;
  }
}
