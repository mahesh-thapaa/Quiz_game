import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/login_models/button_models.dart';

class Buttons extends StatelessWidget {
  final VoidCallback onButtonTap;

  const Buttons({super.key, required this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonModels(
          label: 'Start as Guest',
          gradient: AppColors.primaryGradient,
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 22,
          ),
          onTap: onButtonTap,
        ),
        const SizedBox(height: 14),
        ButtonModels(
          label: 'Login with Facebook',
          gradient: AppColors.primaryGradient,
          leading: const Icon(Icons.facebook, color: Colors.white, size: 24),
          onTap: onButtonTap,
        ),
      ],
    );
  }
}
