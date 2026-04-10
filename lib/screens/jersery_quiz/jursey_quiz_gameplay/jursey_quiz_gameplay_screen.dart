import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/jursey_question_model.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/jersery_quiz/jursey_quiz_gameplay/jursey_image_card.dart';
import 'package:quiz_game/screens/jersery_quiz/jursey_quiz_gameplay/jursey_answer_option.dart';
import 'package:quiz_game/screens/jersery_quiz/jursey_quiz_gameplay/jursey_level_complete-screen.dart';
import 'package:quiz_game/screens/jersery_quiz/jursey_quiz_gameplay/jursey_quiz_top_bar.dart';
import 'package:quiz_game/models/level_result_models.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';

class JurseyQuizGameplayScreen extends StatefulWidget {
  final List<QuizQuestion> questions;

  const JurseyQuizGameplayScreen({super.key, required this.questions});

  @override
  State<JurseyQuizGameplayScreen> createState() =>
      _JurseyQuizGameplayScreenState();
}

class _JurseyQuizGameplayScreenState extends State<JurseyQuizGameplayScreen>
    with TickerProviderStateMixin {
  late List<JurseyQuestionModel> _questions;
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
      return JurseyQuestionModel(
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
    if (_questions.isEmpty) return;
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

    final isCorrect = index == _questions[_currentIndex].correctIndex;

    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (isCorrect) _score++;
    });

    // ✅ Award coins + XP instantly on correct answer so top bar updates live
    if (isCorrect) {
      context.read<UserProgressProvider>().onCorrectAnswer();
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  Future<void> _nextQuestion() async {
    if (_currentIndex >= _questions.length - 1) {
      await _finish();
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
    final earnedStars = _score >= 10
        ? 3
        : _score >= 5
        ? 2
        : 1;

    // ✅ correctAnswers: 0 because onCorrectAnswer() already handled coins/XP
    // per answer above. Only earnedStars + completion bonus are added here.
    await context.read<UserProgressProvider>().onQuizCompleted(
      earnedStars: earnedStars,
    );

    if (!mounted) return;

    final result = LevelResultModels(
      score: _score,
      totalQuestions: total,
      starsEarned: earnedStars,
      xpEarned: _score * 20,
      coinsEarned: _score * 10,
      accuracy: total > 0 ? ((_score / total) * 100).round() : 0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JurseyLevelCompleteScreen(
          result: result,
          onNextLevel: () => Navigator.pop(context, _score),
          onReplayLevel: () {
            Navigator.pop(context);
            _resetGame();
          },
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    // ✅ Watch provider so top bar rebuilds whenever coins/stars change
    final progress = context.watch<UserProgressProvider>();
    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Pass live values from provider into the top bar
            JurseyQuizTopBar(
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
                      JurseyImageCard(imagePath: q.imagePath),
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
    );
  }
}
