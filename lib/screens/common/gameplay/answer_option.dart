import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

enum AnswerState { idle, selected, correct, wrong }

class AnswerOption extends StatelessWidget {
  final String label;
  final String text;
  final AnswerState state;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.label,
    required this.text,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeColors.of(context);
    Color borderColor = Colors.transparent;

    if (state == AnswerState.selected) {
      borderColor = AppColors.primary;
    } else if (state == AnswerState.correct) {
      borderColor = Colors.green;
    } else if (state == AnswerState.wrong) {
      borderColor = Colors.red;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: themeColors.deepCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: themeColors.divider,
              child: Text(label),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: TextStyle(color: themeColors.hText)),
            ),
          ],
        ),
      ),
    );
  }
}
