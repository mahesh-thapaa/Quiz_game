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
          color: ThemeColors.of(context).cardBg,
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
              child: Icon(
                Icons.play_arrow,
                color: ThemeColors.of(context).background,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Play',
                    style: TextStyle(
                      color: ThemeColors.of(context).hText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Jump into a random challenge',
                    style: TextStyle(color: ThemeColors.of(context).stext, fontSize: 12),
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right, color: ThemeColors.of(context).stext),
          ],
        ),
      ),
    );
  }
}
