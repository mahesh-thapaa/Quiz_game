// lib/screens/profile/widgets/profile_avatar.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/profile/leaderboardEntry_models.dart';

class ProfileAvatar extends StatelessWidget {
  final LeaderboardEntry user;

  const ProfileAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
            // White gap ring
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
              ),
            ),
            // Avatar image
            CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.cardBg,
              backgroundImage: AssetImage(user.avatarAsset),
              onBackgroundImageError: (_, __) {},
              child: null,
            ),
            // Verified badge
            if (user.isVerified)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          user.name,
          style: const TextStyle(
            color: AppColors.hText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.bio,
          style: const TextStyle(color: AppColors.stext, fontSize: 13),
        ),
      ],
    );
  }
}
