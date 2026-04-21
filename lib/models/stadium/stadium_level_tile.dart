class StadiumLevelTile {
  final int? number;
  int starsEarned;
  bool isUnlocked;
  bool isCurrent;
  final bool hasStar;

  StadiumLevelTile({
    this.number,
    this.starsEarned = 0,
    this.isUnlocked = false,
    this.isCurrent = false,
    this.hasStar = false,
  });
}
