import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final bool showCameraIcon;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.radius = 24,
    this.showCameraIcon = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();
    final hasImage = p.avatarPath.isNotEmpty;
    final letter = p.username.isNotEmpty ? p.username[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Avatar circle ──────────────────────────────────────────────────
          CircleAvatar(
            radius: radius,
            backgroundColor: AppColors.deepCard,
            backgroundImage: hasImage ? FileImage(File(p.avatarPath)) : null,
            child: !hasImage
                ? Text(
                    letter,
                    style: TextStyle(
                      color: AppColors.hText,
                      fontSize: radius * 0.7,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),

          // ── Camera badge (shown only when showCameraIcon = true) ───────────
          if (showCameraIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: radius * 0.65,
                  height: radius * 0.65,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: radius * 0.35,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
