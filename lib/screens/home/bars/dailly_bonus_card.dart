// lib/screens/home/bars/dailly_bonus_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/home_models/home_models.dart';
import 'package:quiz_game/screens/bonus/clain_reward_dialog.dart';

class DailyBonusCard extends StatelessWidget {
  final DailyBonusModel bonus;
  final VoidCallback onClaim;

  const DailyBonusCard({super.key, required this.bonus, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
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
                bonus.title,
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                bonus.subtitle,
                style: TextStyle(color: AppColors.background),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Text(
                    '+${bonus.coins}',
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

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      foregroundColor: AppColors.hText,
                      fixedSize: const Size.fromHeight(40),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: AppColors.background.withValues(
                          alpha: 0.7,
                        ),
                        barrierDismissible: false,
                        builder: (_) => ClaimRewardDialog(
                          title: 'CONGRATULATIONS!',
                          subtitle: 'REWARD CLAIMED SUCCESSFULLY',
                          coins: bonus.coins,
                          buttonLabel: 'AWESOME',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "CLAIM REWARD",
                      style: TextStyle(
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
