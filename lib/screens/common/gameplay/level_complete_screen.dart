import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/level_result_models.dart';
// import 'package:quiz_game/models/theme_colors.dart';
import 'package:quiz_game/controllers/star_calculation_service.dart';
import 'package:quiz_game/controllers/ad_display_controller.dart';

class LevelCompleteScreen extends StatefulWidget {
  final LevelResultModels result;
  final int levelNumber;
  final VoidCallback onNextLevel;
  final VoidCallback onReplayLevel;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const LevelCompleteScreen({
    super.key,
    required this.result,
    required this.levelNumber,
    required this.onNextLevel,
    required this.onReplayLevel,
    required this.onBack,
    required this.onClose,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  int get _starsEarned {
    return StarCalculationService.calculateStars(widget.result.score);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStars(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            index < stars ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 52,
            color: index < stars
                ? Colors.amber
                : ThemeColors.of(context).stext.withValues(alpha: 0.3),
          ),
        );
      }),
    );
  }

  Widget _buildRewardCard(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: ThemeColors.of(context).stext,
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: ThemeColors.of(context).hText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNextLevel() {
    if (widget.result.score == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please try again!!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return; // Stop here if score is 0
    }

    AdDisplayController().handleLevelTransition(onComplete: widget.onNextLevel);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: Container(
        color: ThemeColors.of(context).background,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: ThemeColors.of(context).hText,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'LEVEL COMPLETED!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColors.of(context).hText,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 28),

                // STARS
                _buildStars(_starsEarned),

                const SizedBox(height: 24),

                // SCORE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).cardBg,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Score: ${widget.result.score}/${widget.result.totalQuestions}',
                    style: TextStyle(
                      color: ThemeColors.of(context).hText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                if (widget.levelNumber % 6 == 0)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'BONUS 2X REWARD!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                Text(
                  'REWARDS EARNED',
                  style: TextStyle(
                    color: ThemeColors.of(context).stext,
                    fontSize: 11,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    _buildRewardCard(
                      Icons.bolt,
                      'EXPERIENCE',
                      '+${widget.result.xpEarned} XP',
                      Colors.yellow,
                    ),
                    const SizedBox(width: 12),
                    _buildRewardCard(
                      Icons.monetization_on,
                      'CURRENCY',
                      '+${widget.result.coinsEarned} Coins',
                      Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ACCURACY
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.of(context).cardBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Accuracy',
                            style: TextStyle(
                              color: ThemeColors.of(context).hText,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.result.accuracy}%',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // NEXT LEVEL BUTTON
                GestureDetector(
                  onTap: _handleNextLevel,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'NEXT LEVEL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // REPLAY BUTTON
                GestureDetector(
                  onTap: widget.onReplayLevel,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.replay,
                            color: ThemeColors.of(context).hText,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'REPLAY LEVEL',
                            style: TextStyle(
                              color: ThemeColors.of(context).hText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
