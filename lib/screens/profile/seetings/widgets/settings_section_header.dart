// lib/screens/settings/widgets/settings_section_header.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final Color? color;

  const SettingsSectionHeader({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: color ?? AppColors.stext,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
