import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/level_overview_model.dart';

class LevelOverviewSheet extends StatelessWidget {
  final LevelOverviewModel model;
  final VoidCallback? onPlay;

  const LevelOverviewSheet({super.key, required this.model, this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Header Row — centered pill, close button top right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✅ Invisible spacer same size as close button to center the pill
                const SizedBox(width: 28),

                // ✅ Centered LEVEL OVERVIEW pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    'LEVEL OVERVIEW',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // ✅ Close button on the right
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.stext,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              model.levelName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.hText,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),

            // Stars Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                model.totalStars,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.star_rounded,
                    color: index < model.starsEarned
                        ? AppColors.doller
                        : AppColors.deepCard,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            Text(
              model.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.stext,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),

            // Play Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPlay?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'PLAY',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showLevelOverview({
  required BuildContext context,
  required LevelOverviewModel model,
  required VoidCallback onPlay,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    barrierDismissible: true,
    builder: (context) => LevelOverviewSheet(model: model, onPlay: onPlay),
  );
}

class PlayerBonus extends StatelessWidget {
  final VoidCallback? onPlay;
  final bool isUnlocked;
  final int unlockAtLevel;

  const PlayerBonus({
    super.key,
    this.onPlay,
    this.isUnlocked = false,
    this.unlockAtLevel = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Top Row — centered pill, close button top right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✅ Invisible spacer to balance close button
                const SizedBox(width: 28),

                // ✅ Centered LEVEL OVERVIEW pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    'LEVEL OVERVIEW',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // ✅ Close button on the right
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.stext,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'BONUS LEVEL',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.hText,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),

            // Star or Lock icon
            Icon(
              isUnlocked ? Icons.star_rounded : Icons.lock_rounded,
              color: isUnlocked ? AppColors.doller : AppColors.stext,
              size: 52,
            ),
            const SizedBox(height: 20),

            // Description
            Text(
              isUnlocked
                  ? 'Test your knowledge on football players.\nGet double XP and Coin.'
                  : 'Complete Level $unlockAtLevel to unlock\nthis Bonus Level.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.stext,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

            // Not available banner
            if (!isUnlocked)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.4),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.orange,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Not available yet',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

            // Play / Locked Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isUnlocked
                    ? () {
                        Navigator.pop(context);
                        onPlay?.call();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUnlocked
                      ? AppColors.primary
                      : AppColors.deepCard,
                  disabledBackgroundColor: AppColors.deepCard,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isUnlocked ? 'PLAY' : 'LOCKED',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isUnlocked ? Colors.white : AppColors.stext,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showBonusLevelSheet({
  required BuildContext context,
  VoidCallback? onPlay,
  bool isUnlocked = false,
  int unlockAtLevel = 5,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    barrierDismissible: true,
    builder: (context) => PlayerBonus(
      onPlay: onPlay,
      isUnlocked: isUnlocked,
      unlockAtLevel: unlockAtLevel,
    ),
  );
}
