import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_game/models/profile/leaderboardEntry_models.dart';

class LeaderboardProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<LeaderboardEntry> _allUsers = [];
  bool _loading = false;
  String? _error;

  StreamSubscription? _subscription;

  List<LeaderboardEntry> get allUsers => _allUsers;
  bool get isLoading => _loading;
  String? get error => _error;

  String? get _uid => _auth.currentUser?.uid;

  List<LeaderboardEntry> get top3 {
    // Get top 3 users overall
    final topThree = _allUsers.take(3).toList();

    // If current user is already in top 3, don't modify
    if (topThree.any((e) => e.isCurrentUser)) {
      return topThree;
    }

    // If current user is not in top 3, exclude them from the list
    return _allUsers.where((e) => !e.isCurrentUser).take(3).toList();
  }

  LeaderboardEntry? get currentUser =>
      _allUsers.where((e) => e.isCurrentUser).isNotEmpty
      ? _allUsers.firstWhere((e) => e.isCurrentUser)
      : null;

  int get currentUserRank => currentUser?.rank ?? _allUsers.length + 1;

  void listenLeaderboard() {
    final uid = _uid;
    if (uid == null) return;

    _loading = true;
    notifyListeners();

    _subscription?.cancel();

    _subscription = _db
        .collection('user')
        .snapshots()
        .listen(
          (snapshot) {
            final entries = snapshot.docs.map((doc) {
              final data = doc.data();
              final isMe = doc.id == uid;

              return LeaderboardEntry(
                username: data['username'] ?? '',
                name: data['username'] ?? 'Player',
                xpPoints: data['XP'] ?? 0,
                weeklyXP: data['XP'] ?? 0,
                level: data['Level'] ?? 1,
                coins: data['Coin'] ?? 0,
                bio: data['bio'] ?? '',
                avatarAsset: data['avatarPath'] ?? '',
                isCurrentUser: isMe,
                isVerified: false,
              );
            }).toList();

            // 🔥 Sort by XP
            entries.sort((a, b) => b.xpPoints.compareTo(a.xpPoints));

            // 🔥 Assign rank
            _allUsers = List.generate(entries.length, (i) {
              return entries[i].copyWith(rank: i + 1);
            });

            _loading = false;
            notifyListeners(); // 🔥 AUTO UI UPDATE
          },
          onError: (e) {
            _error = 'Failed to listen leaderboard';
            _loading = false;
            notifyListeners();
          },
        );
  }

  Future<void> load() async {
    final uid = _uid;
    if (uid == null) return;

    _loading = true;
    notifyListeners();

    try {
      final snapshot = await _db.collection('user').get();

      final entries = snapshot.docs.map((doc) {
        final data = doc.data();
        final isMe = doc.id == uid;

        return LeaderboardEntry(
          username: data['username'] ?? '',
          name: data['username'] ?? 'Player',
          xpPoints: data['XP'] ?? 0,
          weeklyXP: data['XP'] ?? 0,
          level: data['Level'] ?? 1,
          coins: data['Coin'] ?? 0,
          bio: data['bio'] ?? '',
          avatarAsset: data['avatarPath'] ?? '',
          isCurrentUser: isMe,
          isVerified: false,
        );
      }).toList();

      entries.sort((a, b) => b.xpPoints.compareTo(a.xpPoints));

      _allUsers = List.generate(entries.length, (i) {
        return entries[i].copyWith(rank: i + 1);
      });
    } catch (e) {
      _error = 'Failed to load leaderboard';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
