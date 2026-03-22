// lib/models/level_model.dart

enum LevelStatus {
  completed, // done — shows number + stars earned
  current, // active — highlighted green border
  locked, // not yet unlocked
  star, // special star milestone cell
  empty, // blank spacer cell
}

class LevelModel {
  final int? number; // null for star/empty cells
  final LevelStatus status;
  final int starsEarned; // 0-3
  final bool isSpecialStar; // big gold star milestone

  const LevelModel({
    this.number,
    required this.status,
    this.starsEarned = 0,
    this.isSpecialStar = false,
  });
}
