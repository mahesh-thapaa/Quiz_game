import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/club_question_model.dart';
import 'club_quiz_gameplay_screen.dart';

class ClubLevelCompleteScreen extends StatelessWidget {
  final ClubQuizResult result;

  const ClubLevelCompleteScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LEVEL COMPLETE 🎉",
              style: TextStyle(
                color: AppColors.hText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Score: ${result.score}/${result.totalQuestions}",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClubQuizGameplayScreen(),
                  ),
                );
              },
              child: const Text("Replay"),
            ),
          ],
        ),
      ),
    );
  }
}
