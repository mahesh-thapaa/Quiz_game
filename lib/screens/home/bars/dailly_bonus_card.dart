import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/home_models/home_models.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/home/widgets/reward_dialog.dart';
import 'package:quiz_game/screens/home/bars/bonus_servies.dart';

class DailyBonusCard extends StatefulWidget {
  final DailyBonusModel bonus;

  const DailyBonusCard({super.key, required this.bonus});

  @override
  State<DailyBonusCard> createState() => _DailyBonusCardState();
}

class _DailyBonusCardState extends State<DailyBonusCard>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  bool _claiming = false;
  bool _alreadyClaimed = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );

    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _checkClaimed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkClaimed() async {
    try {
      final claimed = await BonusService.hasClaimedToday();

      if (!mounted) return;

      setState(() {
        _alreadyClaimed = claimed;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _handleClaim() async {
    if (_claiming || _alreadyClaimed) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) {
      _showSnack('Login to claim the reward!', isError: true);
      return;
    }

    _controller.reverse().then((_) => _controller.forward());

    setState(() {
      _claiming = true;
    });

    try {
      final newTotalCoins = await BonusService.claimBonus(
        bonusCoins: widget.bonus.coins,
      );

      if (!mounted) return;

      context.read<UserProgressProvider>().updateCoins(newTotalCoins);

      setState(() {
        _alreadyClaimed = true;
        _claiming = false;
      });

      await Future.delayed(const Duration(milliseconds: 180));

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: ThemeColors.of(
          context,
        ).background.withValues(alpha: 0.72),
        builder: (_) {
          return RewardDialog(
            title: 'CONGRATULATIONS!',
            subtitle: 'REWARD CLAIMED SUCCESSFULLY',
            coins: widget.bonus.coins,
            buttonLabel: 'AWESOME',
            onTap: () => Navigator.pop(context),
          );
        },
      );
    } on AlreadyClaimedException {
      if (!mounted) return;

      setState(() {
        _alreadyClaimed = true;
        _claiming = false;
      });

      _showSnack('You already claimed today\'s bonus!', isError: false);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _claiming = false;
      });

      _showSnack('Something went wrong. Please try again.', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeColors.of(context);

    return ScaleTransition(
      scale: _scaleAnim,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          gradient: _alreadyClaimed
              ? LinearGradient(
                  colors: [theme.cardBg.withValues(alpha: 0.85), theme.cardBg],
                )
              : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          border: _alreadyClaimed
              ? Border.all(color: theme.divider, width: 1)
              : null,
          boxShadow: _alreadyClaimed
              ? []
              : [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    color: AppColors.primary.withValues(alpha: 0.22),
                  ),
                ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -8,
              right: 6,
              child: Transform.rotate(
                angle: -0.26, // Tilted counter-clockwise by approx 15 degrees
                child: SvgPicture.asset(
                  'assets/svg/gift.svg',
                  height: 76,
                  width: 76,
                  colorFilter: ColorFilter.mode(
                    _alreadyClaimed
                        ? theme.stext.withValues(alpha: 0.12)
                        : const Color(0xFF0F172A).withValues(alpha: 0.08),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _alreadyClaimed ? 'Bonus Claimed' : widget.bonus.title,
                  style: TextStyle(
                    color: _alreadyClaimed
                        ? theme.hText.withValues(alpha: 0.55)
                        : const Color(0xFF0F172A),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _alreadyClaimed
                      ? 'Come back tomorrow for your next bonus!'
                      : widget.bonus.subtitle,
                  style: TextStyle(
                    color: _alreadyClaimed
                        ? theme.stext
                        : const Color(0xFF0F172A).withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 14),

                // SAME LINE FIXED
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '+${widget.bonus.coins}',
                          style: TextStyle(
                            color: _alreadyClaimed
                                ? theme.hText.withValues(alpha: 0.55)
                                : const Color(0xFF0F172A),
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),

                        const SizedBox(width: 8),

                        _alreadyClaimed
                            ? SvgPicture.asset(
                                'assets/svg/coin-svgrepo-com.svg',
                                height: 24,
                                width: 24,
                                colorFilter: ColorFilter.mode(
                                  theme.stext,
                                  BlendMode.srcIn,
                                ),
                              )
                            : SizedBox(
                                width: 34,
                                height: 24,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Coin 1 (bottom/back)
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      child: SvgPicture.asset(
                                        'assets/svg/coin-svgrepo-com.svg',
                                        height: 18,
                                        width: 18,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.doller,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    // Coin 2 (middle)
                                    Positioned(
                                      left: 8,
                                      bottom: 3,
                                      child: SvgPicture.asset(
                                        'assets/svg/coin-svgrepo-com.svg',
                                        height: 18,
                                        width: 18,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.doller,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    // Coin 3 (top/front)
                                    Positioned(
                                      left: 4,
                                      top: 0,
                                      child: SvgPicture.asset(
                                        'assets/svg/coin-svgrepo-com.svg',
                                        height: 18,
                                        width: 18,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.doller,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),

                    const Spacer(),

                    _loading
                        ? const SizedBox(
                            width: 42,
                            height: 42,
                            child: Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 42,
                            child: ElevatedButton(
                              onPressed: (_alreadyClaimed || _claiming)
                                  ? null
                                  : _handleClaim,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                minimumSize: const Size(145, 42),
                                backgroundColor: _alreadyClaimed
                                    ? theme.background.withValues(alpha: 0.25)
                                    : const Color(0xFF0B141E),
                                foregroundColor: _alreadyClaimed
                                    ? theme.stext
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: _claiming
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _alreadyClaimed
                                          ? 'CLAIMED'
                                          : 'CLAIM REWARD',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
