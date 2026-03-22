import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/quiz_category/quiz_models.dart';
// import '../models/colors.dart';
// import '../models/quiz_model.dart';

class QuizCard extends StatelessWidget {
  final QuizModel model;

  const QuizCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(model.image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.2),
            BlendMode.darken,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            model.title,
            style: const TextStyle(
              color: AppColors.hText,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            model.subtitle,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
