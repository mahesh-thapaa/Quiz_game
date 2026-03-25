// lib/screens/player_quiz_gameplay/widgets/player_image_card.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class StadiumImagerCard extends StatelessWidget {
  final String imagePath;

  const StadiumImagerCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Player image ──────────────────────────────────
        Expanded(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineBorder, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              // errorBuilder: (_, __, ___) => Container(
              //   color: AppColors.cardBg,
              //   child: const Center(
              //     child: Icon(Icons.person, color: AppColors.stext, size: 60),
              //   ),
              // ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // ── Side power-up buttons ─────────────────────────
        Column(
          children: [
            _PowerUp(
              icon: Icons.visibility_off_rounded,
              label: 'FREE',
              color: Colors.orange,
              isActive: false,
            ),
            const SizedBox(height: 8),
            _PowerUp(
              icon: Icons.compare_arrows_rounded,
              label: '40',
              color: AppColors.primary,
              isActive: false,
            ),
            const SizedBox(height: 8),
            _PowerUp(
              icon: Icons.check_circle_rounded,
              label: '100',
              color: AppColors.primary,
              isActive: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _PowerUp extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;

  const _PowerUp({
    required this.icon,
    required this.label,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.15) : AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? color : AppColors.divider,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
