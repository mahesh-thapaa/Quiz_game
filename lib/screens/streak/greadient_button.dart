// lib/widgets/gradient_button.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

/// A full-width button with the app's primary green gradient.
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 52,
    this.borderRadius = 50,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: Colors.white.withValues(alpha: 0.15),
            child: Center(
              child: Text(
                label,
                style:
                    textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
