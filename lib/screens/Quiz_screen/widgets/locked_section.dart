// lib/widgets/locked_section.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class LockedCategoryModel {
  final String title;
  final String unlockText;
  final String imagePath;
  final bool requiresCoins;

  const LockedCategoryModel({
    required this.title,
    required this.unlockText,
    required this.imagePath,
    this.requiresCoins = false,
  });
}

class LockedSection extends StatelessWidget {
  const LockedSection({super.key});

  static const List<LockedCategoryModel> _items = [
    LockedCategoryModel(
      title: 'Legends Quiz',
      unlockText: 'Level 5 Required',
      imagePath: 'asstes/images/legend.jpg',
      requiresCoins: false,
    ),
    LockedCategoryModel(
      title: 'National',
      unlockText: '1000 Coins',
      imagePath: 'asstes/images/national.jpg',
      requiresCoins: true,
    ),
    LockedCategoryModel(
      title: 'Manager Quiz',
      unlockText: 'Level 8 Required',
      imagePath: 'asstes/images/manager.jpg',
      requiresCoins: false,
    ),
    LockedCategoryModel(
      title: 'Transfer Quiz',
      unlockText: '500 Coins',
      imagePath: 'asstes/images/transfer.png',
      requiresCoins: true,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background image ──────────────────────────────
          Image.asset(
            item.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.deepCard),
          ),

          // ── Dark gradient overlay ─────────────────────────
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
                        color: Colors.black54,
                        blurRadius: 4,
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
                        ),
                      ),
              ],
            ),
          ),
        ],
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
          ),
        ),
      ],
    );
  }
}
