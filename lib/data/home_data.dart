import 'package:quiz_game/models/home_models/home_models.dart';

class HomeData {
  static const DailyBonusModel bonus = DailyBonusModel(
    coins: 50,
    title: 'DAILY BONUS',
    subtitle: 'Collect your free coins',
  );

  static const List<QuizCardModel> recommendedQuizzes = [
    QuizCardModel(
      title: 'Player Challenge',
      subtitle: 'Identify the players',
      imageUrl: 'assets/images/ronaldo.png',
      categoryId: 'player_quiz',
      firestoreName: 'Player Quiz',
    ),
    QuizCardModel(
      title: 'Logo Master',
      subtitle: 'Guess the club from its crest',
      imageUrl: 'assets/images/stadium.jpg',
      categoryId: 'logo_master',
      firestoreName: 'Logo Master',
    ),
  ];

  static const List<CategoryModel> categories = [
    CategoryModel(title: 'Player Quiz', imageUrl: "assets/images/quiz.jpg"),
    CategoryModel(title: 'Stadium Quiz', imageUrl: 'assets/images/stadium.jpg'),
    CategoryModel(title: 'Club Quiz', imageUrl: 'assets/images/club.jpg'),
    // CategoryModel(title: 'National Quiz', imageUrl: 'assets/images/quiz.jpg'),
  ];
}
