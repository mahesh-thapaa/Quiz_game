// lib/screens/profile/widgets/profile_leaderboard.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/profile/leaderboardEntry_models.dart';

class ProfileLeaderboard extends StatelessWidget {
  final List<LeaderboardEntry> entries;

  const ProfileLeaderboard({super.key, required this.entries});

  /// Reorder entries so that the current user appears first if they have higher XP in top 3
  List<LeaderboardEntry> _reorderForCurrentUser(
    List<LeaderboardEntry> entries,
  ) {
    if (entries.isEmpty) return entries;

    // Find the current user
    final currentUserIndex = entries.indexWhere((e) => e.isCurrentUser);

    // If no current user found, return entries as is
    if (currentUserIndex == -1) {
      return entries;
    }

    final currentUser = entries[currentUserIndex];

    // If current user is already first, return as is
    if (currentUserIndex == 0) {
      return entries;
    }

    // If current user has higher XP than the first person, move them to first
    if (currentUser.xpPoints > entries[0].xpPoints) {
      final reordered = [...entries];
      reordered.removeAt(currentUserIndex);
      reordered.insert(0, currentUser);
      return reordered;
    }

    // Otherwise, return original order
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    // Reorder entries to show current user first if they're in top 3
    final orderedEntries = _reorderForCurrentUser(entries);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                const Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: AppColors.hText,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  'Weekly Rankings',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                SizedBox(width: 44, child: Text('RANK', style: _headerStyle)),
                const SizedBox(width: 44),
                Expanded(child: Text('PLAYER', style: _headerStyle)),
                Text('XP POINTS', style: _headerStyle),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Entries - with visual rank based on position
          ...orderedEntries.asMap().entries.map((entry) {
            final visualRank = entry.key + 1;
            return _LeaderboardRow(entry: entry.value, visualRank: visualRank);
          }),

          // View Global Standings
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              'VIEW GLOBAL STANDINGS',
              style: TextStyle(
                color: AppColors.stext,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _headerStyle => const TextStyle(
    color: AppColors.stext,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final int visualRank;

  const _LeaderboardRow({required this.entry, required this.visualRank});

  @override
  Widget build(BuildContext context) {
    final isTop3 = visualRank <= 3;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppColors.primary.withOpacity(0.08)
            : AppColors.deepCard,
        borderRadius: BorderRadius.circular(10),
        border: entry.isCurrentUser
            ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Rank badge
          SizedBox(
            width: 28,
            child: isTop3
                ? _RankBadge(rank: visualRank)
                : Text(
                    '#$visualRank',
                    style: TextStyle(
                      color: entry.isCurrentUser
                          ? AppColors.primary
                          : AppColors.stext,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: _avatarColor(visualRank),
            child: Text(
              entry.username[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Username
          Expanded(
            child: Text(
              entry.username,
              style: TextStyle(
                color: entry.isCurrentUser
                    ? AppColors.primary
                    : AppColors.hText,
                fontSize: 13,
                fontWeight: entry.isCurrentUser
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),

          // XP
          Text(
            _formatXP(entry.xpPoints),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _formatXP(int xp) {
    if (xp >= 1000) {
      final s = xp.toString();
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return '$xp';
  }

  Color _avatarColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFF94A3B8);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.primary;
    }
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    final colors = {
      1: const Color(0xFFFFD700),
      2: const Color(0xFF94A3B8),
      3: const Color(0xFFCD7F32),
    };
    final color = colors[rank] ?? AppColors.stext;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      alignment: Alignment.center,
      child: Text(
        '$rank',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
