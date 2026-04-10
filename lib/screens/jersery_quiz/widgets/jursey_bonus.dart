import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 50),
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

            Icon(
              isUnlocked ? Icons.star_rounded : Icons.lock_rounded,
              color: isUnlocked ? AppColors.doller : AppColors.stext,
              size: 52,
            ),
            const SizedBox(height: 20),

            Text(
              isUnlocked
                  ? 'Test your knowledge on football players.\nGet double XP and Coin.'
                  : 'Complete Level $unlockAtLevel to unlock\nthis Bonus Level.', // ✅ dynamic level number
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.stext,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

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
