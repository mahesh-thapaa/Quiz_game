import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/home/bars/home_app_bar.dart';
import 'package:quiz_game/screens/home/bars/xp_progess_bar.dart';
import 'package:quiz_game/screens/home/bars/dailly_bonus_card.dart';
import 'package:quiz_game/screens/home/bars/quick_play_card.dart';
import 'package:quiz_game/screens/home/bars/quiz_card.dart';
import 'package:quiz_game/screens/home/bars/streak_card.dart';
import 'package:quiz_game/screens/home/bars/category_card.dart';
import 'package:quiz_game/screens/home/bars/section_header.dart';
import 'package:quiz_game/models/home_models/home_models.dart';
import 'package:quiz_game/screens/common/level_grid_screen.dart';
import 'package:quiz_game/data/home_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onCategoryTap(CategoryModel category) {
    String categoryId = '';
    String firestoreName = '';

    if (category.title == 'Player Quiz') {
      categoryId = 'player_quiz';
      firestoreName = 'Player Quiz';
    } else if (category.title == 'Stadium Quiz') {
      categoryId = 'stadium_quiz';
      firestoreName = 'Stadium Quiz';
    } else if (category.title == 'Club Quiz') {
      categoryId = 'club_quiz';
      firestoreName = 'Club Quiz';
    }

    if (categoryId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LevelGridScreen(
            title: category.title.toUpperCase(),
            categoryId: categoryId,
            firestoreName: firestoreName,
          ),
        ),
      );
    }
  }

  void _onRecommendedQuizTap(QuizCardModel quiz) {
    String displayTitle = quiz.title;

    // Change 'Player Challenge' to 'Player Quiz' only for the next screen
    if (displayTitle == 'Player Challenge') {
      displayTitle = 'Player Quiz';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelGridScreen(
          title: displayTitle.toUpperCase(),
          categoryId: quiz.categoryId,
          firestoreName: quiz.firestoreName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. App Bar (Profile + Level + Coins)
              const HomeAppBar(),
              const SizedBox(height: 20),

              // 2. XP Progress Bar
              const XPProgressBar(),
              const SizedBox(height: 25),

              // 3. Daily Bonus Card
              const DailyBonusCard(bonus: HomeData.bonus),
              const SizedBox(height: 20),

              // 4. Quick Play Card
              QuickPlayCard(
                onTap: () {
                  // Navigate to a "Random" quiz (Player Quiz as default)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelGridScreen(
                        title: 'PLAYER QUIZ',
                        categoryId: 'player_quiz',
                        firestoreName: 'Player Quiz',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              // 5. Recommended Section Header
              const SectionHeader(title: 'RECOMMENDED FOR YOU'),
              const SizedBox(height: 15),

              // 6. Recommended Grid (2 Columns)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: HomeData.recommendedQuizzes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final quiz = HomeData.recommendedQuizzes[index];
                  return QuizCard(
                    quiz: quiz,
                    onTap: () => _onRecommendedQuizTap(quiz),
                  );
                },
              ),
              const SizedBox(height: 30),

              // 7. Streak Card
              const StreakCard(triggerLoginOnInit: true),
              const SizedBox(height: 35),

              // 8. Popular Categories Header
              const SectionHeader(title: 'POPULAR CATEGORIES'),
              const SizedBox(height: 15),

              // 9. Popular Categories Row (Full Width)
              Row(
                children: HomeData.categories.map((category) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CategoryCard(
                        category: category,
                        onTap: () => _onCategoryTap(category),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
