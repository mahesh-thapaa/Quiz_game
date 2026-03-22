// lib/models/level_overview_model.dart

class LevelOverviewModel {
  final int levelNumber;
  final String levelName;
  final int starsEarned; // 0-3
  final int totalStars; // always 3
  final String description;

  const LevelOverviewModel({
    required this.levelNumber,
    required this.levelName,
    required this.starsEarned,
    this.totalStars = 3,
    required this.description,
  });
}
