// lib/screens/settings/widgets/settings_arrow_tile.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class SettingsArrowTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final Color? chevronColor;

  const SettingsArrowTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.chevronColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.stext, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: labelColor ?? AppColors.hText,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: chevronColor ?? AppColors.stext,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
