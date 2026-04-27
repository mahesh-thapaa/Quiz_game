import 'package:quiz_game/models/home_models/home_models.dart';
import 'package:quiz_game/models/streak_models.dart';

class HomeData {
  static const DailyBonusModel bonus = DailyBonusModel(
    coins: 100,
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
      categoryId: 'club_quiz',
      firestoreName: 'Club Quiz',
    ),
  ];

  static const List<CategoryModel> categories = [
    CategoryModel(title: 'Player Quiz', imageUrl: "asstes/images/quiz.jpg"),
    CategoryModel(title: 'Club Quiz', imageUrl: 'asstes/images/club.jpg'),
    CategoryModel(title: 'Stadium Quiz', imageUrl: 'asstes/images/stadium.jpg'),
  ];
}
