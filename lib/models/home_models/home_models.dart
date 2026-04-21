// lib/models/home_models.dart

class UserModel {
  final String name;
  final int level;
  final int coins;
  final int currentXP;
  final int maxXP;

  const UserModel({
    required this.name,
    required this.level,
    required this.coins,
    required this.currentXP,
    required this.maxXP,
  });
}

class DailyBonusModel {
  final int coins;
  final String title;
  final String subtitle;
  final String buttonLabel;

  const DailyBonusModel({
    this.coins = 100,
    this.title = 'DAILY BONUS',
    this.subtitle = 'Collect your free coins',
    this.buttonLabel = 'CLAIM REWARD',
  });
}

class QuizCardModel {
  final String title;
  final String subtitle;
  final String imageUrl;

  const QuizCardModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class CategoryModel {
  final String title;
  final String imageUrl;

  const CategoryModel({required this.title, required this.imageUrl});
}
