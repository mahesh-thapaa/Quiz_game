import 'package:flutter/material.dart';
import 'package:quiz_game/models/club/club_question_model.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/jersey_quiz/jursey_quiz_gameplay/jursey_answer_options.dart';
import 'package:quiz_game/screens/jersey_quiz/jursey_quiz_gameplay/jursey_level_completed_screen.dart';
import 'package:quiz_game/screens/jersey_quiz/jursey_quiz_gameplay/jursey_quiz_top_bar.dart';
import 'package:quiz_game/screens/jersey_quiz/jursey_quiz_gameplay/jursey_image_card.dart';
import 'package:quiz_game/models/level_result_models.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';
import 'package:quiz_game/services/star_calculation_service.dart';

class JurseyQuizGameplayScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final int levelNumber;
  final String? levelTitle;
  final bool isBonus;
  final int? nextLevelNumber;
  final Future<void> Function(LevelResultModels, int) onLevelComplete;
  final List<QuizQuestion> Function(int) getQuestionsForLevel;
  final String Function(int)? getGameplayTitle;
  final bool Function(int)? isBonusLevel;

  const JurseyQuizGameplayScreen({
    super.key,
    required this.questions,
    required this.levelNumber,
    this.levelTitle,
    this.isBonus = false,
    this.nextLevelNumber,
    required this.onLevelComplete,
    required this.getQuestionsForLevel,
    this.getGameplayTitle,
    this.isBonusLevel,
  });

  @override
  State<JurseyQuizGameplayScreen> createState() =>
      _JurseyQuizGameplayScreenState();
}

