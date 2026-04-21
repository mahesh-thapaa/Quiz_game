import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/jersey/jersey_level_tile.dart';
import 'package:quiz_game/models/level_overview_model.dart';
import 'package:quiz_game/models/level_result_models.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/services/level_progess_services.dart';
import 'widgets/level_tile.dart';
import 'widgets/level_overview_sheet.dart';
import 'package:quiz_game/screens/jersery_quiz/jursey_quiz_gameplay/jursey_quiz_gameplay_screen.dart';

class JerseyQuizScreen extends StatefulWidget {
  const JerseyQuizScreen({super.key});

  @override
  State<JerseyQuizScreen> createState() => _JerseyQuizScreenState();
}

class _JerseyQuizScreenState extends State<JerseyQuizScreen> {
  late List<JerseyLevelTile> block1Items;
  late List<JerseyLevelTile> block2Items;

  final Map<String, List<QuizQuestion>> _questionsByLevel = {};
  final Map<int, String> _levelDocIds = {};
  final Map<int, String> _bonusSlotToDocId = {};
  final Map<String, String> _levelTitles = {};

  bool _loadingQuestions = true;

  @override
  void initState() {
    super.initState();
    // Grid Positions 1-24 and 25-48
    block1Items = _generateLevelBlock(startPos: 1);
    block2Items = _generateLevelBlock(startPos: 25);
    _fetchAllLevelsAndQuestions();
  }

  List<JerseyLevelTile> _generateLevelBlock({required int startPos}) {
    final List<JerseyLevelTile> items = [];
    for (int i = 0; i < 24; i++) {
      int gridPos = startPos + i;
      // Bonus positions: 6, 12, 18, 24, 30, 36...
      if (gridPos % 6 == 0) {
        items.add(
          JerseyLevelTile(hasStar: true, number: gridPos, starsEarned: 0),
        );
      } else {
        items.add(
          JerseyLevelTile(
            number: gridPos,
            isCurrent: false,
            isUnlocked: gridPos == 1,
            starsEarned: 0,
          ),
        );
      }
    }
    return items;
  }

  Future<void> _fetchAllLevelsAndQuestions() async {
    try {
      setState(() => _loadingQuestions = true);
      final savedProgress = await LevelProgressService.loadAllLevelStars(
        category: 'jersey_quiz',
      );

      // Fetch Jersey Quiz using dynamic category query
      final quizSnap = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('category', isEqualTo: 'Jursey Quiz')
          .limit(1)
          .get();

      if (quizSnap.docs.isEmpty) {
        debugPrint('Jersey Quiz not found in Firestore');
        setState(() => _loadingQuestions = false);
        return;
      }

      String jerseyQuizDocId = quizSnap.docs.first.id;
      final levelsSnap = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(jerseyQuizDocId)
          .collection('levels')
          .orderBy('order')
          .get();

      int bonusCounter = 0;
      for (final levelDoc in levelsSnap.docs) {
        final docId = levelDoc.id;
        final data = levelDoc.data();
        final int levelNumber = (data['levelNumber'] ?? 0) as int;
        final bool isBonus = (data['isBonus'] ?? false) as bool;

        if (data['title'] != null)
          _levelTitles[docId] = data['title'].toString();

        if (isBonus) {
          _bonusSlotToDocId[bonusCounter] = docId;
          bonusCounter++;
        } else {
          _levelDocIds[levelNumber] = docId;
        }

        final qSnap = await levelDoc.reference
            .collection('questions')
            .orderBy('order')
            .get();
        _questionsByLevel[docId] = qSnap.docs
            .map((q) => QuizQuestion.fromMap(q.data()))
            .toList();
      }

      _applyLevelProgress(savedProgress);
      _recalculateCurrentTile();
      setState(() => _loadingQuestions = false);
    } catch (e) {
      debugPrint('❌ Initialization Error: $e');
      setState(() => _loadingQuestions = false);
    }
  }

  void _applyLevelProgress(Map<int, int> savedStars) {
    if (savedStars.isEmpty) return;
    for (final tile in [...block1Items, ...block2Items]) {
      if (tile.number != null && savedStars.containsKey(tile.number)) {
        tile.starsEarned = savedStars[tile.number] ?? 0;
        if (tile.starsEarned > 0) {
          tile.isUnlocked = true;
          _unlockNextTile(tile);
        }
      }
    }
  }

  void _recalculateCurrentTile() {
    final all = [...block1Items, ...block2Items];
    for (final tile in all) tile.isCurrent = false;
    for (final tile in all) {
      if (!tile.hasStar && tile.isUnlocked && tile.starsEarned == 0) {
        tile.isCurrent = true;
        break;
      }
    }
  }

