import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';

class XPProgressBar extends StatelessWidget {
  const XPProgressBar({super.key});

  String _format(int n) => n >= 1000
      ? '${(n / 1000).toStringAsFixed(0)},${(n % 1000).toString().padLeft(3, '0')}'
      : n.toString();

  @override
  Widget build(BuildContext context) {
    // ✅ watches provider — no need to pass currentXP/maxXP as params anymore
    final p = context.watch<UserProgressProvider>();
    final progress = p.xpProgress;

    return Column(
      children: [
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
              '${_format(p.currentLevelXP)} / ${_format(p.maxLevelXP)}',
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
