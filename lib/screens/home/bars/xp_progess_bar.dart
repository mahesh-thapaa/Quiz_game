// lib/widgets/home/xp_progress_bar.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class XPProgressBar extends StatelessWidget {
  final int currentXP;
  final int maxXP;

  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.maxXP,
  });

  String _format(int n) => n >= 1000
      ? '${(n / 1000).toStringAsFixed(0)},${(n % 1000).toString().padLeft(3, '0')}'
      : n.toString();

  @override
  Widget build(BuildContext context) {
    final progress = (currentXP / maxXP).clamp(0.0, 1.0);

    return Column(
      children: [
        // ── Labels ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'XP TO NEXT LEVEL',
              style: TextStyle(
                color: AppColors.stext,
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_format(currentXP)} / ${_format(maxXP)}',
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
