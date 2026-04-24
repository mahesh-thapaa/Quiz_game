import 'package:quiz_game/models/quiz_level_tile.dart';
import 'package:quiz_game/controllers/quiz_controller.dart';
import 'package:quiz_game/models/quiz_models/QuizLevel.dart';

class LevelGridController {
  final List<QuizLevelTile> block1Items;
  final List<QuizLevelTile> block2Items;

  LevelGridController({
    required this.block1Items,
    required this.block2Items,
  });

  /// Factory to create an initial state
  factory LevelGridController.initial() {
    return LevelGridController(
      block1Items: _generateLevels(start: 1, count: 24),
      block2Items: _generateLevels(start: 25, count: 24),
    );
  }

  static List<QuizLevelTile> _generateLevels({required int start, required int count}) {
    return List.generate(count, (i) {
      int gridPos = start + i;
      return QuizLevelTile(
        hasStar: QuizController.isBonusLevel(gridPos),
        number: gridPos,
        isUnlocked: gridPos == 1,
        starsEarned: 0,
      );
    });
  }

  /// Updates all tiles based on loaded progress
  void applyProgress(Map<int, int> stars) {
    final all = [...block1Items, ...block2Items];
    for (var tile in all) {
      if (stars.containsKey(tile.number)) {
        tile.starsEarned = stars[tile.number]!;
        if (tile.starsEarned > 0) {
          tile.isUnlocked = true;
          unlockNext(tile.number!);
        }
      }
    }
    updateCurrentTile();
  }

  /// Handles the unlocking of the next level
  void unlockNext(int num) {
    final all = [...block1Items, ...block2Items];
    int idx = all.indexWhere((t) => t.number == num);
    if (idx != -1 && idx < all.length - 1) {
      all[idx + 1].isUnlocked = true;
    }
  }

  /// Sets the 'isCurrent' flag on the first incomplete level
  void updateCurrentTile() {
    final all = [...block1Items, ...block2Items];
    for (var t in all) t.isCurrent = false;
    for (var t in all) {
      if (!t.hasStar && t.isUnlocked && t.starsEarned == 0) {
        t.isCurrent = true;
        break;
      }
    }
  }

  /// Helper to get questions for a grid position
  List<QuizQuestion> getQuestionsForPos(
    int pos,
    Map<String, List<QuizQuestion>> questionsByLevel,
    Map<int, String> levelDocIds,
    Map<int, String> bonusSlotToDocId,
  ) {
    String? id = QuizController.isBonusLevel(pos)
        ? bonusSlotToDocId[(pos ~/ 6) - 1]
        : levelDocIds[pos - (pos ~/ 6)];
    return id != null ? (questionsByLevel[id] ?? []) : [];
  }
}
