import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/quiz_level_tile.dart';

class LevelTile extends StatelessWidget {
  final QuizLevelTile level;
  final VoidCallback? onTap;

  const LevelTile({super.key, required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeColors.of(context);
    if (level.hasStar) return _BonusTile(level: level, onTap: onTap);

    return GestureDetector(
      onTap: level.isUnlocked ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: level.isUnlocked ? themeColors.cardBg : themeColors.deepCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: level.isCurrent ? AppColors.primary : themeColors.divider,
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
                  color: level.isCurrent ? AppColors.primary : themeColors.stext,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '${level.number ?? 0}',
                style: TextStyle(
                  fontSize: level.isCurrent ? 24 : 20,
                  fontWeight: FontWeight.w900,
                  color: themeColors.hText,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              _StarRow(filled: level.starsEarned),
            ] else ...[
              Icon(Icons.lock_rounded, color: themeColors.stext, size: 14),
              const SizedBox(height: 4),
              Text(
                '${level.number ?? 0}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: themeColors.stext,
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
  final QuizLevelTile level;
  final VoidCallback? onTap;

  const _BonusTile({required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = level.starsEarned > 0;

    return GestureDetector(
      onTap: level.isUnlocked ? onTap : null,
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
        child: isCompleted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'BONUS',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFA78BFA),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Display earned stars (0-3)
                  _StarRow(filled: level.starsEarned),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'BONUS',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFA78BFA),
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.doller,
                        size: 28,
                      ),
                    ],
                  ),
                  // Lock icon overlay if not unlocked
                  if (!level.isUnlocked)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B0764).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.lock_rounded,
                          color: ThemeColors.of(context).stext,
                          size: 12,
                        ),
                      ),
                    ),
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
    final themeColors = ThemeColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Icon(
          Icons.star_rounded,
          size: 11,
          color: i < filled
              ? AppColors.doller
              : themeColors.stext.withValues(alpha: 0.3),
        );
      }),
    );
  }
}
