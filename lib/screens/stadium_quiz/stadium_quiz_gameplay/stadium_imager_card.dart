// lib/screens/stadium_quiz/stadium_quiz_gameplay/stadium_imager_card.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class StadiumImagerCard extends StatelessWidget {
  final String imagePath;

  const StadiumImagerCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // 1. Validation: check if the string is a valid URL to prevent "No host specified" crash
    final bool isValidUrl = Uri.tryParse(imagePath)?.hasAbsolutePath ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineBorder, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: !isValidUrl
                ? _buildPlaceholder() // Show placeholder if URL is empty or invalid
                : Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    // 2. Loading state for better UX
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    // 3. Error state if the URL is valid but the image fails to load (404, etc)
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            _PowerUp(
              icon: Icons.visibility_off_rounded,
              label: 'FREE',
              color: Colors.orange,
              isActive: false,
            ),
            const SizedBox(height: 8),
            _PowerUp(
              icon: Icons.compare_arrows_rounded,
              label: '40',
              color: AppColors.primary,
              isActive: false,
            ),
            const SizedBox(height: 8),
            _PowerUp(
              icon: Icons.check_circle_rounded,
              label: '100',
              color: AppColors.primary,
              isActive: true,
            ),
          ],
        ),
      ],
    );
  }

  // Placeholder shown when image is missing or broken
  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.cardBg,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stadium_rounded, color: AppColors.stext, size: 50),
            SizedBox(height: 8),
            Text(
              "No Image",
              style: TextStyle(color: AppColors.stext, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _PowerUp extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;

  const _PowerUp({
    required this.icon,
    required this.label,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.15) : AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? color : AppColors.divider,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
