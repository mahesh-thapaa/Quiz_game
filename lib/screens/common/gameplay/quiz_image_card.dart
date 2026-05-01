import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class QuizImageCard extends StatelessWidget {
  final String imageUrl;

  const QuizImageCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineBorder, width: 2),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 16, spreadRadius: 2),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: imageUrl.startsWith('http')
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _errorPlaceholder(),
            )
          : Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _errorPlaceholder(),
            ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      color: AppColors.cardBg,
      child: const Center(
        child: Icon(Icons.person, color: AppColors.stext, size: 60),
      ),
    );
  }
}

class PowerUp extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final bool showBadge;
  final VoidCallback? onTap;

  const PowerUp({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.isActive,
    this.showBadge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2230),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 22),
                if (showBadge)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
