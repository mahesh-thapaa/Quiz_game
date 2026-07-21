import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/controllers/level_progess_services.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/quiz_level_tile.dart';
import 'package:quiz_game/models/level_overview_model.dart';
import 'package:quiz_game/models/level_result_models.dart';
import 'package:quiz_game/models/quiz_models/quiz_level.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/controllers/quiz_controller.dart';
import 'package:quiz_game/controllers/level_grid_controller.dart';
import 'package:quiz_game/screens/common/widgets/quiz_sheets.dart';
import 'package:quiz_game/screens/common/widgets/level_tile.dart';
import 'package:quiz_game/screens/common/gameplay/quiz_gameplay_screen.dart';

class LevelGridScreen extends StatefulWidget {
  final String title;
  final String categoryId;
  final String firestoreName;

  const LevelGridScreen({
    super.key,
    required this.title,
    required this.categoryId,
    required this.firestoreName,
  });

  @override
  State<LevelGridScreen> createState() => _LevelGridScreenState();
}

class _LevelGridScreenState extends State<LevelGridScreen> {
  late LevelGridController _controller;

  Map<String, List<QuizQuestion>> _questionsByLevel = {};
  Map<int, String> _levelDocIds = {};
  Map<int, String> _bonusSlotToDocId = {};
  DocumentReference? _quizDocRef;

  bool _loading = true;
  bool _fetchingQuestions = false;

  @override
  void initState() {
    super.initState();
    _controller = LevelGridController.initial(categoryId: widget.categoryId);
    _initializeData();
  }

