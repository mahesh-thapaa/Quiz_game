import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class ButtonModels extends StatelessWidget {
  final String label;
  final Widget? leading;
  final Widget? trailing;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const ButtonModels({
    Key? key,
    required this.label,
    required this.gradient,
    required this.onTap,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28,
                child: Center(child: leading ?? const SizedBox.shrink()),
              ),

              const SizedBox(width: 8),

              Text(
                label,
                style: const TextStyle(
                  color: AppColors.hText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(width: 8),

              SizedBox(
                width: 28,
                child: Center(child: trailing ?? const SizedBox.shrink()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
