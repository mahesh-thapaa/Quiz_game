import 'package:quiz_game/models/level_models.dart';

class LevelData {
  static List<List<LevelModel>> getRows() {
    return [
      [
        const LevelModel(
          number: 1,
          status: LevelStatus.current,
          starsEarned: 2,
        ),
        const LevelModel(number: 2, status: LevelStatus.locked),
        const LevelModel(number: 3, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 2 — empty, 5, empty, empty  (offset row)
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 5, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 4, status: LevelStatus.locked),
      ],
      // Row 3
      [
        const LevelModel(number: 6, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 7, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 4
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 8, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 9, status: LevelStatus.locked),
      ],
      // Row 5
      [
        const LevelModel(number: 10, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.star, isSpecialStar: true),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 6
      [
        const LevelModel(number: 11, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 12, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 7
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 13, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 14, status: LevelStatus.locked),
      ],
      // Row 8 — star milestone
      [
        const LevelModel(number: 15, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(status: LevelStatus.star, isSpecialStar: true),
        const LevelModel(number: 16, status: LevelStatus.locked),
      ],
      // Row 9
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 17, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 10
      [
        const LevelModel(number: 18, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 19, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 11 — star milestone
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 20, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(status: LevelStatus.star, isSpecialStar: true),
      ],
      // Row 12 — unlock message spacer (handled in screen)
      // Row 13
      [
        const LevelModel(number: 21, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 22, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 14
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 23, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 24, status: LevelStatus.locked),
      ],
      // Row 15 — star
      [
        const LevelModel(number: 25, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.star, isSpecialStar: true),
        const LevelModel(number: 26, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 16
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 27, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 17
      [
        const LevelModel(number: 28, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 29, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 18
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 30, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(status: LevelStatus.star, isSpecialStar: true),
      ],
      // Row 19
      [
        const LevelModel(number: 31, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 32, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 20
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 33, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 34, status: LevelStatus.locked),
      ],
      // Row 21 — star
      [
        const LevelModel(number: 35, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(status: LevelStatus.star, isSpecialStar: true),
        const LevelModel(number: 36, status: LevelStatus.locked),
      ],
      // Row 22
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 37, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 23
      [
        const LevelModel(number: 38, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 39, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
      ],
      // Row 24
      [
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(number: 40, status: LevelStatus.locked),
        const LevelModel(status: LevelStatus.empty),
        const LevelModel(status: LevelStatus.star, isSpecialStar: true),
      ],
    ];
  }
}
