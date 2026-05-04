// lib/screens/home/widgets/streak_reward_popup.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/controllers/streak_controller.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';

/// Shows the high-fidelity Streak Reward popup.
void showStreakRewardPopup(
  BuildContext context, {
  required int streakDays,
  required int coinsEarned,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.8),
    builder: (_) =>
        StreakRewardPopup(streakDays: streakDays, coinsEarned: coinsEarned),
  );
}

class StreakRewardPopup extends StatefulWidget {
  final int streakDays;
  final int coinsEarned;

  const StreakRewardPopup({
    super.key,
    required this.streakDays,
    required this.coinsEarned,
  });

  @override
  State<StreakRewardPopup> createState() => _StreakRewardPopupState();
}

class _StreakRewardPopupState extends State<StreakRewardPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      // Mark as claimed in Firestore
      await StreakController.claimReward();

      // Sync reward to Firestore/Provider
      if (mounted) {
        await context.read<UserProgressProvider>().onStreakCompleted();
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      debugPrint(' StreakRewardPopup: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              decoration: BoxDecoration(
                color: ThemeColors.of(context).cardBg,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Party Popper Icon
                  Image.network(
                    'https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Activities/Party%20Popper.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (_, _, _) =>
                        const Text('🎉', style: TextStyle(fontSize: 60)),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'Streak Reward Claimed!',
                    style: TextStyle(
                      color: ThemeColors.of(context).hText,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'You completed a ${widget.streakDays}-day streak.',
                    style: TextStyle(
                      color: ThemeColors.of(context).stext,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Coin Reward Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.of(context).deepCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ThemeColors.of(context).divider,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '+${widget.coinsEarned}',
                          style: TextStyle(
                            color: ThemeColors.of(context).hText,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Coin Icon
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFC107),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66FFC107),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'COINS',
                          style: TextStyle(
                            color: ThemeColors.of(context).hText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF1DB954,
                        ), // Spotify Green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        shadowColor: const Color(
                          0xFF1DB954,
                        ).withValues(alpha: 0.4),
                      ),
                      child: _loading
                          ? const Text(
                              '...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
