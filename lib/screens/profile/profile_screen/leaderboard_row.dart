import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/profile/leaderboardEntry_models.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/profile/edit_profile/profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final bool isCurrentUser;

  const LeaderboardRow({
    super.key,
    required this.entry,
    required this.rank,
    required this.isCurrentUser,
  });

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFF9E9E9E);
      case 3:
        return const Color(0xFFFF7043);
      case 4:
        return Colors.green.shade600;
      default:
        return Colors.transparent;
    }
  }

  String _formatXP(int xp) {
    return xp.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();
    final themeColors = ThemeColors.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = isCurrentUser && (user == null || user.isAnonymous);

    return Container(
      color: isCurrentUser
          ? AppColors.primary.withValues(alpha: 0.08)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // ── Rank / Unranked ─────────────────────────────────────────────────
          if (isGuest)
            SizedBox(
              width: 28,
              child: Text(
                '-',
                style: TextStyle(
                  color: themeColors.stext,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            Container(
              width: rank > 4 ? 32 : 28,
              height: 28,
              decoration: BoxDecoration(
                color: _rankColor(rank),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                rank > 4 ? '#$rank' : '$rank',
                style: TextStyle(
                  color: rank > 4 ? themeColors.stext : Colors.white,
                  fontSize: rank > 4 ? 11 : 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 12),

          // ── Avatar ───────────────────────────────────────────────────────
          isCurrentUser
              ? const ProfileAvatar(radius: 18)
              : CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.deepCard,
                  backgroundImage: entry.avatarUrl.isNotEmpty
                      ? NetworkImage(entry.avatarUrl)
                      : null,
                  child: entry.avatarUrl.isEmpty
                      ? Text(
                          entry.name.isNotEmpty
                              ? entry.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: AppColors.hText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
          const SizedBox(width: 10),

          // ── Name & Subtitle ──────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGuest
                      ? 'Guest (You)'
                      : (isCurrentUser
                          ? '${p.username.isNotEmpty ? p.username : 'You'} (You)'
                          : entry.name),
                  style: TextStyle(
                    color: isCurrentUser
                        ? Colors.green
                        : themeColors.hText,
                    fontSize: 14,
                    fontWeight:
                        isCurrentUser ? FontWeight.bold : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (isGuest)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Unranked',
                      style: TextStyle(
                        color: themeColors.stext,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── XP / Action Message ──────────────────────────────────────────
          if (isGuest)
            Text(
              'Sign in to join leaderboard',
              style: TextStyle(
                color: Colors.green.shade400,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Text(
              _formatXP(isCurrentUser ? p.xp : entry.xpPoints),
              style: TextStyle(
                color: Colors.green.shade400,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
