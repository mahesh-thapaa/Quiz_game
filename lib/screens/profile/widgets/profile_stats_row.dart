// lib/screens/profile/widgets/profile_stats_row.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/profile/leaderboardEntry_models.dart';

class ProfileStatsRow extends StatelessWidget {
  final LeaderboardEntry user;

  const ProfileStatsRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCell(
          label: 'RANK',
          value: '#${_formatNumber(user.rank)}',
          valueColor: AppColors.hText,
        ),
        _Divider(),
        _StatCell(
          label: 'LEVEL',
          value: '${user.level}',
          valueColor: AppColors.dShade,
        ),
        _Divider(),
        _StatCell(
          label: 'COINS',
          value: '${user.coins}',
          valueColor: AppColors.doller,
        ),
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000)
      return '${(n / 1000).toStringAsFixed(1)}K'.replaceAll('.0K', 'K');
    return '$n';
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCell({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.stext,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox(width: 8);
}
