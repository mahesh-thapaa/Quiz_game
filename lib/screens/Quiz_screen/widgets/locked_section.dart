import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/quiz_models/locked_category_models.dart';
import 'package:quiz_game/screens/common/level_grid_screen.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:provider/provider.dart';

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
      categoryId: 'legends_quiz',
      firestoreName: 'Legend Quiz',
      unlockValue: 5,
    ),
    LockedCategoryModel(
      title: 'National',
      unlockText: '1000 Coins',
      imagePath: 'asstes/images/national.jpg',
      requiresCoins: true,
      snackbarMessage: 'You need 1000 Coins to unlock National!',
      snackbarColor: Colors.blue,
      categoryId: 'national_quiz',
      firestoreName: 'National QUiz',
      unlockValue: 1000,
    ),
    LockedCategoryModel(
      title: 'Manager Quiz',
      unlockText: 'Level 7 Required',
      imagePath: 'asstes/images/manager.jpg',
      requiresCoins: false,
      snackbarMessage: 'Reach Level 8 to unlock Manager Quiz!',
      snackbarColor: Colors.blue,
      categoryId: 'manager_quiz',
      firestoreName: 'Manager Quiz',
      unlockValue: 7,
    ),
    LockedCategoryModel(
      title: 'Transfer Quiz',
      unlockText: '5000 Coins',
      imagePath: 'asstes/images/transfer.png',
      requiresCoins: true,
      snackbarMessage: 'You need 500 Coins to unlock Transfer Quiz!',
      snackbarColor: Colors.blue,
      categoryId: 'transfer_quiz',
      firestoreName: 'Transfer Quiz',
      unlockValue: 5000,
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
    final p = context.watch<UserProgressProvider>();
    final bool isUnlocked = item.requiresCoins
        ? p.coins >= item.unlockValue
        : p.level >= item.unlockValue;

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LevelGridScreen(
                title: item.title.toUpperCase(),
                categoryId: item.categoryId,
                firestoreName: item.firestoreName,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: item.snackbarColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(milliseconds: 1500),
              content: Text(
                item.snackbarMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(isUnlocked ? 1.0 : 0.4),
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

            if (!isUnlocked)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
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
