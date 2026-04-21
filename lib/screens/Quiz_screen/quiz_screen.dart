// lib/screens/Quiz_screen/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/Quiz_screen/widgets/header.dart';
import 'package:quiz_game/screens/Quiz_screen/widgets/quiz_card.dart';
// import 'package:quiz_game/screens/Quiz_screen/widgets/progess_card.dart';
import 'package:quiz_game/screens/Quiz_screen/widgets/challenger_card.dart';
import 'package:quiz_game/screens/Quiz_screen/widgets/locked_section.dart';
import 'package:quiz_game/screens/discover_screen/diccover_screen.dart';
// import 'package:quiz_game/screens/jerrsy_quiz/jersey_quiz_screen.dart';
import 'package:quiz_game/screens/player_quiz/player_screen_quiz.dart';
import 'package:quiz_game/screens/jersery_quiz/jersey_quiz_screen.dart';
import 'package:quiz_game/screens/club_quiz/club_quiz_screen.dart';
import 'package:quiz_game/screens/stadium_quiz/Stadium_quiz_screen.dart';
import 'package:quiz_game/models/quiz_models/quiz_modsels.dart';
// import 'package:quiz_game/models/level_result_model.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizzes = [
      QuizModel(
        title: "Player Quiz",
        subtitle: "Guess the player",
        image: "asstes/images/ronaldo.png",
      ),
      QuizModel(
        title: "Stadium Quiz",
        subtitle: "Identify famous arenas",
        image: "asstes/images/stadium.jpg",
      ),
      QuizModel(
        title: "Jersey Quiz",
        subtitle: "Guess the team",
        image: "asstes/images/jursey.jpg",
      ),
      QuizModel(
        title: "Club Quiz",
        subtitle: "Logo challenge",
        image: "asstes/images/logomatser.jpg",
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),
              const Text(
                "Quiz Category",
                style: TextStyle(
                  color: AppColors.hText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Choose a category and test your football knowledge to climb the leaderboard.",
                style: TextStyle(color: Colors.blueGrey, fontSize: 14),
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
                  return GestureDetector(
                    onTap: () => _onQuizTap(context, quizzes[index].title),
                    child: QuizCard(model: quizzes[index]),
                  );
                },
              ),
              // const SizedBox(height: 20),
              // const ProgressCard(),
              const SizedBox(height: 20),
              const ChallengeCard(),
              const SizedBox(height: 20),
              LockedSection(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DiscoverScreen()),
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

  void _onQuizTap(BuildContext context, String title) {
    final navigator = Navigator.of(context);

    switch (title) {
      case "Player Quiz":
        navigator.push(
          MaterialPageRoute(builder: (_) => const PlayerScreenQuiz()),
        );
        break;

      case "Stadium Quiz":
        navigator.push(
          MaterialPageRoute(builder: (_) => const StadiumQuizScreen()),
        );
        break;

      case "Jersey Quiz":
        // navigator.push(
        //   MaterialPageRoute(
        //     builder: (_) => JerseyQuizScreen(
        //       onQuizComplete: (int score, int total) {
        //         navigator.pushReplacement(
        //           MaterialPageRoute(
        //             builder: (_) => LevelCompletedScreen(
        //               result: LevelResultModel.fromScore(
        //                 score: score,
        //                 totalQuestions: total,
        //                 xpEarned: 50,
        //                 coinsEarned: 20,
        //               ),
        //               onNextLevel: () =>
        //                   navigator.popUntil((route) => route.isFirst),
        //               onReplay: () => navigator.pushReplacement(
        //                 MaterialPageRoute(
        //                   builder: (_) =>
        //                       JerseyQuizScreen(onQuizComplete: (s, t) {}),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JerseyQuizScreen()),
        );
        break;

      case "Club Quiz":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClubQuizScreen()),
        );
        break;
    }
  }
}
