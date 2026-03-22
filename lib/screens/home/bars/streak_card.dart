// lib/widgets/home/streak_card.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/home_models/home_models.dart';

class StreakCard extends StatelessWidget {
  final StreakModel streak;

  const StreakCard({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ── Fire icon ──
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.deepCard,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🔥', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 14),

          // ── Title + progress dots ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(streak.totalDays, (i) {
                    final done = i < streak.currentDay;
                    return Expanded(
                      child: Container(
                        height: 5,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          gradient: done ? AppColors.primaryGradient : null,
                          color: done ? null : Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Day counter ──
          Text(
            'Day ${streak.currentDay}/${streak.totalDays}',
            style: const TextStyle(
              color: AppColors.stext,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
