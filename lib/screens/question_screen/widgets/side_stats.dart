import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class SideStats extends StatelessWidget {
  const SideStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatCard(title: 'Score', value: '1500', icon: Icons.star),
        const SizedBox(height: 12),
        _StatCard(
          title: 'Streak',
          value: '5',
          icon: Icons.local_fire_department,
        ),
        const SizedBox(height: 12),
        _StatCard(title: 'Level', value: '8', icon: Icons.trending_up),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.hText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
