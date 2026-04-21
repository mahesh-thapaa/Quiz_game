class JerseyLevelTile {
  final int? number;
  final bool hasStar;
  bool isCurrent;
  bool isUnlocked;
  int starsEarned;

  JerseyLevelTile({
    this.number,
    this.hasStar = false,
    this.isCurrent = false,
    this.isUnlocked = false,
    this.starsEarned = 0,
  });
}
