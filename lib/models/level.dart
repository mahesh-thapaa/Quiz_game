// lib/models/level.dart

class Level {
  final int number;
  final bool isUnlocked;
  final bool hasStar;
  final bool isCurrent;
  final int starsEarned; // 👈 added
  final String name; // 👈 added

  const Level({
    required this.number,
    this.isUnlocked = false,
    this.hasStar = false,
    this.isCurrent = false,
    this.starsEarned = 0,
    this.name = '',
  });
}
