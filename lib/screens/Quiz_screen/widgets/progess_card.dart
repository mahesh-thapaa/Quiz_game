import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  String _nextUnlock(int level) {
    switch (level) {
      case 1:
        return 'Legends Quiz';
      case 2:
        return 'Champions Mode';
      case 3:
        return 'World Cup Quiz';
      case 4:
        return 'Ultimate Challenge';
      default:
        return 'Max Unlocked 🏆';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.progess,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Progress to Next \nUnlock",
                style: TextStyle(
                  color: AppColors.hText,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'LVL ${p.level}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blueGrey,
                size: 14,
              ),
              Text(
                'LVL ${p.level + 1}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(p.xpProgress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: p.xpProgress,
                  minHeight: 10,
                  backgroundColor: Colors.grey,
                  color: AppColors.dShade,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${p.currentLevelXP} / ${p.maxLevelXP} XP',
            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "Next unlock:   ",
                style: TextStyle(
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey,
                ),
              ),
              Text(
                _nextUnlock(p.level),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
