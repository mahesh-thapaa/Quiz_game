// lib/screens/profile/widgets/facebook_signin_button.dart

import 'package:flutter/material.dart';

class FacebookSignInButton extends StatelessWidget {
  final VoidCallback onTap;

  const FacebookSignInButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF1877F2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1877F2).withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.facebook, color: Colors.white, size: 22),
            SizedBox(width: 10),
            Text(
              'Sign in with Facebook',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
