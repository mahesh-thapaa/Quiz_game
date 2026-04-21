import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/level_result_models.dart';
import 'package:quiz_game/services/star_calculation_service.dart';

class ClubLevelCompleteScreen extends StatefulWidget {
  final LevelResultModels result;
  final int levelNumber;
  final VoidCallback onNextLevel;
  final VoidCallback onReplayLevel;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const ClubLevelCompleteScreen({
    super.key,
    required this.result,
    required this.levelNumber,
    required this.onNextLevel,
    required this.onReplayLevel,
    required this.onBack,
    required this.onClose,
  });

  @override
  State<ClubLevelCompleteScreen> createState() =>
      _ClubLevelCompletedCardState();
}

class _ClubLevelCompletedCardState extends State<ClubLevelCompleteScreen>
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
            color: index < stars ? Colors.amber : Colors.grey[700],
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
          color: const Color(0xFF1A2433),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: Container(
        color: const Color(0xFF0F1923),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── LEVEL COMPLETED Title ──
                const Text(
                  'LEVEL COMPLETED!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 28),

                // ── Stars ──
                _buildStars(_starsEarned),

                const SizedBox(height: 24),

                // ── Score Badge ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2433),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Score: ${widget.result.score}/${widget.result.totalQuestions}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── REWARDS EARNED label ──
                Text(
                  'REWARDS EARNED',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 14),

                // ── XP & Coins reward cards ──
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

                // ── Accuracy row ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2433),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Accuracy',
                            style: TextStyle(color: Colors.white, fontSize: 15),
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

                // ── NEXT LEVEL button ──
                GestureDetector(
                  onTap: widget.onNextLevel,
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

                // ── REPLAY LEVEL button ──
                GestureDetector(
                  onTap: widget.onReplayLevel,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2433),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.replay, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'REPLAY LEVEL',
                            style: TextStyle(
                              color: Colors.white,
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
