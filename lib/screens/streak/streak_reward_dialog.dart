// lib/screens/bonus/streak_reward_dialog.dart
//
// Shows the "Streak Reward Claimed!" popup that appears after the user
// completes a full 7-day login streak.
//
// Usage:
//   showStreakRewardDialog(context, streakDays: 7, coinsEarned: 500);

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/confetti_particle.dart';
import 'package:quiz_game/painters/confetti_painter.dart';
import 'package:quiz_game/screens/streak/coin_badge.dart';
import 'package:quiz_game/screens/streak/gradient_button.dart';

// ── Public helper ─────────────────────────────────────────────────────────────

/// Show the streak reward dialog imperatively.
///
/// ```dart
/// showStreakRewardDialog(context, streakDays: 7, coinsEarned: 500);
/// ```
void showStreakRewardDialog(
  BuildContext context, {
  required int streakDays,
  required int coinsEarned,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.75),
    builder: (_) =>
        StreakRewardDialog(streakDays: streakDays, coinsEarned: coinsEarned),
  );
}

// ── Widget ────────────────────────────────────────────────────────────────────

class StreakRewardDialog extends StatefulWidget {
  final int streakDays;
  final int coinsEarned;

  const StreakRewardDialog({
    super.key,
    required this.streakDays,
    required this.coinsEarned,
  });

  @override
  State<StreakRewardDialog> createState() => _StreakRewardDialogState();
}

class _StreakRewardDialogState extends State<StreakRewardDialog>
    with TickerProviderStateMixin {
  // Entrance animation
  late final AnimationController _entranceCtrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _coinSlideAnim;

  // Looping confetti
  late final AnimationController _confettiCtrl;

  late final List<ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();

    // Entrance
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _scaleAnim = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.elasticOut,
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeIn);
    _coinSlideAnim = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // Confetti
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _particles = ConfettiParticle.generate(count: 30);
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: _DialogCard(
            confettiCtrl: _confettiCtrl,
            particles: _particles,
            coinSlideAnim: _coinSlideAnim,
            streakDays: widget.streakDays,
            coinsEarned: widget.coinsEarned,
          ),
        ),
      ),
    );
  }
}

// ── Card body (stateless) ─────────────────────────────────────────────────────

class _DialogCard extends StatelessWidget {
  final AnimationController confettiCtrl;
  final List<ConfettiParticle> particles;
  final Animation<double> coinSlideAnim;
  final int streakDays;
  final int coinsEarned;

  const _DialogCard({
    required this.confettiCtrl,
    required this.particles,
    required this.coinSlideAnim,
    required this.streakDays,
    required this.coinsEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2535),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 32,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // ── Confetti layer ──────────────────────────────────────────────
            Positioned.fill(
              child: AnimatedBuilder(
                animation: confettiCtrl,
                builder: (_, __) => CustomPaint(
                  painter: ConfettiPainter(
                    particles: particles,
                    progress: confettiCtrl.value,
                  ),
                ),
              ),
            ),

            // ── Content ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Party icon
                  _PartyIcon(),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Streak Reward Claimed!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'You completed a $streakDays-day streak.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Coin badge with slide-in
                  AnimatedBuilder(
                    animation: coinSlideAnim,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(0, coinSlideAnim.value),
                      child: child,
                    ),
                    child: CoinBadge(coins: coinsEarned),
                  ),
                  const SizedBox(height: 28),

                  // Continue button
                  GradientButton(
                    label: 'Continue',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Party icon ────────────────────────────────────────────────────────────────

class _PartyIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.06),
      ),
      child: const Center(child: Text('🎉', style: TextStyle(fontSize: 38))),
    );
  }
}
