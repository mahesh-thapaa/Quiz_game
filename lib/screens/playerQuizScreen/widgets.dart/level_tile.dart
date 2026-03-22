// lib/screens/playerQuizScreen/widgets.dart/level_tile.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/level.dart';
// import 'package:quiz_game/screens/playerQuizScreen/widgets.dart/level_overview_model.dart';

class LevelTile extends StatelessWidget {
  final Level level;
  final VoidCallback? onTap; // 👈 added

  const LevelTile({super.key, required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (level.hasStar) return _BonusTile();

    return GestureDetector(
      onTap: level.isUnlocked ? onTap : null, // 👈 only tappable if unlocked
      child: Container(
        decoration: BoxDecoration(
          color: level.isUnlocked ? AppColors.cardBg : AppColors.deepCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: level.isCurrent ? AppColors.primary : AppColors.divider,
            width: level.isCurrent ? 2.5 : 1,
          ),
          boxShadow: level.isCurrent
              ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (level.isUnlocked) ...[
              const Text(
                'LVL',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.stext,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '${level.number}',
                style: TextStyle(
                  fontSize: level.isCurrent ? 24 : 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.hText,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              _StarRow(filled: level.starsEarned),
            ] else ...[
              const Icon(Icons.lock_rounded, color: AppColors.stext, size: 16),
              const SizedBox(height: 2),
              Text(
                '${level.number}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.stext,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Bonus star tile ───────────────────────────────────────────
class _BonusTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B0764), Color(0xFF1E1B4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF7C3AED).withValues(alpha: 0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'BONUS',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: Color(0xFFA78BFA),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 2),
          Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 28),
        ],
      ),
    );
  }
}

// ── 3-star row ────────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final int filled;
  const _StarRow({required this.filled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Icon(
          Icons.star_rounded,
          size: 11,
          color: i < filled
              ? const Color(0xFFFFD700)
              : AppColors.stext.withValues(alpha: 0.25),
        );
      }),
    );
  }
}
