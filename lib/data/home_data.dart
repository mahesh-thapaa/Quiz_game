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
      imageUrl: 'asstes/images/ronaldo.png',
      categoryId: 'player_quiz',
      firestoreName: 'Player Quiz',
    ),
    QuizCardModel(
      title: 'Logo Master',
      subtitle: 'Guess the club from its crest',
      imageUrl: 'asstes/images/stadium.jpg',
      categoryId: 'logo_master',
      firestoreName: 'Logo Master',
    ),
  ];

  static const List<CategoryModel> categories = [
    CategoryModel(title: 'Player Quiz', imageUrl: "asstes/images/quiz.jpg"),
    CategoryModel(title: 'Stadium Quiz', imageUrl: 'asstes/images/stadium.jpg'),
    CategoryModel(title: 'Club Quiz', imageUrl: 'asstes/images/club.jpg'),
    // CategoryModel(title: 'National Quiz', imageUrl: 'asstes/images/quiz.jpg'),
  ];
}
