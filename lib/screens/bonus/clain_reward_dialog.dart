// lib/widgets/claim_reward_dialog.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

// ── Dot Widget ────────────────────────────────────────────────
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

// ── Claim Reward Dialog ───────────────────────────────────────
class ClaimRewardDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final int coins;
  final String buttonLabel;
  final VoidCallback? onTap;
  final Widget? nextScreen; // ← pass the screen to navigate to

  const ClaimRewardDialog({
    Key? key,
    this.title = 'CONGRATULATIONS!',
    this.subtitle = 'REWARD CLAIMED SUCCESSFULLY',
    this.coins = 100,
    this.buttonLabel = 'AWESOME',
    this.onTap,
    this.nextScreen, // ← optional next screen
  }) : super(key: key);

  @override
  State<ClaimRewardDialog> createState() => _ClaimRewardDialogState();
}

class _ClaimRewardDialogState extends State<ClaimRewardDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _coinBounce;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnim = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _coinBounce = Tween<double>(begin: -10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.bounceOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Handle button tap ──
  void _handleTap() {
    if (widget.onTap != null) {
      // Use custom onTap if provided
      widget.onTap!();
    } else if (widget.nextScreen != null) {
      // Navigate to nextScreen and remove all previous routes
      Navigator.pop(context); // close dialog first
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.nextScreen!),
      );
    } else {
      // Default: just close dialog
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2B3C),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Decorative dots + Coin ──
                SizedBox(
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Decorative dots
                      const Positioned(
                        top: 10,
                        left: 10,
                        child: _Dot(color: Color(0xFF9B59B6), size: 10),
                      ),
                      const Positioned(
                        top: 5,
                        right: 30,
                        child: _Dot(color: Color(0xFFF1C40F), size: 14),
                      ),
                      const Positioned(
                        bottom: 10,
                        left: 30,
                        child: _Dot(color: Color(0xFFF1C40F), size: 12),
                      ),
                      const Positioned(
                        bottom: 5,
                        right: 10,
                        child: _Dot(color: Color(0xFF9B59B6), size: 8),
                      ),

                      // ── Bouncing Coin ──
                      AnimatedBuilder(
                        animation: _coinBounce,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _coinBounce.value),
                            child: child,
                          );
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFE6A817)],
                              center: Alignment(-0.3, -0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFFD700,
                                ).withValues(alpha: 0.6),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '\$',
                              style: TextStyle(
                                color: Color(0xFFB8860B),
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Title ──
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // ── Subtitle ──
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.stext,
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Coins Badge ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1E2D),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '+${widget.coins}',
                        style: const TextStyle(
                          color: AppColors.hText,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Mini coin
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFE6A817)],
                            center: Alignment(-0.3, -0.3),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '\$',
                            style: TextStyle(
                              color: Color(0xFFB8860B),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        'COINS',
                        style: TextStyle(
                          color: AppColors.hText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Awesome Button ──
                GestureDetector(
                  onTap: _handleTap,
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Center(
                      child: Text(
                        widget.buttonLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
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