class _JurseyQuizGameplayScreenState extends State<JurseyQuizGameplayScreen>
    with TickerProviderStateMixin {
  late List<ClubQuestionModel> _questions;
  late int _currentLevelNumber;
  late String? _currentLevelTitle;
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _score = 0;

  bool _showResult = false;
  LevelResultModels? _result;
  bool _hasPopped = false;

  bool _isFirstPlay = true;
  int _bestStarsThisLevel = 0;

  late AnimationController _progressCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  static const _labels = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _currentLevelNumber = widget.levelNumber;
    _currentLevelTitle = widget.levelTitle;
    _initQuestions(widget.questions);
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1,
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _updateProgress();
  }

  void _initQuestions(List<QuizQuestion> qs) {
    _questions = qs.asMap().entries.map((entry) {
      final index = entry.key;
      final q = entry.value;
      return ClubQuestionModel(
        questionNumber: index + 1,
        totalQuestions: qs.length,
        questionText: q.title,
        options: q.options,
        correctIndex: q.correctAnswerIndex,
        imagePath: q.imagePath,
      );
    }).toList();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _updateProgress() {
    if (_questions.isEmpty) return;
    _progressCtrl.animateTo((_currentIndex + 1) / _questions.length);
  }

  void _safePop([LevelResultModels? result]) {
    if (_hasPopped || !mounted) return;
    if (!Navigator.canPop(context)) return;
    _hasPopped = true;
    Future.delayed(Duration.zero, () {
      if (mounted) Navigator.pop(context, result);
    });
  }

  void _resetGame() {
    setState(() {
      _currentIndex = 0;
      _selectedIndex = null;
      _answered = false;
      _score = 0;
      _showResult = false;
      _result = null;
      _hasPopped = false;
    });
    _fadeCtrl.value = 1;
    _updateProgress();
  }

  void _goToNextLevel() async {
    // Sequential progression: 1→2→...→5→6(bonus)→7→...→12(bonus)→13...
    final int nextLevel = _currentLevelNumber + 1;

    final nextQuestions = widget.getQuestionsForLevel(nextLevel);

    if (nextQuestions.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No questions available for Level $nextLevel yet'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!mounted) return;

    // Calculate correct title for the next level
    String? nextTitle;

    if (widget.getGameplayTitle != null) {
      nextTitle = widget.getGameplayTitle!(nextLevel);
    }

    setState(() {
      _currentLevelNumber = nextLevel;
      _currentLevelTitle = nextTitle;
      _currentIndex = 0;
      _selectedIndex = null;
      _answered = false;
      _score = 0;
      _showResult = false;
      _result = null;
      _hasPopped = false;
      _isFirstPlay = true;
      _bestStarsThisLevel = 0;
    });

    _initQuestions(nextQuestions);
    _fadeCtrl.value = 1;
    _updateProgress();
  }

  void _onOptionTap(int index) {
    if (_answered || _showResult) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) _score++;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted || _showResult) return;
      _nextQuestion();
    });
  }

  Future<void> _nextQuestion() async {
    if (_currentIndex >= _questions.length - 1) {
      await _fadeCtrl.reverse();
      if (!mounted) return;
      _finish();
      return;
    }
    await _fadeCtrl.reverse();
    if (!mounted) return;
    setState(() {
      _currentIndex++;
      _selectedIndex = null;
      _answered = false;
    });
    _updateProgress();
    await _fadeCtrl.forward();
  }

  Future<void> _finish() async {
    if (!mounted || _showResult) return;

    final int total = _questions.length;
    final int starsThisAttempt = StarCalculationService.calculateStars(_score);
    final int coinsEarned = _isFirstPlay ? _score * 10 : 0;
    final int xpEarned = _isFirstPlay ? _score * 20 : 0;
    final int starDelta = starsThisAttempt > _bestStarsThisLevel
        ? starsThisAttempt - _bestStarsThisLevel
        : 0;

    final LevelResultModels uiResult = LevelResultModels(
      score: _score,
      totalQuestions: total,
      starsEarned: starsThisAttempt,
      xpEarned: xpEarned,
      coinsEarned: coinsEarned,
      accuracy: total > 0 ? ((_score / total) * 100).toInt() : 0,
    );

    setState(() {
      _result = uiResult;
      _showResult = true;
    });

    final bool shouldSave = _isFirstPlay || starDelta > 0;

    if (starsThisAttempt > _bestStarsThisLevel) {
      _bestStarsThisLevel = starsThisAttempt;
    }
    _isFirstPlay = false;

    if (shouldSave) {
      // Only save if it's improvement
      await widget.onLevelComplete(
        LevelResultModels(
          score: _score,
          totalQuestions: total,
          starsEarned:
              starsThisAttempt, // Pass actual stars earned for proper UI update
          xpEarned: xpEarned,
          coinsEarned: coinsEarned,
          accuracy: uiResult.accuracy,
        ),
        _currentLevelNumber,
      );
    }
  }

  JurseyAnswerOption _getState(int index) {
    if (!_answered) {
      return _selectedIndex == index
          ? JurseyAnswerOption.selected
          : JurseyAnswerOption.idle;
    }
    if (index == _questions[_currentIndex].correctIndex) {
      return JurseyAnswerOption.correct;
    }
    if (index == _selectedIndex) return JurseyAnswerOption.wrong;
    return JurseyAnswerOption.idle;
  }

  String get _displayTitle {
    if (_currentLevelTitle != null && _currentLevelTitle!.isNotEmpty) {
      return _currentLevelTitle!.toUpperCase();
    }
    return 'LEVEL $_currentLevelNumber';
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                JurseyQuizTopBar(onBack: () => _safePop(null)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        '$_displayTitle  •  QUESTION ${q.questionNumber} OF ${q.totalQuestions}',
                        style: const TextStyle(color: AppColors.stext),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (_currentIndex + 1) / _questions.length,
                        backgroundColor: AppColors.divider,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            q.questionText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.hText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (q.imagePath != null && q.imagePath!.isNotEmpty)
                            JurseyImageCard(imagePath: q.imagePath!),
                          if (q.imagePath != null && q.imagePath!.isNotEmpty)
                            const SizedBox(height: 20),
                          ...List.generate(q.options.length, (i) {
                            return JurseyAnswerOptionWidget(
                              label: _labels[i],
                              text: q.options[i],
                              state: _getState(i),
                              onTap: () => _onOptionTap(i),
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Result overlay ──
          if (_showResult && _result != null)
            JurseyLevelCompleteScreen(
              result: _result!,
              levelNumber: _currentLevelNumber,
              onNextLevel: _goToNextLevel,
              onReplayLevel: _resetGame,
            ),
        ],
      ),
    );
  }
}
