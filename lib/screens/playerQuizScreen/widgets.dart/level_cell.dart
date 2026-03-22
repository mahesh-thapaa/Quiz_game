// lib/widgets/level_cell.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
// import 'package:quiz_game/models/level_model.dart';
import 'package:quiz_game/models/level_models.dart';

class LevelCell extends StatelessWidget {
  final LevelModel level;
  final VoidCallback? onTap;

  const LevelCell({super.key, required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    switch (level.status) {
      case LevelStatus.empty:
        return const SizedBox.shrink();

      case LevelStatus.star:
        return _StarCell();

      case LevelStatus.current:
        return _CurrentCell(level: level, onTap: onTap);

      case LevelStatus.completed:
        return _CompletedCell(level: level, onTap: onTap);

      case LevelStatus.locked:
        return _LockedCell(level: level, onTap: onTap);
    }
  }
}

// ── Current level cell (green border) ─────────────────────────
class _CurrentCell extends StatelessWidget {
  final LevelModel level;
  final VoidCallback? onTap;

  const _CurrentCell({required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 10, spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${level.number}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.hText,
              ),
            ),
            const SizedBox(height: 4),
            _StarRow(count: level.starsEarned),
          ],
        ),
      ),
    );
  }
}

// ── Completed level cell ──────────────────────────────────────
class _CompletedCell extends StatelessWidget {
  final LevelModel level;
  final VoidCallback? onTap;

  const _CompletedCell({required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${level.number}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.hText,
              ),
            ),
            const SizedBox(height: 4),
            _StarRow(count: level.starsEarned),
          ],
        ),
      ),
    );
  }
}

// ── Locked level cell ─────────────────────────────────────────
class _LockedCell extends StatelessWidget {
  final LevelModel level;
  final VoidCallback? onTap;

  const _LockedCell({required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lock icon
          const Icon(Icons.lock_rounded, color: AppColors.stext, size: 14),
          const SizedBox(height: 4),
          Text(
            '${level.number}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.stext,
            ),
          ),
          const SizedBox(height: 4),
          _StarRow(count: 0, locked: true),
        ],
      ),
    );
  }
}

// ── Special star milestone cell ───────────────────────────────
class _StarCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dShade.withValues(alpha: 0.4)),
      ),
      child: const Center(
        child: Icon(Icons.star_rounded, color: AppColors.doller, size: 30),
      ),
    );
  }
}

// ── Star row (3 small stars) ──────────────────────────────────
class _StarRow extends StatelessWidget {
  final int count;
  final bool locked;

  const _StarRow({required this.count, this.locked = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final filled = i < count;
        return Icon(
          Icons.star_rounded,
          size: 10,
          color: locked
              ? AppColors.divider
              : filled
              ? AppColors.doller
              : AppColors.stext.withValues(alpha: 0.3),
        );
      }),
    );
  }
}
