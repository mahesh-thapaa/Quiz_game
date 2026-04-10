import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/jersey/jersey_level_tile.dart';
import 'package:quiz_game/models/level_overview_model.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'widgets/level_tile.dart';
import 'package:quiz_game/screens/jersery_quiz/jursey_quiz_gameplay/jursey_quiz_gameplay_screen.dart';
import 'widgets/level_overview_sheet.dart';

class JerseyQuizScreen extends StatefulWidget {
  const JerseyQuizScreen({super.key});

  @override
  State<JerseyQuizScreen> createState() => _JerseyQuizScreenState();
}

class _JerseyQuizScreenState extends State<JerseyQuizScreen> {
  late List<ProfileLevel> block1Items;
  late List<ProfileLevel> block2Items;

  List<QuizQuestion> _questions = [];
  bool _loadingQuestions = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    block1Items = _generateLevelBlock(startLevel: 1);
    block2Items = _generateLevelBlock(startLevel: 21);
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      setState(() {
        _loadingQuestions = true;
        _errorMessage = '';
      });
      final List<QuizQuestion> allQuestions = [];
      const String jerseyQuizDocId = 'r9iKNbMwuzoNP5yw8ibP';

      final levelsSnap = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(jerseyQuizDocId)
          .collection('levels')
          .get();

      debugPrint('📂 Found ${levelsSnap.docs.length} levels for Jersey Quiz');

      for (final levelDoc in levelsSnap.docs) {
        final questionsSnap = await levelDoc.reference
            .collection('questions')
            .orderBy('order')
            .get();
        debugPrint(
          '   📄 Level ${levelDoc['levelNumber']} has ${questionsSnap.docs.length} questions',
        );
        for (final qDoc in questionsSnap.docs) {
          allQuestions.add(QuizQuestion.fromMap(qDoc.data()));
        }
      }

      setState(() {
        _questions = allQuestions;
        _loadingQuestions = false;
      });
    } catch (e) {
      debugPrint('Error fetching questions: $e');
      setState(() {
        _errorMessage = 'Failed to load questions. Please try again.';
        _loadingQuestions = false;
      });
    }
  }

  List<ProfileLevel> _generateLevelBlock({required int startLevel}) {
    List<ProfileLevel> items = [];
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

  int _calculateStars(int score) {
    if (score >= 10) return 3;
    if (score >= 5) return 2;
    return 1;
  }

  bool get _isLevel5Completed {
    for (final level in block1Items) {
      if (level.number == 5 && level.starsEarned > 0) return true;
    }
    return false;
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
    if (_loadingQuestions) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _loadingQuestions = true;
                    _errorMessage = '';
                  });
                  _fetchQuestions();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: _buildGridSection(block1Items),
            ),
            SliverToBoxAdapter(child: _buildMilestoneSeparator()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              sliver: _buildGridSection(block2Items),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final p = context.watch<UserProgressProvider>(); // ✅ live data

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                'JERSEY QUIZ',
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
            'Earn at least 1 star in previous level to\nunlock',
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
            if (item.isUnlocked && !item.hasStar) {
              showLevelOverview(
                context: context,
                model: LevelOverviewModel(
                  levelNumber: item.number ?? 1,
                  levelName: 'ROOKIE CHALLENGE',
                  starsEarned: item.starsEarned,
                  description:
                      'Test your knowledge on football jerseys.\nTry to earn 3 stars',
                ),
                onPlay: () async {
                  final result = await Navigator.push<int>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JurseyQuizGameplayScreen(questions: _questions),
                    ),
                  );
                  if (result != null) {
                    _updateLevelStars(
                      item.number ?? 1,
                      _calculateStars(result),
                    );
                  }
                },
              );
            } else if (item.hasStar) {
              showBonusLevelSheet(
                context: context,
                isUnlocked: _isLevel5Completed,
                onPlay: () async {
                  await Navigator.push<int>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JurseyQuizGameplayScreen(questions: _questions),
                    ),
                  );
                },
              );
            }
          },
        );
      }, childCount: items.length),
    );
  }
}
