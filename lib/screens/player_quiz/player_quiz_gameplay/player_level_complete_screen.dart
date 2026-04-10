// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/player_quiz/player_quiz_gameplay/player_level_complete_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
//
// FIX: This is now a Widget (not a full Scaffold route).
//      It is shown as a Stack overlay inside PlayerQuizGameplayScreen.
//      onNextLevel and onReplayLevel are called directly — no Navigator.pop
//      needed here because the parent (GameplayScreen) handles navigation.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/level_result_models.dart';

class PlayerLevelCompleteScreen extends StatefulWidget {
  final LevelResultModels result;
  final VoidCallback? onNextLevel;
  final VoidCallback? onReplayLevel;

  const PlayerLevelCompleteScreen({
    super.key,
    required this.result,
    this.onNextLevel,
    this.onReplayLevel,
  });

  @override
  State<PlayerLevelCompleteScreen> createState() =>
      _PlayerLevelCompleteScreenState();
}

class _PlayerLevelCompleteScreenState extends State<PlayerLevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  int get _starsEarned {
    final correct = widget.result.score;
    if (correct >= 10) return 3;
    if (correct >= 5) return 2;
    return 1;
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
        return Icon(
          index < stars ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 48,
          color: index < stars ? Colors.amber : Colors.grey[700],
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
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Covers entire screen as overlay (no Scaffold needed)
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
                const Text(
                  "LEVEL COMPLETED!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                _buildStars(_starsEarned),
                const SizedBox(height: 20),

                // Score
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A38),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Score: ${widget.result.score}/${widget.result.totalQuestions}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "REWARDS EARNED",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRewardCard(
                      Icons.bolt,
                      "EXPERIENCE",
                      "+${widget.result.xpEarned} XP",
                      Colors.yellow,
                    ),
                    const SizedBox(width: 16),
                    _buildRewardCard(
                      Icons.monetization_on,
                      "CURRENCY",
                      "+${widget.result.coinsEarned} Coins",
                      Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Accuracy
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A38),
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
                            "Accuracy",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.result.accuracy}%",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ✅ Next Level button — calls onNextLevel directly
                //    GameplayScreen handles Navigator.pop(context, _score)
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
                            "CONTINUE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ Replay button — calls onReplayLevel directly
                //    GameplayScreen resets the quiz in-place
                GestureDetector(
                  onTap: widget.onReplayLevel,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2A38),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.replay, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "REPLAY LEVEL",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
