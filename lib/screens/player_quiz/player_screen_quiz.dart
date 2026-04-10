import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/player_quiz/player_level_tile.dart';
import 'package:quiz_game/models/level_overview_model.dart';
import 'package:quiz_game/models/level_result_models.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';
import 'widgets/level_tile.dart';
import 'widgets/level_overview_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_game/screens/player_quiz/player_quiz_gameplay/player_quiz_gameplay_screen.dart';

class PlayerScreenQuiz extends StatefulWidget {
  const PlayerScreenQuiz({super.key});

  @override
  State<PlayerScreenQuiz> createState() => _PlayerScreenQuizState();
}

class _PlayerScreenQuizState extends State<PlayerScreenQuiz> {
  late List<ProfileLevel> block1Items;
  late List<ProfileLevel> block2Items;

  final Map<String, List<QuizQuestion>> _questionsByLevel = {};

  String? _quizDocId;

  bool _loadingQuestions = true;

  @override
  void initState() {
    super.initState();
    block1Items = _generateLevelBlock(startLevel: 1);
    block2Items = _generateLevelBlock(startLevel: 21);
    _fetchAllLevelsAndQuestions();
  }

  List<ProfileLevel> _generateLevelBlock({required int startLevel}) {
    final List<ProfileLevel> items = [];
    int currentLevel = startLevel;
    for (int i = 0; i < 24; i++) {
      if (i == 5 || i == 11 || i == 17 || i == 23) {
        items.add(ProfileLevel(hasStar: true));
      } else {
        items.add(
          ProfileLevel(
            number: currentLevel,
            isCurrent: currentLevel == 1,
            isUnlocked: currentLevel <= 3,
            starsEarned: 0,
          ),
        );
        currentLevel++;
      }
    }
    return items;
  }

  Future<void> _fetchAllLevelsAndQuestions() async {
    try {
      setState(() => _loadingQuestions = true);

      final quizSnap = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('category', isEqualTo: 'Player Quiz')
          .limit(1)
          .get();

      if (quizSnap.docs.isEmpty) {
        debugPrint('❌ Player Quiz not found in Firestore');
        setState(() => _loadingQuestions = false);
        return;
      }

      _quizDocId = quizSnap.docs.first.id;
      debugPrint('✅ Found Player Quiz: $_quizDocId');

      final levelsSnap = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(_quizDocId)
          .collection('levels')
          .orderBy('order')
          .get();

      debugPrint('📂 Found ${levelsSnap.docs.length} levels');

      for (final levelDoc in levelsSnap.docs) {
        final levelId = levelDoc.id;

        final questionsSnap = await levelDoc.reference
            .collection('questions')
            .orderBy('order')
            .get();

        final questions = questionsSnap.docs
            .map((qDoc) => QuizQuestion.fromMap(qDoc.data()))
            .toList();

        _questionsByLevel[levelId] = questions;

        debugPrint('❓ $levelId → ${questions.length} questions fetched');
      }

      debugPrint(
        '✅ Total levels fetched: ${_questionsByLevel.length} | '
        'Total questions: ${_questionsByLevel.values.fold(0, (sum, q) => sum + q.length)}',
      );

      setState(() => _loadingQuestions = false);
    } catch (e) {
      debugPrint('❌ Error fetching questions: $e');
      setState(() => _loadingQuestions = false);
    }
  }

  List<QuizQuestion> _getQuestionsForLevel(int levelNumber) {
    final levelId = 'level$levelNumber';
    return _questionsByLevel[levelId] ?? [];
  }

  int _calcStars(int score, int total) {
    if (total == 0) return 0;
    final pct = score / total;
    if (pct >= 0.9) return 3;
    if (pct >= 0.5) return 2;
    return 1;
  }

  Future<void> _handleQuizResult(
    LevelResultModels result,
    int levelNumber,
  ) async {
    debugPrint(
      '🏆 Level $levelNumber | '
      'score: ${result.score}/${result.totalQuestions} | '
      'stars: ${result.starsEarned} | '
      'coins: ${result.coinsEarned}',
    );

    final allTiles = [...block1Items, ...block2Items];
    final tile = allTiles.firstWhere(
      (t) => t.number == levelNumber,
      orElse: () => ProfileLevel(number: levelNumber),
    );
    final previousStars = tile.starsEarned;
    final newStars = result.starsEarned;

    final starDiff = (newStars > previousStars) ? newStars - previousStars : 0;

    debugPrint(
      '⭐ prev: $previousStars | new: $newStars | diff added: $starDiff',
    );

    await context.read<UserProgressProvider>().onQuizCompleted(
      customCoins: result.coinsEarned,
      customXP: result.xpEarned,
      earnedStars: starDiff,
    );

    _updateLevelStars(levelNumber, newStars);
  }

  void _updateLevelStars(int levelNumber, int newStars) {
    setState(() {
      for (final level in [...block1Items, ...block2Items]) {
        if (level.number == levelNumber) {
          if (newStars > level.starsEarned) level.starsEarned = newStars;
          return;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasAnyQuestions = _questionsByLevel.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _loadingQuestions
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.doller),
              )
            : !hasAnyQuestions
            ? _buildEmptyState()
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    sliver: _buildGridSection(block1Items),
                  ),
                  SliverToBoxAdapter(child: _buildMilestoneSeparator()),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: _buildGridSection(block2Items),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No questions found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchAllLevelsAndQuestions,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final p = context.watch<UserProgressProvider>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.iCOlor,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOALIQ',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.stext,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                'PLAYER QUIZ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.hText,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildStatChip(Icons.star_rounded, '${p.stars}', AppColors.doller),
          const SizedBox(width: 8),
          _buildStatChip(
            Icons.monetization_on_rounded,
            '${p.coins}',
            AppColors.doller,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.stext,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneSeparator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: const Column(
        children: [
          Text(
            'Earn at least 1 star in previous level to unlock',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.stext, height: 1.5),
          ),
          SizedBox(height: 36),
          Text(
            'Unlock Next Level with 50 ★ Stars',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.stext,
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildGridSection(List<ProfileLevel> items) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = items[index];
        return LevelTile(
          level: item,
          onTap: () {
            if (item.hasStar) {
              showBonusLevelSheet(
                context: context,
                isUnlocked: false,
                unlockAtLevel: 5,
              );
              return;
            }

            if (!item.isUnlocked) return;

            final questions = _getQuestionsForLevel(item.number ?? 1);

            showLevelOverview(
              context: context,
              model: LevelOverviewModel(
                levelNumber: item.number ?? 1,
                levelName: 'PLAYER CHALLENGE',
                starsEarned: item.starsEarned,
                description: questions.isEmpty
                    ? 'No questions available yet'
                    : 'Identify the player correctly!\nTry to earn 3 stars\n${questions.length} questions',
              ),
              onPlay: () async {
                if (questions.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No questions for this level yet'),
                    ),
                  );
                  return;
                }

                final result = await Navigator.push<LevelResultModels>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PlayerQuizGameplayScreen(questions: questions),
                  ),
                );

                debugPrint('📊 Level ${item.number} result: $result');

                if (result != null && mounted) {
                  await _handleQuizResult(result, item.number ?? 1);
                }
              },
            );
          },
        );
      }, childCount: items.length),
    );
  }
}
