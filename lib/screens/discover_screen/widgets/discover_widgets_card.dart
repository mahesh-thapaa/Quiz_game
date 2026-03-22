// lib/widgets/discover_widgets_card.dart

import 'package:flutter/material.dart';
// import 'package:quiz_game/models/discover_models.dart';

import 'package:quiz_game/models/discover/discover_models.dart';
// ✅ correct import
import 'package:quiz_game/models/colors.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeModel model;

  const ChallengeCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background image ────────────────────────────
          Image.asset(
            model.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.deepCard),
          ),

          // ── Dark gradient overlay ───────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.20),
                  Colors.black.withValues(alpha: 0.78),
                ],
              ),
            ),
          ),

          // ── Extra dim for coming soon ───────────────────
          if (model.unlockType == UnlockType.comingSoon)
            Container(color: Colors.black.withValues(alpha: 0.25)),

          // ── Lock icon top right ─────────────────────────
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.white70,
                size: 15,
              ),
            ),
          ),

          // ── Bottom content ──────────────────────────────
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                _UnlockBadge(model: model),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Unlock badge ──────────────────────────────────────────────
class _UnlockBadge extends StatelessWidget {
  final ChallengeModel model;

  const _UnlockBadge({required this.model});

  @override
  Widget build(BuildContext context) {
    switch (model.unlockType) {
      case UnlockType.level:
        return Text(
          model.unlockText ?? '',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        );

      case UnlockType.coins:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.doller,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              model.unlockText ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        );

      case UnlockType.comingSoon:
        return const Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white54,
          ),
        );
    }
  }
}
