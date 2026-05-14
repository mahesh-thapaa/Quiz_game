import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';

class QuizTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final String title;

  const QuizTopBar({super.key, required this.onBack, this.title = 'QUIZ'});

  @override
  Widget build(BuildContext context) {
    // ✅ reads live values from provider — no need to pass stars/coins as params
    final themeColors = ThemeColors.of(context);
    final p = context.watch<UserProgressProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 12, 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: themeColors.hText,
              size: 28,
            ),
            onPressed: onBack,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOALIQ',
                style: TextStyle(
                  color: themeColors.stext,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: themeColors.hText,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          _XPBadge(xp: p.xp),
          const SizedBox(width: 8),
          _StarsBadge(stars: p.stars),
          const SizedBox(width: 8),
          _CoinsBadge(coins: p.coins),
        ],
      ),
    );
  }
}

class _XPBadge extends StatelessWidget {
  final int xp;
  const _XPBadge({required this.xp});

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: themeColors.cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'XP',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '$xp',
            style: TextStyle(
              color: themeColors.hText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarsBadge extends StatelessWidget {
  final int stars;
  const _StarsBadge({required this.stars});

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: themeColors.cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.doller, size: 18),
          const SizedBox(width: 5),
          Text(
            '$stars',
            style: TextStyle(
              color: themeColors.hText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinsBadge extends StatelessWidget {
  final int coins;
  const _CoinsBadge({required this.coins});

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeColors.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, anim) =>
          ScaleTransition(scale: anim, child: child),
      child: Container(
        key: ValueKey(coins),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: themeColors.cardBg,
          borderRadius: BorderRadius.circular(20),
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
            Text(
              '$coins',
              style: TextStyle(
                color: themeColors.hText,
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
