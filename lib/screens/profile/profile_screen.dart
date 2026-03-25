// lib/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/profile/profile_models.dart';
import 'package:quiz_game/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:quiz_game/screens/profile/widgets/profile_avatar.dart';
import 'package:quiz_game/screens/profile/widgets/profile_stats_row.dart';
import 'package:quiz_game/screens/profile/widgets/profile_leaderboard.dart';
import 'package:quiz_game/screens/profile/widgets/facebook_signin_button.dart';
import 'package:quiz_game/screens/profile/seetings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileModel user;
  final List<LeaderboardEntry> leaderboard;

  const ProfileScreen({
    super.key,
    this.user = ProfileData.user,
    this.leaderboard = ProfileData.leaderboard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
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
              ProfileAvatar(user: user),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return EditProfileScreen(
                          initialName: user.name,
                          initialBio: user.bio,
                          avatarAsset: user.avatarAsset,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
              const SizedBox(height: 16),
              ProfileStatsRow(user: user),
              const SizedBox(height: 20),
              ProfileLeaderboard(entries: leaderboard),
              const SizedBox(height: 20),
              FacebookSignInButton(onTap: () {}),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
