import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/stadium_question_model.dart';
import 'package:quiz_game/data/stadium_quiz_data.dart';
import 'package:quiz_game/screens/player_quiz/player_quiz_gameplay/player_quiz_top_bar.dart';
import 'package:quiz_game/screens/player_quiz/player_quiz_gameplay/player_image_card.dart';
import 'package:quiz_game/screens/player_quiz/player_quiz_gameplay/player_answer_option.dart';
import 'stadium_level_completed_card.dart';

class StadiumQuizGameplayScreen extends StatefulWidget {
  const StadiumQuizGameplayScreen({super.key});

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
    _questions = StadiumQuizData.getQuestions();

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

    final result = StadiumQuizResult(
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
        builder: (_) => StadiumLevelCompletedCard(result: result),
      ),
    );
  }

  PlayerOptionState _getState(int index) {
    if (!_answered) {
      return _selectedIndex == index
          ? PlayerOptionState.selected
          : PlayerOptionState.idle;
    }

    if (index == _questions[_currentIndex].correctIndex) {
      return PlayerOptionState.correct;
    }

    if (index == _selectedIndex) {
      return PlayerOptionState.wrong;
    }

    return PlayerOptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            PlayerQuizTopBar(onBack: () => Navigator.pop(context)),

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
                      PlayerImageCard(imagePath: q.imagePath),
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
                        return PlayerAnswerOption(
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
