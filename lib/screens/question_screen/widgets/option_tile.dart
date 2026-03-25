import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class OptionTile extends StatelessWidget {
  final String text;
  final int index;
  final int selectedIndex;
  final int correctIndex;

  const OptionTile({
    super.key,
    required this.text,
    required this.index,
    required this.selectedIndex,
    required this.correctIndex,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;
    bool isCorrect = index == correctIndex;
    bool showCorrect =
        isSelected || (isSelected == false && index == correctIndex);

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (showCorrect && isCorrect) {
      backgroundColor = Colors.green.shade600;
      borderColor = Colors.green.shade700;
      textColor = Colors.white;
    } else if (isSelected && !isCorrect) {
      backgroundColor = Colors.red.shade600;
      borderColor = Colors.red.shade700;
      textColor = Colors.white;
    } else {
      backgroundColor = Colors.grey.shade700;
      borderColor = Colors.grey.shade600;
      textColor = AppColors.hText;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: textColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
