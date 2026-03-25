import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/question_screen/widgets/progress_bar.dart';
import 'package:quiz_game/screens/question_screen/widgets/player_card.dart';
// import 'package:quiz_game/screens/question_screen.dart/option_tile.dart';
import 'package:quiz_game/screens/question_screen/widgets/side_stats.dart';
import 'package:quiz_game/screens/question_screen/widgets/header.dart';
import 'package:quiz_game/screens/question_screen/widgets/option_tile.dart';

class QuestionModel {
  final String image;
  final String question;
  final List<String> options;
  final int correctIndex;
  final int? selectedIndex;

  QuestionModel({
    required this.image,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.selectedIndex,
  });
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final question = QuestionModel(
      image: "assets/player.jpg",
      question: "WHO IS THIS PLAYER?",
      options: [
        "Tom Brady",
        "Cristiano Ronaldo",
        "Patrick Mahomes",
        "Aaron Rodgers",
      ],
      correctIndex: 1,
      selectedIndex: 1,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: 20),

              const ProgressBar(progress: 0.6),

              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: PlayerCard(image: question.image)),
                  const SizedBox(width: 12),
                  const SideStats(),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                question.question,
                style: const TextStyle(
                  color: AppColors.hText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ...List.generate(
                question.options.length,
                (index) => OptionTile(
                  text: question.options[index],
                  index: index,
                  selectedIndex: question.selectedIndex ?? 0,
                  correctIndex: question.correctIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
