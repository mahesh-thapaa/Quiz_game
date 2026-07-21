import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_game/models/home_models/streak_model.dart';
import 'package:quiz_game/controllers/streak_controller.dart';

class UserProgressProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  int _coins = 0;
  int _xp = 0;
  int _stars = 0;
  bool _loading = false;

  String _username = '';
  String _bio = '';
  StreakModel? _streak;

  static const int totalSections = 4;
  static const int quizLevelsPerSection = 48;
  static const int coinsOnStreakComplete = 500;

  int _completedSections = 0;
  int _quizLevelsInSection = 0;
  List<String> _unlockedCategories = [];

  int get coins => _coins;
  int get xp => _xp;
  int get stars => _stars;
  bool get isLoading => _loading;

  String get username => _username;
  String get bio => _bio;
  StreakModel? get streak => _streak;
  List<String> get unlockedCategories => _unlockedCategories;

  int get level => _completedSections + 1;
  int get currentLevelXP => _quizLevelsInSection;
  int get maxLevelXP => quizLevelsPerSection;
  double get xpProgress => _quizLevelsInSection / quizLevelsPerSection;
  bool get allSectionsCompleted => _completedSections >= totalSections;

  String? get _uid => _auth.currentUser?.uid;

  // ── Load from Firestore ─────────────────────────────────────────────────────
  Future<void> loadFromFirestore() async {
    final uid = _uid;
    debugPrint('📖 loadFromFirestore starting for UID: $uid');

    if (uid == null) {
      debugPrint('⚠️ loadFromFirestore: No UID found, skipping load.');
      return;
    }

    _loading = true;
    notifyListeners();

    try {
      final doc = await _db.collection('users').doc(uid).get();

      if (!doc.exists) {
        debugPrint(
          '❓ loadFromFirestore: Document does not exist for UID: $uid',
        );
        _loading = false;
        notifyListeners();
        return;
      }

      final data = doc.data() ?? {};
      debugPrint('✅ loadFromFirestore: Data fetched: $data');

      _coins = data['Coin'] as int? ?? 0;
      _xp = data['XP'] as int? ?? 0;
      _stars = data['Stars'] as int? ?? 0;
      _username = data['username'] as String? ?? '';
      _bio = data['bio'] as String? ?? '';
      _completedSections = data['CompletedSections'] as int? ?? 0;
      _quizLevelsInSection = data['QuizLevelsInSection'] as int? ?? 0;

      // Load unlocked categories
      final unlocked = data['unlockedCategories'] as List<dynamic>?;
      _unlockedCategories = unlocked?.map((e) => e.toString()).toList() ?? [];

      _completedSections = _completedSections.clamp(0, totalSections);
      _quizLevelsInSection = _quizLevelsInSection.clamp(
        0,
        quizLevelsPerSection,
      );

      debugPrint(
        '✨ loadFromFirestore DONE → username:$_username | coins:$_coins | stars:$_stars | level:$level',
      );
    } catch (e) {
      debugPrint('❌ loadFromFirestore error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Category Unlocking ──────────────────────────────────────────────────────
  bool isCategoryUnlocked(
    String categoryId,
    bool requiresCoins,
    int unlockValue,
  ) {
    if (requiresCoins) {
      return _unlockedCategories.contains(categoryId);
    } else {
      return _stars >= unlockValue;
    }
  }

  bool _purchasing = false;

  Future<bool> unlockWithCoins(String categoryId, int cost) async {
    if (_purchasing) return false;
    if (_coins < cost) return false;

    _purchasing = true;

    _coins -= cost;
    if (!_unlockedCategories.contains(categoryId)) {
      _unlockedCategories.add(categoryId);
    }

    notifyListeners();
    await _sync();

    _purchasing = false;
    return true;
  }

  // ── Init Streak ─────────────────────────────────────────────────────────────
  Future<void> initStreak({bool isLogin = false}) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // ✅ INSTANT: Only for users who aren't signed in at all
      _streak = const StreakModel(
        title: StreakController.streakTitle,
        currentDay: 0,
        totalDays: StreakController.totalDaysPerCycle,
      );
      notifyListeners();
      return;
    }

    try {
      if (isLogin) {
        _streak = await StreakController.onLogin();
      } else {
        _streak = await StreakController.load();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('❌ initStreak error: $e');
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
    _completedSections = 0;
    _quizLevelsInSection = 0;
    _unlockedCategories = [];
    _loading = false;
    _streak = null;
    notifyListeners();
    debugPrint('🧹 clearData → all user state wiped');
  }

  // ── ✅ ADDED: Wipe then reload (use in HomeScreen.initState) ───────────────
  // Guarantees the screen always shows the currently logged-in user's data.
  Future<void> clearAndReload() async {
    debugPrint('🔄 clearAndReload triggered...');
    clearData();
    await loadFromFirestore();
    await initStreak(isLogin: true);
    debugPrint('✅ clearAndReload complete.');
  }

  // ── Update profile ──────────────────────────────────────────────────────────
  Future<bool> updateProfile({required String username, String? bio}) async {
    final uid = _uid;
    if (uid == null) return false;

    final newUsername = username.trim();
    final cleanNewUsername = newUsername.toLowerCase();
    final oldUsername = _username.trim().toLowerCase();

    if (newUsername.isEmpty) return false;

    try {
      // 1. If username changed, check availability
      if (cleanNewUsername != oldUsername) {
        final usernameDoc = await _db
            .collection('usernames')
            .doc(cleanNewUsername)
            .get();
        if (usernameDoc.exists) {
          debugPrint(
            '❌ updateProfile: Username "$cleanNewUsername" is already taken.',
          );
          return false;
        }

        // 2. Reserve new username
        await _db.collection('usernames').doc(cleanNewUsername).set({
          'uid': uid,
        });

        // 3. Delete old username reservation (if it wasn't the default 'Guest' or empty)
        if (oldUsername.isNotEmpty && oldUsername != 'guest') {
          await _db.collection('usernames').doc(oldUsername).delete();
        }
      }

      // 4. Update the user document
      _username = newUsername;
      if (bio != null) _bio = bio.trim();

      await _db.collection('users').doc(uid).set({
        'username': _username,
        if (bio != null) 'bio': _bio,
      }, SetOptions(merge: true));

      notifyListeners();
      debugPrint('✅ updateProfile success → username:$_username | bio:$_bio');
      return true;
    } catch (e) {
      debugPrint('❌ updateProfile error: $e');
      return false;
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

    // Only increment level-up progress if this is a NEW level completion
    if (earnedStars > 0) {
      _quizLevelsInSection++;
    }

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

    // Reset streak state for the next cycle
    // Keep streak at 7/7 in memory so it doesn't show "-/7" immediately
    if (_streak != null) {
      _streak = _streak!.copyWith(
        currentDay: _streak!.totalDays,
        rewardClaimed: true,
        justCompleted: false,
      );
    }

    notifyListeners();
    await _sync();

    // Also reset the streak document in its own collection
    await StreakController.resetAfterCompletion();
    debugPrint('🔥 Streak reset after completion');
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
      debugPrint('☁️ Syncing progress to Firestore for UID: $uid');
      await _db.collection('users').doc(uid).set({
        'Coin': _coins,
        'XP': _xp,
        'Stars': _stars,
        'CompletedSections': _completedSections,
        'QuizLevelsInSection': _quizLevelsInSection,
        'unlockedCategories': _unlockedCategories,
      }, SetOptions(merge: true));
      debugPrint('✅ Firestore Sync Complete.');
    } catch (e) {
      debugPrint('❌ _sync error: $e');
    }
  }

  // ── Data Migration ──────────────────────────────────────────────────────────
  /// Checks if a user already has data in Firestore
  Future<bool> hasExistingData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists;
  }

  /// Migrates data from guest UID to new UID
  Future<void> migrateGuestData(String guestUid, String newUid) async {
    try {
      // 1. Copy user document
      final guestDoc = await _db.collection('users').doc(guestUid).get();
      if (guestDoc.exists) {
        await _db
            .collection('users')
            .doc(newUid)
            .set(guestDoc.data()!, SetOptions(merge: true));
      }

      // 2. Copy category progress
      final categoriesSnap = await _db
          .collection('user_progress')
          .doc(guestUid)
          .collection('categories')
          .get();

      for (var catDoc in categoriesSnap.docs) {
        final levelsSnap = await catDoc.reference.collection('levels').get();
        for (var lvlDoc in levelsSnap.docs) {
          await _db
              .collection('user_progress')
              .doc(newUid)
              .collection('categories')
              .doc(catDoc.id)
              .collection('levels')
              .doc(lvlDoc.id)
              .set(lvlDoc.data());
        }
      }

      // 3. Delete guest data
      await _db.collection('users').doc(guestUid).delete();
      // Note: Deleting subcollections is complex in client SDK,
      // usually handled by Cloud Functions or just left orphaned.

      debugPrint('🚀 Guest data migrated from $guestUid to $newUid');
    } catch (e) {
      debugPrint('❌ Migration error: $e');
    }
  }
}
