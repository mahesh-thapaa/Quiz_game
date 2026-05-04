import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();
    final themeColors = ThemeColors.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "GoalIQ",
              style: TextStyle(
                color: themeColors.hText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              p.username.isNotEmpty ? p.username : 'Welcome!',
              style: TextStyle(color: themeColors.stext),
            ),
          ],
        ),
        Row(
          children: [
            _xpBadge(themeColors, "${p.xp}"),
            const SizedBox(width: 8),
            _starBadge(themeColors, "${p.stars}"),
            const SizedBox(width: 8),
            _coinBadge(themeColors, "${p.coins}"),
          ],
        ),
      ],
    );
  }

  Widget _xpBadge(ThemeColors themeColors, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: themeColors.deepCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "XP",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(color: themeColors.hText)),
        ],
      ),
    );
  }

  Widget _starBadge(ThemeColors themeColors, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: themeColors.deepCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.doller, size: 18),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(color: themeColors.hText)),
        ],
      ),
    );
  }

  Widget _coinBadge(ThemeColors themeColors, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: themeColors.deepCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: AppColors.doller,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: themeColors.hText)),
        ],
      ),
    );
  }
}
