// lib/widgets/level_overview_sheet.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/level_overview_model.dart';

// ── Show helper ───────────────────────────────────────────────
// Call this from anywhere: showLevelOverview(context, model, onPlay)
void showLevelOverview({
  required BuildContext context,
  required LevelOverviewModel model,
  required VoidCallback onPlay,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (_) => LevelOverviewDialog(model: model, onPlay: onPlay),
  );
}

// ── Dialog widget ─────────────────────────────────────────────
class LevelOverviewDialog extends StatelessWidget {
  final LevelOverviewModel model;
  final VoidCallback onPlay;

  const LevelOverviewDialog({
    super.key,
    required this.model,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: _DialogContent(model: model, onPlay: onPlay),
    );
  }
}

// ── Dialog content ────────────────────────────────────────────
class _DialogContent extends StatelessWidget {
  final LevelOverviewModel model;
  final VoidCallback onPlay;

  const _DialogContent({required this.model, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1E2D),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Close + badge row ─────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              // LEVEL OVERVIEW badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary),
                ),
                child: const Text(
                  'LEVEL OVERVIEW',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              // Close button
              Positioned(
                right: 0,
                child: GestureDetector(
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
                      color: AppColors.stext,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Level title ───────────────────────────────
          Text(
            'LEVEL ${model.levelNumber}:\n${model.levelName.toUpperCase()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.hText,
              height: 1.2,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 16),

          // ── Stars ─────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(model.totalStars, (i) {
              final filled = i < model.starsEarned;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.star_rounded,
                  size: 36,
                  color: filled
                      ? AppColors.doller
                      : AppColors.stext.withValues(alpha: 0.3),
                ),
              );
            }),
          ),

          const SizedBox(height: 18),

          // ── Description ───────────────────────────────
          Text(
            model.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.stext,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 28),

          // ── Play button ───────────────────────────────
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onPlay();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'PLAY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
