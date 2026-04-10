class LevelOverviewModel {
  final int levelNumber;
  final String levelName;
  final int totalStars;
  final int starsEarned;
  final String description;

  LevelOverviewModel({
    required this.levelNumber,
    required this.levelName,
    this.totalStars = 3,
    required this.starsEarned,
    required this.description,
  });
}
