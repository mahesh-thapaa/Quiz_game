// lib/screens/edit_profile/widgets/edit_avatar.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class EditAvatar extends StatelessWidget {
  final String avatarAsset;
  final VoidCallback onChangeTap;

  const EditAvatar({
    super.key,
    required this.avatarAsset,
    required this.onChangeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Avatar circle
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.cardBg,
              backgroundImage: AssetImage(avatarAsset),
              onBackgroundImageError: (_, __) {},
            ),
            // Camera badge
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: onChangeTap,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onChangeTap,
          child: const Text(
            'Change Photo',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
