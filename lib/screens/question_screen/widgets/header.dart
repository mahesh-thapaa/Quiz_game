import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.hText),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          'Quiz Game',
          style: TextStyle(
            color: AppColors.hText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: AppColors.hText),
          onPressed: () {},
        ),
      ],
    );
  }
}
