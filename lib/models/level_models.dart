enum LevelStatus { completed, current, locked, star, empty }

class LevelModel {
  final int? number;
  final LevelStatus status;
  final int starsEarned;
  final bool isSpecialStar;

  const LevelModel({
    this.number,
    required this.status,
    this.starsEarned = 0,
    this.isSpecialStar = false,
  });
}
