import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/jersey/jersey_level_tile.dart';

class LevelTile extends StatelessWidget {
  final ProfileLevel level;
  final VoidCallback? onTap;

  const LevelTile({super.key, required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (level.hasStar) return _BonusTile(onTap: onTap);

    return GestureDetector(
      onTap: level.isUnlocked ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: level.isUnlocked ? AppColors.cardBg : AppColors.deepCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: level.isCurrent ? AppColors.primary : AppColors.divider,
            width: level.isCurrent ? 2.0 : 1.0,
          ),
          boxShadow: level.isCurrent
              ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (level.isUnlocked) ...[
              Text(
                'LVL',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: level.isCurrent ? AppColors.primary : AppColors.stext,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '${level.number ?? 0}',
                style: TextStyle(
                  fontSize: level.isCurrent ? 24 : 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.hText,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              _StarRow(filled: level.starsEarned),
            ] else ...[
              const Icon(Icons.lock_rounded, color: AppColors.stext, size: 14),
              const SizedBox(height: 4),
              Text(
                '${level.number ?? 0}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
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

class _BonusTile extends StatelessWidget {
  final VoidCallback? onTap;

  const _BonusTile({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF3B0764), Color(0xFF1E1B4B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
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
            Icon(Icons.star_rounded, color: AppColors.doller, size: 28),
          ],
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final int filled;
  const _StarRow({required this.filled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Icon(
          i < filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 11,
          color: i < filled
              ? AppColors.doller
              : AppColors.stext.withValues(alpha: 0.3),
        );
      }),
    );
  }
}