  Future<void> _onLevelComplete(LevelResultModels result, int gridPos) async {
    // Find current stars earned on this level before update
    int currentStars = 0;
    for (final tile in [...block1Items, ...block2Items]) {
      if (tile.number == gridPos) {
        currentStars = tile.starsEarned;
        break;
      }
    }

    // Calculate the delta (increase in stars)
    final int starsDelta = result.starsEarned > currentStars
        ? result.starsEarned - currentStars
        : 0;

    // Update UI with the best performance (max of current and new)
    setState(() {
      for (final tile in [...block1Items, ...block2Items]) {
        if (tile.number == gridPos) {
          // Keep the maximum stars achieved (never decrease)
          tile.starsEarned = currentStars > result.starsEarned
              ? currentStars
              : result.starsEarned;
          if (tile.starsEarned > 0) _unlockNextTile(tile);
          break;
        }
      }
      _recalculateCurrentTile();
    });

    // Save only the delta (increase) to database
    if (starsDelta > 0) {
      await LevelProgressService.saveLevelStars(
        category: 'jersey_quiz',
        levelNumber: gridPos,
        starsEarned: result.starsEarned, // Save absolute stars (not delta)
      );

      await context.read<UserProgressProvider>().onQuizLevelCompleted(
        customCoins: result.coinsEarned,
        customXP: result.xpEarned,
        earnedStars: starsDelta, // Add only the delta to total progress
      );
    }
  }

  void _unlockNextTile(JerseyLevelTile current) {
    final all = [...block1Items, ...block2Items];
    final idx = all.indexWhere((t) => t.number == current.number);
    if (idx != -1 && idx < all.length - 1) all[idx + 1].isUnlocked = true;
  }

  List<QuizQuestion> _getQuestionsForLevel(int gridPos) {
    String? docId;
    if (gridPos % 6 == 0) {
      // Bonus: Pos 6 -> Slot 0, Pos 12 -> Slot 1...
      int slot = (gridPos ~/ 6) - 1;
      docId = _bonusSlotToDocId[slot];
    } else {
      // Normal: Pos 1-5 -> Lvl 1-5, Pos 7-11 -> Lvl 6-10...
      int actualLvlNum = gridPos - (gridPos ~/ 6);
      docId = _levelDocIds[actualLvlNum];
    }
    return docId != null ? (_questionsByLevel[docId] ?? []) : [];
  }

  /// TITLE LOGIC: Dynamically formats title for Gameplay Screen
  String _getGameplayTitle(int gridPos) {
    if (gridPos % 6 == 0) {
      return "BONUS LEVEL ${gridPos ~/ 6}";
    } else {
      int visualDisplayNum = gridPos - (gridPos ~/ 6);
      return "LEVEL $visualDisplayNum";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _loadingQuestions
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.doller),
              )
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
                  SliverToBoxAdapter(child: _buildSeparator()),
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

  Widget _buildGridSection(List<JerseyLevelTile> items) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = items[index];
        final int gridPos = item.number!;

        if (item.hasStar) {
          return LevelTile(
            key: ValueKey('bonus_$gridPos'),
            level: item,
            onTap: () {
              if (!item.isUnlocked) return;
              final questions = _getQuestionsForLevel(gridPos);
              if (questions.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No questions found for this bonus level'),
                  ),
                );
                return;
              }
              showBonusLevelSheet(
                context: context,
                isUnlocked: item.isUnlocked,
                unlockAtLevel: gridPos - 1,
                onPlay: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JurseyQuizGameplayScreen(
                      questions: questions,
                      levelNumber: gridPos,
                      levelTitle: _getGameplayTitle(
                        gridPos,
                      ), // Shows "BONUS LEVEL 1"
                      isBonus: true,
                      onLevelComplete: _onLevelComplete,
                      getQuestionsForLevel: _getQuestionsForLevel,
                      getGameplayTitle: _getGameplayTitle,
                      isBonusLevel: (pos) => pos % 6 == 0,
                    ),
                  ),
                ),
              );
            },
          );
        }

        int visualDisplayNum = gridPos - (gridPos ~/ 6);

        return LevelTile(
          key: ValueKey('lvl_$gridPos'),
          level: item,
          onTap: () {
            if (!item.isUnlocked) return;
            final questions = _getQuestionsForLevel(gridPos);
            if (questions.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No question available in this level'),
                ),
              );
              return;
            }
            showLevelOverview(
              context: context,
              model: LevelOverviewModel(
                levelNumber: visualDisplayNum,
                starsEarned: item.starsEarned,
                levelName: 'JERSEY CHALLENGE',
                description: 'Can you identify the jersey correctly?',
              ),
              onPlay: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JurseyQuizGameplayScreen(
                    questions: questions,
                    levelNumber: gridPos,
                    levelTitle: _getGameplayTitle(
                      gridPos,
                    ), // Shows "LEVEL 5", "LEVEL 6", etc.
                    onLevelComplete: _onLevelComplete,
                    getQuestionsForLevel: _getQuestionsForLevel,
                    getGameplayTitle: _getGameplayTitle,
                    isBonusLevel: (pos) => pos % 6 == 0,
                  ),
                ),
              ),
            );
          },
        );
      }, childCount: items.length),
    );
  }

  // --- UI Helpers ---
  Widget _buildHeader() {
    final p = context.watch<UserProgressProvider>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOALIQ',
                style: TextStyle(fontSize: 10, color: AppColors.stext),
              ),
              Text(
                'JERSEY QUIZ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildChip(Icons.star, '${p.stars}'),
          const SizedBox(width: 8),
          _buildChip(Icons.monetization_on, '${p.coins}'),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String txt) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.doller, size: 16),
        const SizedBox(width: 4),
        Text(txt, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );

  Widget _buildSeparator() => Container(
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
    child: const Column(
      children: [
        Text(
          'Earn at least 1 star in previous level to unlock',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.stext, height: 1.5),
        ),
        SizedBox(height: 24),
        Divider(color: AppColors.divider, height: 1),
        SizedBox(height: 24),
      ],
    ),
  );
}
