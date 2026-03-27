import 'package:flutter/material.dart';
import 'package:quiz_game/models/level_result_models.dart';

class JerseyLevelCompleteScreen extends StatefulWidget {
  final LevelResultModels result;
  final VoidCallback? onNextLevel;
  final VoidCallback? onReplayLevel;

  const JerseyLevelCompleteScreen({
    super.key,
    required this.result,
    this.onNextLevel,
    this.onReplayLevel,
  });

  @override
  State<JerseyLevelCompleteScreen> createState() =>
      _JerseyLevelCompleteScreenState();
}

class _JerseyLevelCompleteScreenState extends State<JerseyLevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

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

  Widget buildStars(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          Icons.star,
          size: 48,
          color: index < stars ? Colors.amber : Colors.grey[700],
        );
      }),
    );
  }

  Widget buildRewardCard(
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
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

                // Stars
                buildStars(widget.result.starsEarned),
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

                // Rewards Label
                const Text(
                  "REWARDS EARNED",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),

                // Reward Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRewardCard(
                      Icons.bolt,
                      "EXPERIENCE",
                      "+${widget.result.xpEarned} XP",
                      Colors.yellow,
                    ),
                    const SizedBox(width: 16),
                    buildRewardCard(
                      Icons.monetization_on,
                      "CURRENCY",
                      "+${widget.result.coinsEarned} Coins",
                      Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Accuracy Row
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
                      Row(
                        children: const [
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

                // Next Level Button
                GestureDetector(
                  onTap: widget.onNextLevel ?? () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "NEXT LEVEL",
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

                // Replay Button
                GestureDetector(
                  onTap: widget.onReplayLevel ?? () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2A38),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
