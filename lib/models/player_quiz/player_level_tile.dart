class ProfileLevel {
  final int? number;
  final bool hasStar;
  final bool isCurrent;
  bool isUnlocked;
  int starsEarned;
  final String? levelDocId;

  ProfileLevel({
    this.number,
    this.hasStar = false,
    this.isCurrent = false,
    this.isUnlocked = false,
    this.starsEarned = 0,
    this.levelDocId,
  });
}
