import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/quiz_models/locked_category_models.dart';

class LockedSection extends StatelessWidget {
  const LockedSection({super.key});

  static final List<LockedCategoryModel> _items = [
    LockedCategoryModel(
      title: 'Legends Quiz',
      unlockText: 'Level 5 Required',
      imagePath: 'asstes/images/legend.jpg',
      requiresCoins: false,
      snackbarMessage: 'Level 5 to unlock Legends Quiz!',
      snackbarColor: Colors.blue,
    ),
    LockedCategoryModel(
      title: 'National',
      unlockText: '1000 Coins',
      imagePath: 'asstes/images/national.jpg',
      requiresCoins: true,
      snackbarMessage: 'You need 1000 Coins to unlock National!',
      snackbarColor: Colors.blue,
    ),
    LockedCategoryModel(
      title: 'Manager Quiz',
      unlockText: 'Level 7 Required',
      imagePath: 'asstes/images/manager.jpg',
      requiresCoins: false,
      snackbarMessage: 'Reach Level 8 to unlock Manager Quiz!',
      snackbarColor: Colors.blue,
    ),
    LockedCategoryModel(
      title: 'Transfer Quiz',
      unlockText: '5000 Coins',
      imagePath: 'asstes/images/transfer.png',
      requiresCoins: true,
      snackbarMessage: 'You need 500 Coins to unlock Transfer Quiz!',
      snackbarColor: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ─────────────────────────────────────────────
        Row(
          children: [
            Icon(Icons.lock, color: AppColors.dShade, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Locked Categories',
              style: TextStyle(
                color: AppColors.hText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Grid ───────────────────────────────────────────────
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) => _LockedCard(item: _items[index]),
        ),
      ],
    );
  }
}

// ── Single card ───────────────────────────────────────────────
class _LockedCard extends StatelessWidget {
  final LockedCategoryModel item;

  const _LockedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: item.snackbarColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                // Icon(
                //   item.requiresCoins ? Icons.monetization_on : Icons.lock,
                //   color: Colors.white,
                // ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.snackbarMessage,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(.5),
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.deepCard),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),

            // ── Lock icon top right ───────────────────────────
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

            // ── Bottom label ──────────────────────────────────
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 2.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  item.requiresCoins
                      ? _CoinBadge(text: item.unlockText)
                      : Text(
                          item.unlockText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Coin badge ────────────────────────────────────────────────
class _CoinBadge extends StatelessWidget {
  final String text;

  const _CoinBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
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
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 2.0,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
