// lib/screens/discover_screen/widgets/discover_widgets_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/discover/discover_models.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/common/level_grid_screen.dart';

class DiscoverWidgetsCard extends StatelessWidget {
  final DiscoverModels model;

  const DiscoverWidgetsCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // ✅ PERFORMANCE FIX: Only listen to specific fields to prevent unnecessary rebuilds
    final stars = context.select((UserProgressProvider p) => p.stars);
    final unlockedCategories = context.select((UserProgressProvider p) => p.unlockedCategories);
    final coins = context.select((UserProgressProvider p) => p.coins);

    bool isUnlocked = false;
    if (model.unlockType == UnlockType.level) {
      isUnlocked = stars >= (model.unlockValue ?? 0);
    } else if (model.unlockType == UnlockType.coins) {
      isUnlocked = unlockedCategories.contains(model.categoryId);
    } else if (model.unlockType == UnlockType.comingSoon) {
      isUnlocked = false;
    }

    return GestureDetector(
      onTap: () async {
        if (isUnlocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LevelGridScreen(
                title: model.title.toUpperCase(),
                categoryId: model.categoryId,
                firestoreName: model.firestoreName,
              ),
            ),
          );
        } else if (model.unlockType == UnlockType.coins) {
          // ── Coin Purchase Dialog ───────────────────────────
          final bool? confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: ThemeColors.of(context).cardBg,
              title: Text(
                'Unlock ${model.title}',
                style: TextStyle(color: ThemeColors.of(context).hText),
              ),
              content: Text(
                'Unlock this category for ${model.unlockValue} coins?',
                style: TextStyle(color: ThemeColors.of(context).stext),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(
                    'UNLOCK',
                    style: TextStyle(
                      color: coins >= (model.unlockValue ?? 0)
                        ? ThemeColors.of(context).primary
                        : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            final provider = context.read<UserProgressProvider>();
            final success = await provider.unlockWithCoins(
              model.categoryId,
              model.unlockValue ?? 0,
            );
            if (!context.mounted) return;

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blue,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: const Text(
                    'Category unlocked successfully!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blue,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: const Text(
                    'Not enough coins!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blueAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(milliseconds: 1500),
              content: Text(
                model.unlockType == UnlockType.comingSoon
                    ? 'Coming Soon!'
                    : model.snackbarMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ThemeColors.of(context).deepCard,
          image: DecorationImage(
            image: model.imageUrl.startsWith('http')
                ? NetworkImage(model.imageUrl)
                : AssetImage(model.imageUrl) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.1),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.20),
                    Colors.black.withValues(alpha: 0.78),
                  ],
                ),
              ),
            ),
            if (!isUnlocked)
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
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  _UnlockBadge(model: model),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnlockBadge extends StatelessWidget {
  final DiscoverModels model;

  const _UnlockBadge({required this.model});

  @override
  Widget build(BuildContext context) {
    switch (model.unlockType) {
      case UnlockType.level:
        return Text(
          model.unlockText ?? '',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        );

      case UnlockType.coins:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: ThemeColors.of(context).doller,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              model.unlockText ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        );

      case UnlockType.comingSoon:
        return const Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white54,
          ),
        );
    }
  }
}
