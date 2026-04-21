import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';

class ClubQuizTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const ClubQuizTopBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    // ✅ reads live values from provider — no need to pass stars/coins as params
    final p = context.watch<UserProgressProvider>();

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
                'CLUB QUIZ',
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
            value: '${p.stars}',
          ),
          const SizedBox(width: 8),
          _Chip(
            icon: Icons.monetization_on_rounded,
            iconColor: AppColors.doller,
            value: '${p.coins}',
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
