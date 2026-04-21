import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProgressProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  int _coins = 0;
  int _xp = 0;
  int _stars = 0;
  bool _loading = false;

  String _username = '';
  String _bio = '';
  String _avatarPath = '';

  static const int totalSections = 4;
  static const int quizLevelsPerSection = 48;
  static const int coinsOnStreakComplete = 500;

  int _completedSections = 0;
  int _quizLevelsInSection = 0;

  int get coins => _coins;
  int get xp => _xp;
  int get stars => _stars;
  bool get isLoading => _loading;

  String get username => _username;
  String get bio => _bio;
  String get avatarPath => _avatarPath;

  int get level => _completedSections + 1;
  int get currentLevelXP => _quizLevelsInSection;
  int get maxLevelXP => quizLevelsPerSection;
  double get xpProgress => _quizLevelsInSection / quizLevelsPerSection;
  bool get allSectionsCompleted => _completedSections >= totalSections;

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
      _stars = data['Stars'] as int? ?? 0;
      _username = data['username'] as String? ?? '';
      _bio = data['bio'] as String? ?? '';
      _avatarPath = data['avatarPath'] as String? ?? '';
      _completedSections = data['CompletedSections'] as int? ?? 0;
      _quizLevelsInSection = data['QuizLevelsInSection'] as int? ?? 0;

      _completedSections = _completedSections.clamp(0, totalSections);
      _quizLevelsInSection = _quizLevelsInSection.clamp(
        0,
        quizLevelsPerSection,
      );

      debugPrint(
        '✅ loadFromFirestore → username:$_username | coins:$_coins | level:$level',
      );
    } catch (e) {
      debugPrint('❌ loadFromFirestore: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── ✅ ADDED: Wipes all in-memory state ────────────────────────────────────
  // Call this before FirebaseAuth.signOut() so the next user
  // never sees the previous user's username / coins / level.
  void clearData() {
    _coins = 0;
    _xp = 0;
    _stars = 0;
    _username = '';
    _bio = '';
    _avatarPath = '';
    _completedSections = 0;
    _quizLevelsInSection = 0;
    _loading = false;
    notifyListeners();
    debugPrint('🧹 clearData → all user state wiped');
  }

  // ── ✅ ADDED: Wipe then reload (use in HomeScreen.initState) ───────────────
  // Guarantees the screen always shows the currently logged-in user's data.
  Future<void> clearAndReload() async {
    clearData();
    await loadFromFirestore();
  }

  // ── Update profile ──────────────────────────────────────────────────────────
  Future<void> updateProfile({
    required String username,
    String? bio,
    String? avatarPath,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final trimmed = username.trim();
    if (trimmed.isEmpty) return;

    _username = trimmed;
    if (bio != null) _bio = bio.trim();
    if (avatarPath != null && avatarPath.isNotEmpty) _avatarPath = avatarPath;

    notifyListeners();

    try {
      await _db.collection('user').doc(uid).set({
        'username': _username,
        if (bio != null) 'bio': _bio,
        if (avatarPath != null && avatarPath.isNotEmpty)
          'avatarPath': _avatarPath,
      }, SetOptions(merge: true));

      debugPrint(
        '✅ updateProfile → username:$_username | bio:$_bio | avatarPath:$_avatarPath',
      );
    } catch (e) {
      debugPrint('❌ updateProfile error: $e');
    }
  }

  // ── Quiz level completed ────────────────────────────────────────────────────
  Future<void> onQuizLevelCompleted({
    int customCoins = 0,
    int customXP = 0,
    int earnedStars = 0,
  }) async {
    if (allSectionsCompleted) return;

    _coins += customCoins;
    _xp += customXP;
    _stars += earnedStars;
    _quizLevelsInSection++;

    if (_quizLevelsInSection >= quizLevelsPerSection) {
      _quizLevelsInSection = 0;
      _completedSections++;
      debugPrint('🏆 Section completed! Level up → level $level');
    }

    notifyListeners();
    await _sync();
  }

  // ── Streak completed ────────────────────────────────────────────────────────
  Future<void> onStreakCompleted() async {
    _coins += coinsOnStreakComplete;
    notifyListeners();
    await _sync();
  }

  // ── Manually update coins ───────────────────────────────────────────────────
  void updateCoins(int newCoins) {
    _coins = newCoins;
    notifyListeners();
  }

  // ── Sync to Firestore ───────────────────────────────────────────────────────
  Future<void> _sync() async {
    final uid = _uid;
    if (uid == null) return;

    try {
      await _db.collection('user').doc(uid).set({
        'Coin': _coins,
        'XP': _xp,
        'Level': level,
        'Stars': _stars,
        'CompletedSections': _completedSections,
        'QuizLevelsInSection': _quizLevelsInSection,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('❌ _sync error: $e');
    }
  }
}
