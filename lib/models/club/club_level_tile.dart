class ClubLevelTile {
  final bool hasStar;
  final int? number; // nullable only because bonus tiles have no number
  bool isUnlocked;
  bool isCurrent;
  int starsEarned;
  String? bonusDocId;

  ClubLevelTile({
    this.hasStar = false,
    this.number,
    this.isUnlocked = false,
    this.isCurrent = false,
    this.starsEarned = 0,
    this.bonusDocId,
  });
}
