import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/club/level_overview_model.dart';

class LevelOverviewSheet extends StatelessWidget {
  final LevelOverviewModel model;
  final VoidCallback? onPlay;

  const LevelOverviewSheet({super.key, required this.model, this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          24,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Level Title
              Text(
                'Level ${model.levelNumber}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.hText,
                ),
              ),
              const SizedBox(height: 8),

              // Level Name
              Text(
                model.levelName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.stext,
                ),
              ),
              const SizedBox(height: 20),

              // Stars Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    const Text(
                      'STARS EARNED',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.stext,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.star_rounded,
                            size: 32,
                            color: index < model.starsEarned
                                ? AppColors.doller
                                : AppColors.stext.withValues(alpha: 0.2),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${model.starsEarned}/${model.totalStars}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.stext,
                      ),
                    ),
                  ],
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
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'PLAY',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: AppColors.divider),
                  ),
                  child: const Text(
                    'CLOSE',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.stext,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showLevelOverview({
  required BuildContext context,
  required LevelOverviewModel model,
  VoidCallback? onPlay,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) => LevelOverviewSheet(model: model, onPlay: onPlay),
  );
}
