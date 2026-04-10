// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/home/bars/daily_bonus_card.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
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

class _DailyBonusCardState extends State<DailyBonusCard> {
  bool _loading = true;
  bool _claiming = false;
  bool _alreadyClaimed = false;

  @override
  void initState() {
    super.initState();
    _checkClaimed();
  }

  Future<void> _checkClaimed() async {
    try {
      final claimed = await BonusService.hasClaimedToday();
      if (mounted) {
        setState(() {
          _alreadyClaimed = claimed;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleClaim() async {
    if (_claiming || _alreadyClaimed) return;

    setState(() => _claiming = true);

    try {
      // ✅ claimBonus writes to Firestore and returns the NEW total coins
      final newTotalCoins = await BonusService.claimBonus(
        bonusCoins: widget.bonus.coins,
      );

      if (!mounted) return;

      // ✅ Update Provider → top bar coin count updates instantly
      context.read<UserProgressProvider>().updateCoins(newTotalCoins);

      setState(() {
        _alreadyClaimed = true;
        _claiming = false;
      });

      // ✅ Show reward dialog
      await showDialog(
        context: context,
        barrierColor: AppColors.background.withValues(alpha: 0.7),
        barrierDismissible: false,
        builder: (_) => RewardDialog(
          title: 'CONGRATULATIONS!',
          subtitle: 'REWARD CLAIMED SUCCESSFULLY',
          coins: widget.bonus.coins,
          buttonLabel: 'AWESOME',
          onTap: () => Navigator.pop(context),
        ),
      );
    } on AlreadyClaimedException {
      if (mounted) {
        setState(() {
          _alreadyClaimed = true;
          _claiming = false;
        });
        _showSnack('You already claimed today\'s bonus!');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Claim error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      if (mounted) {
        setState(() => _claiming = false);
        _showSnack('Error: $e');
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 6)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: _alreadyClaimed
            ? const LinearGradient(
                colors: [Color(0xFF4A4A5A), Color(0xFF3A3A4A)],
              )
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            right: 50,
            child: SvgPicture.asset(
              'asstes/svg/gift.svg',
              colorFilter: ColorFilter.mode(AppColors.stext, BlendMode.srcIn),
              height: 40,
              width: 40,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _alreadyClaimed ? 'Bonus Claimed ✓' : widget.bonus.title,
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                _alreadyClaimed
                    ? 'Come back tomorrow for your next bonus!'
                    : widget.bonus.subtitle,
                style: const TextStyle(color: AppColors.background),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Text(
                    '+${widget.bonus.coins}',
                    style: const TextStyle(
                      color: AppColors.background,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.attach_money_outlined,
                    color: AppColors.dShade,
                    size: 24,
                  ),

                  const Spacer(),

                  _loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _alreadyClaimed
                                ? AppColors.background.withValues(alpha: 0.4)
                                : AppColors.background,
                            foregroundColor: AppColors.hText,
                            fixedSize: const Size.fromHeight(40),
                          ),
                          onPressed: (_alreadyClaimed || _claiming)
                              ? null
                              : _handleClaim,
                          child: _claiming
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.hText,
                                  ),
                                )
                              : Text(
                                  _alreadyClaimed ? 'CLAIMED' : 'CLAIM REWARD',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
