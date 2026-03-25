// lib/screens/edit_profile/widgets/edit_field.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String? hint;

  const EditField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final c = ThemeColors.of(context);
    final isMultiline = maxLines > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            color: c.stext,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        // Input
        Container(
          decoration: BoxDecoration(
            color: c.cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.divider),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(color: c.hText, fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: c.stext),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: isMultiline ? 14 : 0,
              ),
              border: InputBorder.none,
              isDense: !isMultiline,
            ),
          ),
        ),
      ],
    );
  }
}
