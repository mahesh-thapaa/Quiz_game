// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/player_quiz/player_quiz_gameplay/player_quiz_gameplay_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
//
// ROOT CAUSE FIX:
// Before: _finish() did Navigator.push(PlayerLevelCompleteScreen)
//         Then PlayerLevelCompleteScreen did Navigator.pop(context, score)
//         → score only went back to GameplayScreen, NOT PlayerScreenQuiz
//
// Fix: _finish() now pops GameplayScreen immediately with the score.
//      PlayerLevelCompleteScreen is shown as an OVERLAY inside GameplayScreen
//      using a Stack, so no Navigator.push is needed for it.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/player_question_model.dart';
import 'package:quiz_game/screens/player_quiz/player_quiz_gameplay/player_quiz_top_bar.dart';
import 'package:quiz_game/screens/player_quiz/player_quiz_gameplay/player_image_card.dart';
import 'package:quiz_game/screens/player_quiz/player_quiz_gameplay/player_answer_option.dart';
import 'package:quiz_game/screens/player_quiz/player_quiz_gameplay/player_level_complete_screen.dart';
import 'package:quiz_game/models/level_result_models.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';

class PlayerQuizGameplayScreen extends StatefulWidget {
  final List<QuizQuestion> questions;

  const PlayerQuizGameplayScreen({super.key, required this.questions});

  @override
  State<PlayerQuizGameplayScreen> createState() =>
      _PlayerQuizGameplayScreenState();
}

class _PlayerQuizGameplayScreenState extends State<PlayerQuizGameplayScreen>
    with TickerProviderStateMixin {
  late List<PlayerQuestionModel> _questions;
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _score = 0;

  // ✅ Controls whether result overlay is visible
  bool _showResult = false;
  LevelResultModels? _result;

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
      return PlayerQuestionModel(
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
      _showResult = false;
      _result = null;
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
      score: _score,
      totalQuestions: total,
      starsEarned: _score >= 10 ? 3 : (_score >= 5 ? 2 : 1),
      xpEarned: _score * 20,
      coinsEarned: _score * 10,
      accuracy: ((_score / total) * 100).toInt(),
    );

    // ✅ Show result as overlay — no Navigator.push needed
    setState(() {
      _result = result;
      _showResult = true;
    });
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
      body: Stack(
        children: [
          // ── Quiz content ──
          SafeArea(
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

          // ✅ Result overlay — shown when quiz ends
          // Replaces the screen in-place without Navigator.push
          // so Navigator.pop(_score) goes directly back to PlayerScreenQuiz
          if (_showResult && _result != null)
            PlayerLevelCompleteScreen(
              result: _result!,

              // ✅ "Next Level" → pop GameplayScreen with score
              //    Score goes directly to PlayerScreenQuiz._handleQuizResult()
              onNextLevel: () => Navigator.pop(context, _score),

              // ✅ "Replay" → reset quiz, stay in GameplayScreen
              onReplayLevel: _resetGame,
            ),
        ],
      ),
    );
  }
}
