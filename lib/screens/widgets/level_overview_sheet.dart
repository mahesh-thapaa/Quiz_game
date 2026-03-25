// lib/screens/level_overview/level_overview_dialog.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/club/level_overview_model.dart';

/// Call this function to show the level overview dialog.
/// Matches the screenshot: centered dialog with pill badge,
/// title, stars, description, and 3D green PLAY button.
void showLevelOverview({
  required BuildContext context,
  required LevelOverviewModel model,
  required VoidCallback onPlay,
}) {
  showDialog(
    context: context,
    barrierColor: AppColors.background.withValues(alpha: 0.75),
    builder: (_) => _LevelOverviewDialog(model: model, onPlay: onPlay),
  );
}

class _LevelOverviewDialog extends StatelessWidget {
  final LevelOverviewModel model;
  final VoidCallback onPlay;

  const _LevelOverviewDialog({required this.model, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        decoration: BoxDecoration(
          color: AppColors.background, // 🔥 Dark navy
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LEVEL OVERVIEW pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1ED760),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "LEVEL OVERVIEW",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.background,
                    ),
                  ),
                ),

                // Close
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // 🔹 Level Text
            Text(
              "LEVEL ${model.levelNumber}:",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 4),

            Text(
              model.levelName.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.hText,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(model.totalStars, (i) {
                return Icon(
                  i < model.starsEarned ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 28,
                );
              }),
            ),

            const SizedBox(height: 16),

            // 🔹 Description
            Text(
              model.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 PLAY BUTTON (Exact green style)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPlay();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "PLAY",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: AppColors.background,
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
