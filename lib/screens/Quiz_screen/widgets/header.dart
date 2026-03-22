import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
// import '../models/colors.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("GoalIQ",
                style: TextStyle(
                    color: AppColors.hText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text("Sushant",
                style: TextStyle(color: AppColors.stext)),
          ],
        ),
        Row(
          children: [
            _badge("LVL 3"),
            const SizedBox(width: 8),
            _badge("200"),
          ],
        )
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.deepCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.hText)),
    );
  }
}