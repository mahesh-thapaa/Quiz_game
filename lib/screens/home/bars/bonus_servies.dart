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

  // ── Check if today's bonus is already claimed (Resets at 7:00 AM) ──────────
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

    // Calculate the most recent 7:00 AM reset point
    DateTime lastReset;
    if (now.hour >= 7) {
      lastReset = DateTime(now.year, now.month, now.day, 7);
    } else {
      lastReset = DateTime(now.year, now.month, now.day - 1, 7);
    }

    // If last claim was AFTER the last reset, it's already claimed for this window
    return lastDate.isAfter(lastReset);
  }

  // ── Claim bonus: add coins to Firestore, return NEW total coins ───────────
  static Future<int> claimBonus({int bonusCoins = 100}) async {
    final uid = _uid;
    if (uid == null) throw Exception('User not logged in');

    final ref = _db.collection('user').doc(uid);

    final newCoins = await _db.runTransaction<int>((txn) async {
      final snap = await txn.get(ref);
      final data = snap.data() ?? {};

      // Guard: Check reset window inside transaction
      final lastClaimed = data['lastBonusClaimed'];
      if (lastClaimed != null) {
        final lastDate = (lastClaimed as Timestamp).toDate();
        final now = DateTime.now();
        
        DateTime lastReset;
        if (now.hour >= 7) {
          lastReset = DateTime(now.year, now.month, now.day, 7);
        } else {
          lastReset = DateTime(now.year, now.month, now.day - 1, 7);
        }

        if (lastDate.isAfter(lastReset)) {
          throw AlreadyClaimedException();
        }
      }

      final currentCoins = data['Coin'] as int? ?? 0;
      final updated = currentCoins + bonusCoins;

      txn.update(ref, {
        'Coin': updated,
        'lastBonusClaimed': FieldValue.serverTimestamp(),
      });

      return updated;
    });

    return newCoins;
  }
}
