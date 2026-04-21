import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "GoalIQ",
              style: TextStyle(
                color: AppColors.hText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // ✅ FIXED: was hardcoded "Sushant" — now reads from provider
            Text(
              p.username.isNotEmpty ? p.username : 'Welcome!',
              style: const TextStyle(color: AppColors.stext),
            ),
          ],
        ),
        Row(
          children: [
            _badge("LVL ${p.level}"),
            const SizedBox(width: 8),
            _coinBadge("${p.coins}"),
          ],
        ),
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.deepCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.hText)),
    );
  }

  Widget _coinBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.deepCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: AppColors.hText)),
        ],
      ),
    );
  }
}