  Future<void> _initializeData() async {
    final Map<String, dynamic> data;
    if (widget.categoryId == 'quick_quiz') {
      final p = context.read<UserProgressProvider>();
      data = await QuizController.loadQuickQuizData(
        userLevel: p.level,
        userCoins: p.coins,
      );
    } else {
      data = await QuizController.loadQuizData(
        categoryId: widget.categoryId,
        firestoreName: widget.firestoreName,
        quizId: widget.categoryId, // Passing categoryId as quizId (document ID)
      );
    }

    if (mounted) {
      setState(() {
        if (widget.categoryId == 'quick_quiz') {
          _questionsByLevel = data['questionsByLevel'] ?? {};
        }
        _levelDocIds = data['levelDocIds'];
        _bonusSlotToDocId = data['bonusSlotToDocId'];
        _quizDocRef = data['quizDocReference'];
        _controller.applyProgress(data['progress']);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.of(context).background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverOpacity(
                        opacity: _loading ? 0.2 : 1.0,
                        sliver: _buildGrid(_controller.block1Items),
                      ),
                      SliverOpacity(
                        opacity: _loading ? 0.2 : 1.0,
                        sliver: SliverToBoxAdapter(
                          child: _buildSeparator(
                            'Earn at least 1 star in previous level to unlock',
                          ),
                        ),
                      ),
                      SliverOpacity(
                        opacity: _loading ? 0.2 : 1.0,
                        sliver: SliverToBoxAdapter(
                          child: _buildUnlockNextHeader(),
                        ),
                      ),
                      SliverOpacity(
                        opacity: _loading ? 0.2 : 1.0,
                        sliver: _buildGrid(_controller.block2Items),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 50)),
                    ],
                  ),
                  if (_loading || _fetchingQuestions)
                    IgnorePointer(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.1),
                        child: _buildLoading(
                          message: _fetchingQuestions
                              ? 'FETCHING QUESTIONS'
                              : 'LOADING LEVELS',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading({String message = 'LOADING LEVELS'}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeColors.of(context).cardBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              color: ThemeColors.of(context).hText.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Preparing your challenge...',
            style: TextStyle(
              color: ThemeColors.of(context).hText.withValues(alpha: 0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final p = context.watch<UserProgressProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ThemeColors.of(context).hText,
              size: 22,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GOALIQ',
                  style: TextStyle(
                    fontSize: 10,
                    color: ThemeColors.of(context).hText.withValues(alpha: 0.3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: ThemeColors.of(context).hText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildXPChip('${p.xp}'),
          const SizedBox(width: 8),
          _buildChip('★', '${p.stars}'),
          const SizedBox(width: 8),
          _buildCoinChip('${p.coins}', suffix: ' +'),
        ],
      ),
    );
  }

  Widget _buildXPChip(String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: ThemeColors.of(context).cardBg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'XP',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(
            color: ThemeColors.of(context).hText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _buildCoinChip(String value, {String? suffix}) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 350),
    transitionBuilder: (child, anim) =>
        ScaleTransition(scale: anim, child: child),
    child: Container(
      key: ValueKey(value),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ThemeColors.of(context).cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: AppColors.doller,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(color: ThemeColors.of(context).hText),
                ),
                if (suffix != null)
                  TextSpan(
                    text: suffix,
                    style: const TextStyle(color: Color(0xFFFFD700)),
                  ),
              ],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildChip(String icon, String value, {String? suffix}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: ThemeColors.of(context).cardBg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon == '★')
          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 18)
        else
          Text(
            icon,
            style: const TextStyle(color: Color(0xFFFFD700), fontSize: 16),
          ),
        const SizedBox(width: 5),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(color: ThemeColors.of(context).hText),
              ),
              if (suffix != null)
                TextSpan(
                  text: suffix,
                  style: const TextStyle(color: Color(0xFFFFD700)),
                ),
            ],
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );

  Widget _buildGrid(List<QuizLevelTile> items) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      delegate: SliverChildBuilderDelegate(
        (ctx, i) =>
            LevelTile(level: items[i], onTap: () => _handleLevelTap(items[i])),
        childCount: items.length,
      ),
    ),
  );

  Future<List<QuizQuestion>> _getOrFetchQuestions(int pos) async {
    List<QuizQuestion> qs = _controller.getQuestionsForPos(
      pos,
      _questionsByLevel,
      _levelDocIds,
      _bonusSlotToDocId,
      categoryId: widget.categoryId,
    );

    if (qs.isEmpty && _quizDocRef != null) {
      String? levelDocId =
          QuizController.isBonusLevel(pos, categoryId: widget.categoryId)
          ? _bonusSlotToDocId[(pos ~/ 6) - 1]
          : _levelDocIds[pos];

      if (levelDocId != null) {
        try {
          final fetched = await QuizController.fetchQuestionsForLevelId(
            quizDocRef: _quizDocRef!,
            levelDocId: levelDocId,
          );
          _questionsByLevel[levelDocId] = fetched;
          return fetched;
        } catch (e) {
          rethrow;
        }
      }
    }
    return qs;
  }

  void _handleLevelTap(QuizLevelTile item) async {
    if (!item.isUnlocked) return;

    setState(() => _fetchingQuestions = true);
    List<QuizQuestion> qs = [];

    try {
      qs = await _getOrFetchQuestions(item.number!);
      if (!mounted) return;

      // Pre-cache all images for this level in the background
      _precacheLevelImages(qs);

      setState(() => _fetchingQuestions = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _fetchingQuestions = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: const Text('Network error. Check your connection.'),
            action: SnackBarAction(
              label: 'RETRY',
              textColor: Colors.white,
              onPressed: () => _handleLevelTap(item),
            ),
          ),
        );
      }
      return;
    }

    if (qs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(milliseconds: 1500),
          content: const Text(
            'No questions available for this level yet!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
      );
      return;
    }

    if (item.hasStar) {
      QuizSheets.showBonusLevel(
        context: context,
        bonusNumber: item.number! ~/ 6,
        starsEarned: item.starsEarned,
        onPlay: () => _startQuiz(qs, item.number!, true),
      );
    } else {
      QuizSheets.showLevelOverview(
        context: context,
        model: LevelOverviewModel(
          levelNumber: item.number!,
          starsEarned: item.starsEarned,
          levelName: widget.title,
          description: 'Test your knowledge and earn 3 stars',
        ),
        onPlay: () => _startQuiz(qs, item.number!, false),
      );
    }
  }

  void _startQuiz(List<QuizQuestion> qs, int num, bool bonus) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizGameplayScreen(
          questions: qs,
          levelNumber: num,
          levelTitle: QuizController.getLevelTitle(
            num,
            categoryId: widget.categoryId,
          ),
          isBonus: bonus,
          quizTitle: widget.title,
          onLevelComplete: _onLevelComplete,
          getQuestionsForLevel: (pos) => _getOrFetchQuestions(pos),
          getGameplayTitle: (pos) =>
              QuizController.getLevelTitle(pos, categoryId: widget.categoryId),
          isBonusLevel: (pos) =>
              QuizController.isBonusLevel(pos, categoryId: widget.categoryId),
        ),
      ),
    );
  }

  void _precacheLevelImages(List<QuizQuestion> questions) {
    for (var q in questions) {
      if (q.imageUrl != null && q.imageUrl!.isNotEmpty) {
        if (q.imageUrl!.startsWith('http')) {
          precacheImage(NetworkImage(q.imageUrl!), context);
        } else {
          precacheImage(AssetImage(q.imageUrl!), context);
        }
      }
    }
  }

  Future<void> _onLevelComplete(LevelResultModels res, int gridPos) async {
    final all = [..._controller.block1Items, ..._controller.block2Items];
    int oldStars = 0;
    int oldBestScore = 0;

    for (var t in all) {
      if (t.number == gridPos) {
        oldStars = t.starsEarned;
        oldBestScore = t.bestScore;
      }
    }

    // STRICT RULE: If already achieved 3 stars, do nothing
    if (oldStars >= 3) return;

    int starDelta = res.starsEarned > oldStars ? res.starsEarned - oldStars : 0;
    int scoreDelta = res.score > oldBestScore ? res.score - oldBestScore : 0;

    // Calculate actual incremental rewards to prevent glitch
    int multiplier = (gridPos % 6 == 0) ? 2 : 1;
    int incrementalCoins = scoreDelta * 10 * multiplier;
    int incrementalXP = scoreDelta * 20 * multiplier;

    setState(() {
      for (var t in all) {
        if (t.number == gridPos) {
          t.starsEarned = res.starsEarned > oldStars
              ? res.starsEarned
              : oldStars;
          t.bestScore = res.score > oldBestScore ? res.score : oldBestScore;
          if (t.starsEarned > 0 || t.bestScore > 0) {
            _controller.unlockNext(gridPos);
          }
        }
      }
      _controller.updateCurrentTile();
    });

    if (starDelta > 0 || scoreDelta > 0) {
      // 1. Update persistent level progress (Stars and Best Score)
      await LevelProgressService.saveLevelProgress(
        category: widget.categoryId,
        levelNumber: gridPos,
        starsEarned: res.starsEarned > oldStars ? res.starsEarned : oldStars,
        bestScore: res.score > oldBestScore ? res.score : oldBestScore,
      );

      // 2. Add only the NEW rewards to user's total
      await context.read<UserProgressProvider>().onQuizLevelCompleted(
        customCoins: incrementalCoins,
        customXP: incrementalXP,
        earnedStars: starDelta,
      );
    }
  }

  Widget _buildSeparator(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: ThemeColors.of(context).hText.withValues(alpha: 0.2),
        fontSize: 13,
        height: 1.5,
      ),
    ),
  );
  Widget _buildUnlockNextHeader() => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Center(
      child: Text(
        'Unlock Next Level with 50 ★ Stars',
        style: TextStyle(
          color: ThemeColors.of(context).hText.withValues(alpha: 0.3),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
