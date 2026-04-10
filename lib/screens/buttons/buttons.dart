import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/login_models/button_models.dart';

class Buttons extends StatelessWidget {
  final VoidCallback onGuestTap;
  final VoidCallback onEmailTap;

  const Buttons({
    super.key,
    required this.onGuestTap,
    required this.onEmailTap,
  });

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
          onTap: onGuestTap,
        ),
        const SizedBox(height: 14),
        ButtonModels(
          label: 'Login with Email',
          gradient: AppColors.primaryGradient,
          leading: const Icon(
            Icons.email_outlined,
            color: Colors.white,
            size: 22,
          ),
          onTap: onEmailTap,
        ),
      ],
    );
  }
}
