// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/home/widgets/reward_dialog.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class RewardDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final int coins;
  final String buttonLabel;
  final VoidCallback onTap;

  const RewardDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.coins,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeColors.of(context);

    return FadeTransition(
      opacity: _fadeAnim,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: _DialogContent(
            theme: theme,
            title: widget.title,
            subtitle: widget.subtitle,
            coins: widget.coins,
            buttonLabel: widget.buttonLabel,
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dialog Content
// ─────────────────────────────────────────────────────────────────────────────

class _DialogContent extends StatelessWidget {
  final ThemeColors theme;
  final String title;
  final String subtitle;
  final int coins;
  final String buttonLabel;
  final VoidCallback onTap;

  const _DialogContent({
    required this.theme,
    required this.title,
    required this.subtitle,
    required this.coins,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardBg, // ✅ ThemeColors — light/dark aware
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineBorder, // ✅ branded green border
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow, // ✅ branded green glow
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Coin with particles ──
          _CoinWithParticles(theme: theme),

          const SizedBox(height: 20),

          // ── Title ──
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.titleColor, // ✅ #1DB954 branded green
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 6),

          // ── Subtitle ──
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.stext, // ✅ ThemeColors — light/dark aware
              fontSize: 12,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 22),

          // ── Coins Row ──
          _CoinsRow(coins: coins, theme: theme),

          const SizedBox(height: 26),

          // ── AWESOME Button ──
          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient, // ✅ branded gradient
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: AppColors.hText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onTap,
                child: const Text(
                  // buttonLabel is passed but style is const for perf;
                  // use Text(buttonLabel, ...) if label changes at runtime
                  'AWESOME',
                  style: TextStyle(
                    color: AppColors.hText,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gold Coin + Floating Particles
// ─────────────────────────────────────────────────────────────────────────────

class _CoinWithParticles extends StatelessWidget {
  final ThemeColors theme;
  const _CoinWithParticles({required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Yellow dot particles (AppColors.doller) ──
          Positioned(
            top: 10,
            left: 20,
            child: _Dot(color: AppColors.doller, size: 12),
          ),
          Positioned(
            top: 4,
            right: 30,
            child: _Dot(color: AppColors.doller, size: 18),
          ),
          Positioned(
            bottom: 10,
            right: 50,
            child: _Dot(color: AppColors.doller, size: 8),
          ),

          // ── Diamond particles (AppColors.primary / secondary) ──
          Positioned(
            left: 14,
            bottom: 20,
            child: _DiamondDot(color: AppColors.primary, size: 10),
          ),
          Positioned(
            right: 10,
            top: 30,
            child: _DiamondDot(color: AppColors.secondary, size: 10),
          ),

          // ── Main Gold Coin ──
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.doller, // ✅ #FFD700 bright gold
                  AppColors.dShade, // ✅ #E6A817 deep gold
                  AppColors.dShade.withValues(alpha: 0.75),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.doller.withValues(alpha: 0.45),
                  blurRadius: 22,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '\$',
                style: TextStyle(
                  color: theme.deepCard, // ✅ dark symbol — theme aware
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// +100  💰  COINS  Row
// ─────────────────────────────────────────────────────────────────────────────

class _CoinsRow extends StatelessWidget {
  final int coins;
  final ThemeColors theme;

  const _CoinsRow({required this.coins, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.deepCard, // ✅ ThemeColors — dark pill bg
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineBorder, // ✅ branded green border
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // +100
          Text(
            '+$coins',
            style: TextStyle(
              color: theme.hText, // ✅ ThemeColors
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(width: 10),

          // Mini gold coin
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.doller,
                  AppColors.dShade,
                  AppColors.dShade.withValues(alpha: 0.75),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: Center(
              child: Text(
                '\$',
                style: TextStyle(
                  color: theme.deepCard, // ✅ ThemeColors
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // COINS label
          Text(
            'COINS',
            style: TextStyle(
              color: theme.hText, // ✅ ThemeColors
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared micro-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  const _Dot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DiamondDot extends StatelessWidget {
  final Color color;
  final double size;
  const _DiamondDot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
