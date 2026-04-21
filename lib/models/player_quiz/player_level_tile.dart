class PlayerLevelTile {
  final int? number;
  final bool hasStar;
  bool isCurrent;
  bool isUnlocked;
  int starsEarned;
  final String? levelDocId;

  PlayerLevelTile({
    this.number,
    this.hasStar = false,
    this.isCurrent = false,
    this.isUnlocked = false,
    this.starsEarned = 0,
    this.levelDocId,
  });
}
