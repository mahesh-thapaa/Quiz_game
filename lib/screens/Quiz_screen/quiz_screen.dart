// lib/screens/Quiz_screen/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/Quiz_screen/widgets/header.dart';
import 'package:quiz_game/screens/Quiz_screen/widgets/quiz_card.dart';
import 'package:quiz_game/screens/Quiz_screen/widgets/challenger_card.dart';
import 'package:quiz_game/screens/Quiz_screen/widgets/locked_section.dart';
import 'package:quiz_game/screens/discover_screen/diccover_screen.dart';
import 'package:quiz_game/models/quiz_models/quiz_modsels.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizzes = [
      QuizModel(
        title: "Player Quiz",
        subtitle: "Guess the player",
        image: "assets/images/ronaldo.png",
        categoryId: 'player_quiz',
        firestoreName: 'Player Quiz',
      ),
      QuizModel(
        title: "Stadium Quiz",
        subtitle: "Identify famous arenas",
        image: "assets/images/stadium.jpg",
        categoryId: 'stadium_quiz',
        firestoreName: 'Stadium Quiz',
      ),
      QuizModel(
        title: "Jersey Quiz",
        subtitle: "Guess the team",
        image: "assets/images/jursey.jpg",
        categoryId: 'jersey_quiz',
        firestoreName: 'Jersey Quiz',
      ),
      QuizModel(
        title: "Logo Master",
        subtitle: "Logo challenge",
        image: "assets/images/logomatser.jpg",
        categoryId: 'logo_master',
        firestoreName: 'Logo Master',
      ),
    ];

    final themeColors = ThemeColors.of(context);
    return Scaffold(
      backgroundColor: themeColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),
              Text(
                "Quiz Category",
                style: TextStyle(
                  color: themeColors.hText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Choose a category and test your football knowledge to climb the leaderboard.",
                style: TextStyle(color: themeColors.stext, fontSize: 14),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quizzes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return QuizCard(model: quizzes[index]);
                },
              ),
              const SizedBox(height: 20),
              const ChallengeCard(),
              const SizedBox(height: 20),
              const LockedSection(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DiscoverScreen()),
                ),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.explore_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Discover More Challenges",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
