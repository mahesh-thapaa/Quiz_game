import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/profile/profile_models.dart';
import 'package:quiz_game/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:quiz_game/screens/profile/widgets/profile_avatar.dart';
import 'package:quiz_game/screens/profile/widgets/profile_stats_row.dart';
import 'package:quiz_game/screens/profile/widgets/profile_leaderboard.dart';
import 'package:quiz_game/screens/profile/widgets/logout_button.dart';
import 'package:quiz_game/screens/profile/seetings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final LeaderboardEntry user;
  final List<LeaderboardEntry> leaderboard;

  const ProfileScreen({
    super.key,
    this.user = LeaderboardEntry.user,
    this.leaderboard = LeaderboardEntry.leaderboard,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name;
  late String _bio;
  late String _avatarAsset;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
    _avatarAsset = widget.user.avatarAsset;
  }

  @override
  Widget build(BuildContext context) {
    final updatedUser = widget.user.copyWith(
      name: _name,
      bio: _bio,
      avatarAsset: _avatarAsset,
    );

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
              ProfileAvatar(user: updatedUser), // ✅ uses updated user
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                        initialName: _name,
                        initialBio: _bio,
                        avatarAsset: _avatarAsset,
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      _name = result['name'] ?? _name;
                      _bio = result['bio'] ?? _bio;
                      _avatarAsset = result['avatarAsset'] ?? _avatarAsset;
                    });
                  }
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
              ProfileStatsRow(user: updatedUser),
              const SizedBox(height: 20),
              ProfileLeaderboard(entries: widget.leaderboard),
              const SizedBox(height: 20),
              LogoutButton(onTap: () {}),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
