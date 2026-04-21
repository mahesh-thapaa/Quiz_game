import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/profile/edit_profile/profile_avatar.dart';

class HomeAppBar extends StatelessWidget {
  final bool showCoins;

  const HomeAppBar({super.key, this.showCoins = true});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();

    return Row(
      children: [
        const ProfileAvatar(radius: 22),
        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GoalIQ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              p.username.isNotEmpty ? p.username : 'Welcome!',
              style: const TextStyle(color: AppColors.stext, fontSize: 12),
            ),
          ],
        ),
        const Spacer(),

        _Badge(label: 'LVL ${p.level}'),
        const SizedBox(width: 8),
        _CoinsBadge(coins: p.coins),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CoinsBadge extends StatelessWidget {
  final int coins;
  const _CoinsBadge({required this.coins});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, anim) =>
          ScaleTransition(scale: anim, child: child),
      child: Container(
        key: ValueKey(coins),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Text('🪙', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '$coins',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
