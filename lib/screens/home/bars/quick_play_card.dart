// lib/widgets/home/quick_play_card.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class QuickPlayCard extends StatelessWidget {
  final VoidCallback onTap;

  const QuickPlayCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 50,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: AppColors.background,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Play',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Jump into a random challenge',
                    style: TextStyle(color: AppColors.stext, fontSize: 12),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: AppColors.stext),
          ],
        ),
      ),
    );
  }
}
