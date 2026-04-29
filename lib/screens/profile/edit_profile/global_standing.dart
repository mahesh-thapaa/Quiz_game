import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/profile/leaderboardEntry_models.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/profile/edit_profile/profile_avatar.dart';

class GlobalStandings extends StatelessWidget {
  final List<LeaderboardEntry> allUsers;

  const GlobalStandings({super.key, required this.allUsers});

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFF9E9E9E);
      case 3:
        return const Color(0xFFFF7043);
      default:
        return AppColors.deepCard;
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.hText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Global Standings',
          style: TextStyle(
            color: AppColors.hText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Column headers ────────────────────────────────────────────────
          Container(
            color: AppColors.cardBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: const [
                SizedBox(
                  width: 48,
                  child: Text(
                    'RANK',
                    style: TextStyle(
                      color: AppColors.stext,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'PLAYER',
                    style: TextStyle(
                      color: AppColors.stext,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  'XP POINTS',
                  style: TextStyle(
                    color: AppColors.stext,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),

          // ── All users list ────────────────────────────────────────────────
          Expanded(
            child: allUsers.isEmpty
                ? const Center(
                    child: Text(
                      'No players yet',
                      style: TextStyle(color: AppColors.stext),
                    ),
                  )
                : ListView.separated(
                    itemCount: allUsers.length,
                    separatorBuilder: (_, _) =>
                        const Divider(color: Colors.white10, height: 1),
                    itemBuilder: (ctx, i) {
                      final entry = allUsers[i];
                      final isMe = entry.isCurrentUser;

                      return Container(
                        color: isMe
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            // ── Rank circle ───────────────────────────────
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: _rankColor(entry.rank),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${entry.rank}',
                                style: TextStyle(
                                  color: entry.rank <= 3
                                      ? Colors.white
                                      : AppColors.stext,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // ── Avatar ────────────────────────────────────
                            isMe
                                ? ProfileAvatar(radius: 16)
                                : CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.deepCard,
                                    child: Text(
                                      entry.name.isNotEmpty
                                          ? entry.name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: AppColors.hText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: 10),

                            // ── Name ──────────────────────────────────────
                            Expanded(
                              child: Text(
                                isMe
                                    ? '${p.username.isNotEmpty ? p.username : 'You'} (You)'
                                    : (entry.name.isNotEmpty
                                          ? entry.name
                                          : 'Player'),
                                style: TextStyle(
                                  color: isMe ? Colors.green : AppColors.hText,
                                  fontSize: 14,
                                  fontWeight: isMe
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // ── XP ────────────────────────────────────────
                            Text(
                              _formatXP(isMe ? p.xp : entry.xpPoints),
                              style: TextStyle(
                                color: Colors.green.shade400,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
