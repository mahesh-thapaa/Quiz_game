// lib/screens/home/bars/quiz_card.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/home_models/home_models.dart';

class QuizCard extends StatelessWidget {
  final QuizCardModel quiz;
  final VoidCallback onTap;

  const QuizCard({super.key, required this.quiz, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // ── Local Asset Image ──
            Positioned.fill(
              child: Image.asset(
                quiz.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.cardBg,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.stext,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

            // ── Dark gradient overlay ──
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // ── Text ──
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20, // Reduced from 22
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 4.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quiz.subtitle,
                    style: const TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 4.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
