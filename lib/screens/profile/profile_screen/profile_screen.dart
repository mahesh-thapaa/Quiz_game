// lib/screens/profile/profile_screen/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/profile/leaderboardEntry_models.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/provider/leaderBoard_provider.dart';
import 'package:quiz_game/provider/profile_image_provider.dart';
import 'package:quiz_game/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:quiz_game/screens/profile/edit_profile/profile_avatar.dart';
import 'package:quiz_game/screens/profile/seetings/settings_screen.dart';
import 'package:quiz_game/screens/profile/edit_profile/global_standing.dart';
import 'package:quiz_game/screens/profile/profile_screen/leaderboard_row.dart';
import 'package:quiz_game/auth/email_signup.dart';

import 'package:quiz_game/screens/profile/profile_screen/stat_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().listenLeaderboard();
      // Load avatar on screen entry
      context.read<ProfileImageProvider>().loadAvatar();
    });
  }

  Future<void> _handleLogoutPressed() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(color: AppColors.hText, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.stext),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.stext),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _isLoggingOut = true);

    try {
      // Clear user data
      debugPrint('🔄 Clearing user data...');
      context.read<UserProgressProvider>().clearData();
      context.read<ProfileImageProvider>().clear();
      debugPrint('✅ User data cleared');

      // Sign out from Firebase with timeout
      debugPrint('🔄 Signing out from Firebase...');
      await FirebaseAuth.instance.signOut().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('⚠️ Firebase signOut timeout - continuing anyway');
        },
      );
      debugPrint('✅ Firebase sign out done');

      // Small delay to ensure signout completes
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        debugPrint('🔄 Navigating to login...');
        // Replace all screens and go to login
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const EmailSignup(showBackButton: false),
          ),
          (route) => false,
        );
        debugPrint('✅ Navigation complete');
      }
    } catch (e) {
      debugPrint('❌ Logout error: $e');
      if (mounted) {
        setState(() => _isLoggingOut = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();
    final lb = context.watch<LeaderboardProvider>();
    final top3 = lb.top3;
    final currentUserRank = lb.currentUserRank;

    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    final currentUserEntry = LeaderboardEntry(
      username: p.username.isNotEmpty ? p.username : 'You',
      name: p.username.isNotEmpty ? p.username : 'You',
      xpPoints: p.xp,
      weeklyXP: p.xp,
      isCurrentUser: true,
      level: p.level,
      coins: p.coins,
      bio: p.bio,
      rank: currentUserRank,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // ── Settings ────────────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.stext,
                    size: 24,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: 8),

              // ── Avatar ──────────────────────────────────────────────────
              ProfileAvatar(
                radius: 52,
                showCameraIcon: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                ),
              ),
              const SizedBox(height: 12),

              // ── Username ────────────────────────────────────────────────
              Text(
                p.username.isNotEmpty ? p.username : 'Player',
                style: const TextStyle(
                  color: AppColors.hText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // ── Bio ─────────────────────────────────────────────────────
              if (p.bio.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  p.bio,
                  style: const TextStyle(color: AppColors.stext, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),

              // ── Edit Profile ────────────────────────────────────────────
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Stats ───────────────────────────────────────────────────
              Row(
                children: [
                  StatCard(
                    label: 'RANK',
                    value: lb.isLoading ? '...' : '#$currentUserRank',
                    valueColor: AppColors.hText,
                  ),
                  const SizedBox(width: 10),
                  StatCard(
                    label: 'LEVEL',
                    value: '${p.level}',
                    valueColor: Colors.amber,
                  ),
                  const SizedBox(width: 10),
                  StatCard(
                    label: 'COINS',
                    value: '${p.coins}',
                    valueColor: Colors.amber,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Leaderboard ─────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Leaderboard',
                            style: TextStyle(
                              color: AppColors.hText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Weekly Rankings',
                            style: TextStyle(
                              color: Colors.green.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
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
                    if (lb.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else ...[
                      ...List.generate(
                        top3.length,
                        (i) => LeaderboardRow(
                          entry: top3[i],
                          rank: i + 1,
                          isCurrentUser: top3[i].isCurrentUser,
                        ),
                      ),
                      // Show current user separately only if NOT in top 3
                      if (!top3.any((e) => e.isCurrentUser))
                        LeaderboardRow(
                          entry: currentUserEntry,
                          rank: currentUserRank,
                          isCurrentUser: true,
                        ),
                    ],
                    const Divider(color: Colors.white10, height: 1),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GlobalStandings(allUsers: lb.allUsers),
                        ),
                      ),
                      child: const Text(
                        'VIEW GLOBAL STANDINGS',
                        style: TextStyle(
                          color: AppColors.stext,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Auth Button (Sign In or Logout) ─────────────────────────
              if (isGuest)
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmailSignup(showBackButton: true),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ElevatedButton(
                  onPressed: _isLoggingOut ? null : _handleLogoutPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    disabledBackgroundColor: Colors.red.shade800.withOpacity(
                      0.6,
                    ),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoggingOut
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
