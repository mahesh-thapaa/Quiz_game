// lib/data/home_data.dart

import 'package:quiz_game/models/home_models/home_models.dart';

class HomeData {
  static const UserModel user = UserModel(
    name: 'Sushant',
    level: 3,
    coins: 340,
    currentXP: 1250,
    maxXP: 2000,
  );

  static const DailyBonusModel dailyBonus = DailyBonusModel(
    coins: 100,
    title: 'DAILY BONUS',
    subtitle: 'Collect your free coins',
    buttonLabel: 'CLAIM REWARD',
  );

  static const List<QuizCardModel> recommendedQuizzes = [
    QuizCardModel(
      title: 'Player Challenge',
      subtitle: 'Identify the players from the given question',
      imageUrl: 'asstes/images/ronaldo.png',
    ),
    QuizCardModel(
      title: 'Logo Master',
      subtitle: 'Guess the club from its crest',
      imageUrl: 'asstes/images/logomatser.jpg',
    ),
  ];

  static const StreakModel streak = StreakModel(
    totalDays: 7,
    currentDay: 3,
    title: '7 Day Streak',
  );

  static const List<CategoryModel> categories = [
    CategoryModel(title: 'Player Quiz', imageUrl: "asstes/images/quiz.jpg"),
    CategoryModel(title: 'Club Quiz', imageUrl: 'asstes/images/club.jpg'),
    CategoryModel(title: 'Stadium Quiz', imageUrl: 'asstes/images/stadium.jpg'),
  ];
}
