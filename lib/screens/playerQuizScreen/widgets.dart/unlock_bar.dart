// lib/widgets/unlock_banner.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class UnlockBanner extends StatelessWidget {
  final String message;
  final String subMessage;

  const UnlockBanner({
    super.key,
    required this.message,
    required this.subMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.stext,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_open_rounded,
                  color: AppColors.primary,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  subMessage,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.hText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
