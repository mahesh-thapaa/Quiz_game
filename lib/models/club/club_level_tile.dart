class ProfileLevel {
  final int? number;
  int starsEarned;
  final bool isUnlocked;
  final bool isCurrent;
  final bool hasStar;

  ProfileLevel({
    this.number,
    this.starsEarned = 0,
    this.isUnlocked = false,
    this.isCurrent = false,
    this.hasStar = false,
  });
}
