import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/discover/discover_models.dart';
import 'package:quiz_game/screens/common/level_grid_screen.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';

class LockedSection extends StatelessWidget {
  const LockedSection({super.key});

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

        // ── Firestore Grid ─────────────────────────────────────
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('quizzes')
              .where('isDiscover', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final docs = snapshot.data?.docs ?? [];

            // Filter out the core quizzes that are always visible (not in locked section)
            // Or only show those with specific unlock requirements
            final List<DiscoverModels> items = docs
                .map(
                  (doc) => DiscoverModels.fromFirestore(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ),
                )
                .where(
                  (item) =>
                      item.unlockValue != null &&
                      item.unlockValue! > 0 &&
                      item.title != 'Player Quiz' &&
                      item.title != 'Stadium Quiz' &&
                      item.title != 'Jersey Quiz' &&
                      item.title != 'Logo Master',
                )
                .toList();

            // ── CUSTOM SORTING ──────────────────────────────────
            // Order: Legends Quiz, National Quiz, Manager Quiz, Transfer Quiz
            final List<String> desiredOrder = [
              'legend', // Should match "Legend Quiz" or "Legends Quiz"
              'national',
              'manager',
              'transfer',
            ];

            items.sort((a, b) {
              final titleA = a.title.toLowerCase();
              final titleB = b.title.toLowerCase();

              int indexA = desiredOrder.indexWhere(
                (key) => titleA.contains(key),
              );
              int indexB = desiredOrder.indexWhere(
                (key) => titleB.contains(key),
              );

              if (indexA == -1) indexA = 999;
              if (indexB == -1) indexB = 999;

              return indexA.compareTo(indexB);
            });

            if (items.isEmpty) {
              return const SizedBox.shrink();
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) => _LockedCard(item: items[index]),
            );
          },
        ),
      ],
    );
  }
}

// ── Single card ───────────────────────────────────────────────
class _LockedCard extends StatelessWidget {
  final DiscoverModels item;

  const _LockedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();
    final bool requiresCoins = item.unlockType == UnlockType.coins;
    final int unlockValue = item.unlockValue ?? 0;

    final bool isUnlocked = p.isCategoryUnlocked(
      item.categoryId,
      requiresCoins,
      unlockValue,
    );

    return GestureDetector(
      onTap: () async {
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
        } else if (requiresCoins) {
          // ── Coin Purchase Dialog ───────────────────────────
          final bool? confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.cardBg,
              title: Text(
                'Unlock ${item.title}',
                style: const TextStyle(color: Colors.white),
              ),
              content: Text(
                'Unlock this category for $unlockValue coins?',
                style: const TextStyle(color: AppColors.stext),
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
                      color: p.coins >= unlockValue
                          ? AppColors.primary
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            final success = await p.unlockWithCoins(
              item.categoryId,
              unlockValue,
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
            item.imageUrl.startsWith('http')
                ? Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    opacity: AlwaysStoppedAnimation(isUnlocked ? 1.0 : 0.4),
                    errorBuilder: (_, _, _) =>
                        Container(color: AppColors.deepCard),
                  )
                : Image.asset(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    opacity: AlwaysStoppedAnimation(isUnlocked ? 1.0 : 0.4),
                    errorBuilder: (_, _, _) =>
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
                  requiresCoins
                      ? _CoinBadge(text: item.unlockText ?? '')
                      : Text(
                          item.unlockText ?? '',
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
