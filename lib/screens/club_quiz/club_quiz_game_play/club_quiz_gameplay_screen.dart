import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/club_question_model.dart';
import 'package:quiz_game/data/club_data.dart';
import 'package:quiz_game/models/level_result_models.dart'; // ✅ FIXED IMPORT
import 'package:quiz_game/screens/club_quiz/club_quiz_game_play/club_answer_options.dart';
import 'package:quiz_game/screens/club_quiz/club_quiz_game_play/club_quiz_top_bar.dart';
import 'club_level_complete_screen.dart';

class ClubQuizGameplayScreen extends StatefulWidget {
  const ClubQuizGameplayScreen({super.key});

  @override
  State<ClubQuizGameplayScreen> createState() => _ClubQuizGameplayScreenState();
}

class _ClubQuizGameplayScreenState extends State<ClubQuizGameplayScreen>
    with TickerProviderStateMixin {
  late List<ClubQuestionModel> _questions;
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
    _questions = ClubData.getQuestions();

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

  void _onOptionTap(int index) {
    if (_answered) return;

    setState(() {
      _selectedIndex = index;
      _answered = true;

      if (index == _questions[_currentIndex].correctIndex) {
        _score++;
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

  void _finish() {
    final total = _questions.length;

    final result = LevelResultModels(
      // ✅ FIXED: was ClubQuizResult
      score: _score,
      totalQuestions: total,
      starsEarned: _score,
      xpEarned: _score * 20,
      coinsEarned: _score * 10,
      accuracy: ((_score / total) * 100).toInt(),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ClubLevelCompleteScreen(result: result),
      ),
    );
  }

  ClubAnswerOptions _getState(int index) {
    if (!_answered) {
      return _selectedIndex == index
          ? ClubAnswerOptions.selected
          : ClubAnswerOptions.idle;
    }

    if (index == _questions[_currentIndex].correctIndex) {
      return ClubAnswerOptions.correct;
    }

    if (index == _selectedIndex) {
      return ClubAnswerOptions.wrong;
    }

    return ClubAnswerOptions.idle;
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ClubQuizTopBar(onBack: () => Navigator.pop(context)),

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
                child: Column(
                  children: [
                    Text(
                      q.questionText,
                      style: const TextStyle(
                        color: AppColors.hText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ...List.generate(q.options.length, (i) {
                      return ClubAnswerOption(
                        label: _labels[i],
                        text: q.options[i],
                        state: _getState(i),
                        onTap: () => _onOptionTap(i),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
