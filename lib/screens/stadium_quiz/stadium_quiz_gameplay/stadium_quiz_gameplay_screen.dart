import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/stadium_question_model.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/stadium_quiz/stadium_quiz_gameplay/stadium_quiz_top_bar.dart';
import 'package:quiz_game/screens/stadium_quiz/stadium_quiz_gameplay/stadium_imager_card.dart';
import 'package:quiz_game/screens/stadium_quiz/stadium_quiz_gameplay/stadium_answer_option.dart';
import 'package:quiz_game/screens/stadium_quiz/stadium_quiz_gameplay/stadium_level_completed_card.dart';
import 'package:quiz_game/models/level_result_models.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';

class StadiumQuizGameplayScreen extends StatefulWidget {
  final List<QuizQuestion> questions;

  const StadiumQuizGameplayScreen({super.key, required this.questions});

  @override
  State<StadiumQuizGameplayScreen> createState() =>
      _StadiumQuizGameplayScreenState();
}

class _StadiumQuizGameplayScreenState extends State<StadiumQuizGameplayScreen>
    with TickerProviderStateMixin {
  late List<StadiumQuestionModel> _questions;
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _score = 0;

  late AnimationController _progressCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  static const _labels = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();

    _questions = widget.questions.asMap().entries.map((entry) {
      final index = entry.key;
      final q = entry.value;
      return StadiumQuestionModel(
        questionNumber: index + 1,
        totalQuestions: widget.questions.length,
        questionText: q.title,
        options: q.options,
        correctIndex: q.correctAnswerIndex,
        imagePath: q.imagePath ?? '',
      );
    }).toList();

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

  @override
  void dispose() {
    _progressCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _updateProgress() {
    _progressCtrl.animateTo((_currentIndex + 1) / _questions.length);
  }

  void _resetGame() {
    setState(() {
      _currentIndex = 0;
      _selectedIndex = null;
      _answered = false;
      _score = 0;
    });
    _fadeCtrl.value = 1;
    _updateProgress();
  }

  void _onOptionTap(int index) {
    if (_answered) return;

    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _score++;
        // Award XP/coins for each correct answer in real time
        context.read<UserProgressProvider>().onCorrectAnswer();
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  Future<void> _nextQuestion() async {
    if (_currentIndex >= _questions.length - 1) {
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
    final total = _questions.length;
    final starsEarned = _score >= 10
        ? 3
        : _score >= 5
        ? 2
        : 1;

    // Award completion bonus (stars already counted per-answer above,
    // so pass earnedStars=0 here to avoid double-counting stars).
    await context.read<UserProgressProvider>().onQuizCompleted(
      earnedStars: starsEarned,
    );

    if (!mounted) return;

    final result = LevelResultModels(
      score: _score,
      totalQuestions: total,
      starsEarned: starsEarned,
      xpEarned: _score * 20,
      coinsEarned: _score * 10,
      accuracy: total > 0 ? ((_score / total) * 100).round() : 0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StadiumLevelCompletedCard(
          result: result,
          onNextLevel: () {
            Navigator.pop(context, _score);
          },
          onReplayLevel: () {
            Navigator.pop(context);
            _resetGame();
          },
        ),
      ),
    );
  }

  StadiumAnswerOption _getState(int index) {
    if (!_answered) {
      return _selectedIndex == index
          ? StadiumAnswerOption.selected
          : StadiumAnswerOption.idle;
    }
    if (index == _questions[_currentIndex].correctIndex) {
      return StadiumAnswerOption.correct;
    }
    if (index == _selectedIndex) {
      return StadiumAnswerOption.wrong;
    }
    return StadiumAnswerOption.idle;
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    // Watch provider so top bar rebuilds whenever coins/stars change
    final progress = context.watch<UserProgressProvider>();
    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Top bar now receives live values from the provider
            StadiumQuizTopBar(
              stars: progress.stars,
              coins: progress.coins,
              onBack: () => Navigator.pop(context),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'QUESTION ${q.questionNumber} OF ${q.totalQuestions}',
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
                      StadiumImagerCard(imagePath: q.imagePath),
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

                      ...List.generate(q.options.length, (i) {
                        return StadiumAnswerOptionWidget(
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
    );
  }
}
