import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class JurseyQuizTopBar extends StatelessWidget {
  final int stars;
  final int coins;
  final VoidCallback onBack;

  const JurseyQuizTopBar({
    super.key,
    required this.stars, // ✅ required — no hardcoded default
    required this.coins, // ✅ required — no hardcoded default
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 12, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.hText,
              size: 28,
            ),
            onPressed: onBack,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 4),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOALIQ',
                style: TextStyle(
                  color: AppColors.stext,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'JERSEY QUIZ',
                style: TextStyle(
                  color: AppColors.hText,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          _Chip(
            icon: Icons.star_rounded,
            iconColor: AppColors.doller,
            value: '$stars',
          ),
          const SizedBox(width: 8),
          _Chip(
            icon: Icons.monetization_on_rounded,
            iconColor: AppColors.doller,
            value: '$coins',
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;

  const _Chip({
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.hText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
