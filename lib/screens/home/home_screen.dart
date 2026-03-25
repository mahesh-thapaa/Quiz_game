import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/home_models/home_models.dart';
import 'package:quiz_game/data/home_data.dart';
import 'package:quiz_game/screens/home/bars/home_app_bar.dart';
import 'package:quiz_game/screens/home/bars/xp_progess_bar.dart';
import 'package:quiz_game/screens/home/bars/dailly_bonus_card.dart';
import 'package:quiz_game/screens/home/bars/quick_play_card.dart';
import 'package:quiz_game/screens/home/bars/quiz_card.dart';
import 'package:quiz_game/screens/home/bars/streak_card.dart';
import 'package:quiz_game/screens/home/bars/category_card.dart';
import 'package:quiz_game/screens/home/bars/section_header.dart';
import 'package:quiz_game/screens/bonus/clain_reward_dialog.dart';

// ── Quiz screen imports ──────────────────────────────────────────
import 'package:quiz_game/screens/player_quiz/player_screen_quiz.dart';
import 'package:quiz_game/screens/club_quiz/club_quiz_screen.dart';
import 'package:quiz_game/screens/stadium_quiz/Stadium_quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  final DailyBonusModel dailyBonus;
  final List<QuizCardModel> recommendedQuizzes;
  final StreakModel streak;
  final List<CategoryModel> categories;
  final bool showRewardOnLoad;

  const HomeScreen({
    super.key,
    this.user = HomeData.user,
    this.dailyBonus = HomeData.dailyBonus,
    this.recommendedQuizzes = HomeData.recommendedQuizzes,
    this.streak = HomeData.streak,
    this.categories = HomeData.categories,
    this.showRewardOnLoad = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.showRewardOnLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _goToBonus();
      });
    }
  }

  void _goToBonus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClaimRewardDialog(
          title: 'CONGRATULATIONS!',
          subtitle: 'REWARD CLAIMED SUCCESSFULLY',
          coins: widget.dailyBonus.coins,
          buttonLabel: 'AWESOME',
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // ── Category navigation ────────────────────────────────────────
  void _onCategoryTap(CategoryModel category) {
    switch (category.title) {
      case 'Player Quiz':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlayerScreenQuiz()),
        );
        break;
      case 'Club Quiz':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClubQuizScreen()),
        );
        break;
      case 'Stadium Quiz':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StadiumQuizScreen()),
        );
        break;
    }
  }

  // ── Recommended quiz navigation ────────────────────────────────
  void _onRecommendedQuizTap(QuizCardModel quiz) {
    switch (quiz.title) {
      case 'Player Challenge':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlayerScreenQuiz()),
        );
        break;
      case 'Logo Master':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClubQuizScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              HomeAppBar(user: widget.user),

              const SizedBox(height: 16),

              XPProgressBar(
                currentXP: widget.user.currentXP,
                maxXP: widget.user.maxXP,
              ),

              const SizedBox(height: 20),

              DailyBonusCard(bonus: widget.dailyBonus, onClaim: _goToBonus),

              const SizedBox(height: 16),

              QuickPlayCard(onTap: () {}),

              const SizedBox(height: 24),

              const SectionHeader(title: 'RECOMMENDED FOR YOU'),
              const SizedBox(height: 12),

              // ── Recommended quizzes with navigation ─────────────
              Row(
                children: widget.recommendedQuizzes.map((q) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: QuizCard(
                        quiz: q,
                        onTap: () => _onRecommendedQuizTap(q), // ✅
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              StreakCard(streak: widget.streak),

              const SizedBox(height: 24),

              const SectionHeader(title: 'POPULAR CATEGORIES'),
              const SizedBox(height: 12),

              // ── Categories with navigation ───────────────────────
              Row(
                children: widget.categories.map((c) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CategoryCard(
                        category: c,
                        onTap: () => _onCategoryTap(c), // ✅
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
