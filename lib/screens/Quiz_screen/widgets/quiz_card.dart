import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/quiz_models/quiz_modsels.dart';
import 'package:quiz_game/screens/common/level_grid_screen.dart';

class QuizCard extends StatelessWidget {
  final QuizModel model;

  const QuizCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelGridScreen(
              title: model.title.toUpperCase(),
              categoryId: model.categoryId,
              firestoreName: model.firestoreName,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(model.image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.4),
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
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Text(
              model.subtitle,
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2.0,
                    color: Colors.black,
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
