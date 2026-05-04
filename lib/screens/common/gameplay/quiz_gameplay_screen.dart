import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_game/models/gameplay_question_model.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/common/gameplay/answer_option.dart';
import 'package:quiz_game/screens/common/gameplay/level_complete_screen.dart';
import 'package:quiz_game/screens/common/gameplay/quiz_top_bar.dart';
import 'package:quiz_game/screens/common/gameplay/quiz_image_card.dart';
import 'package:quiz_game/models/level_result_models.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';
import 'package:quiz_game/controllers/star_calculation_service.dart';
import 'package:quiz_game/services/ads/ad_service.dart';
import 'package:quiz_game/controllers/ad_display_controller.dart';
// import 'package:quiz_game/controllers/house_ad_controller.dart';

class QuizGameplayScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final int levelNumber;
  final String? levelTitle;
  final bool isBonus;
  final int? nextLevelNumber;
  final String quizTitle;
  final Future<void> Function(LevelResultModels, int) onLevelComplete;
  final Future<List<QuizQuestion>> Function(int) getQuestionsForLevel;
  final String Function(int)? getGameplayTitle;
  final bool Function(int)? isBonusLevel;

  const QuizGameplayScreen({
    super.key,
    required this.questions,
    required this.levelNumber,
    this.levelTitle,
    this.isBonus = false,
    this.nextLevelNumber,
    this.quizTitle = 'QUIZ',
    required this.onLevelComplete,
    required this.getQuestionsForLevel,
    this.getGameplayTitle,
    this.isBonusLevel,
  });

  @override
  State<QuizGameplayScreen> createState() => _QuizGameplayScreenState();
}

class _QuizGameplayScreenState extends State<QuizGameplayScreen>
    with TickerProviderStateMixin {
  late List<GameplayQuestionModel> _questions;
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
  BannerAd? _bannerAd;

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
    _loadBannerAd();
  }

  void _loadBannerAd() {
    final ad = AdService().createBannerAd();
    ad.load().then((_) {
      if (mounted) {
        setState(() {
          _bannerAd = ad;
        });
      }
    });
  }

  void _initQuestions(List<QuizQuestion> qs) {
    _questions = qs.asMap().entries.map((entry) {
      final index = entry.key;
      final q = entry.value;
      return GameplayQuestionModel(
        questionNumber: index + 1,
        totalQuestions: qs.length,
        questionText: q.title,
        options: q.options,
        correctIndex: q.correctAnswerIndex,
        imageUrl: q.imageUrl,
      );
    }).toList();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _fadeCtrl.dispose();
    _bannerAd?.dispose();
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

    // Show loading indicator or handle async fetch
    final nextQuestions = await widget.getQuestionsForLevel(nextLevel);

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

  AnswerState _getState(int index) {
    if (!_answered) {
      return _selectedIndex == index ? AnswerState.selected : AnswerState.idle;
    }
    if (index == _questions[_currentIndex].correctIndex) {
      return AnswerState.correct;
    }
    if (index == _selectedIndex) return AnswerState.wrong;
    return AnswerState.idle;
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
      backgroundColor: ThemeColors.of(context).background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                QuizTopBar(
                  onBack: () => _safePop(null),
                  title: widget.quizTitle,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        '$_displayTitle  •  QUESTION ${q.questionNumber} OF ${q.totalQuestions}',
                        style: TextStyle(color: ThemeColors.of(context).stext),
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
                          Text(
                            q.questionText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ThemeColors.of(context).hText,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 25),
                          if (q.imageUrl != null && q.imageUrl!.isNotEmpty)
                            QuizImageCard(imageUrl: q.imageUrl!),
                          if (q.imageUrl != null && q.imageUrl!.isNotEmpty)
                            const SizedBox(height: 20),
                          ...List.generate(q.options.length, (i) {
                            return AnswerOption(
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
                if (_bannerAd != null)
                  Container(
                    alignment: Alignment.center,
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
              ],
            ),
          ),

          // ── Result overlay ──
          if (_showResult && _result != null)
            LevelCompleteScreen(
              result: _result!,
              levelNumber: _currentLevelNumber,
              onNextLevel: () {
                AdDisplayController().handleLevelTransition(
                  onComplete: _goToNextLevel,
                );
              },
              onReplayLevel: _resetGame,
              onBack: () => _safePop(null),
              onClose: () => _safePop(null),
            ),
        ],
      ),
    );
  }
}
