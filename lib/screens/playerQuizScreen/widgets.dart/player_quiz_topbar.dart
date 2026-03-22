// lib/widgets/player_quiz_topbar.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class PlayerQuizTopBar extends StatelessWidget {
  final int coins;
  final VoidCallback onBack;

  const PlayerQuizTopBar({
    super.key,
    required this.coins,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.deepCard,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.hText,
              size: 18,
            ),
          ),
          // Breadcrumb
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GOALIQ',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.stext,
                  letterSpacing: 1.2,
                ),
              ),
              const Text(
                'PLAYER QUIZ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.hText,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Stars indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Row(
              children: [
                Icon(Icons.star_rounded, color: AppColors.doller, size: 14),
                SizedBox(width: 4),
                Text(
                  '2',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Coins
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.dShade.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on_rounded,
                  color: AppColors.doller,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  '$coins',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.doller,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
