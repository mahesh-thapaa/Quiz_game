/// Represents a single tile in the level-selection grid.
/// Replaces the per-quiz duplicates (ClubLevelTile, PlayerLevelTile,
/// StadiumLevelTile, JerseyLevelTile) with one shared model.
class QuizLevelTile {
  final bool hasStar;
  final int? number;
  bool isUnlocked;
  bool isCurrent;
  int starsEarned;
  String? bonusDocId;

  QuizLevelTile({
    this.hasStar = false,
    this.number,
    this.isUnlocked = false,
    this.isCurrent = false,
    this.starsEarned = 0,
    this.bonusDocId,
  });
}
