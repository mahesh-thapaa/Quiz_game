import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_game/controllers/quiz_controller.dart';

void main() {
  group('QuizController.getLevelTitle', () {
    test('returns LEVEL for non-bonus positions', () {
      expect(QuizController.getLevelTitle(1), 'LEVEL 1');
      expect(QuizController.getLevelTitle(2), 'LEVEL 2');
      expect(QuizController.getLevelTitle(5), 'LEVEL 5');
      expect(QuizController.getLevelTitle(7), 'LEVEL 7');
      expect(QuizController.getLevelTitle(13), 'LEVEL 13');
    });

    test('returns BONUS LEVEL for multiples of 6', () {
      expect(QuizController.getLevelTitle(6), 'BONUS LEVEL 1');
      expect(QuizController.getLevelTitle(12), 'BONUS LEVEL 2');
      expect(QuizController.getLevelTitle(18), 'BONUS LEVEL 3');
      expect(QuizController.getLevelTitle(24), 'BONUS LEVEL 4');
    });
  });

  group('QuizController.isBonusLevel', () {
    test('returns true for multiples of 6', () {
      expect(QuizController.isBonusLevel(6), isTrue);
      expect(QuizController.isBonusLevel(12), isTrue);
      expect(QuizController.isBonusLevel(18), isTrue);
      expect(QuizController.isBonusLevel(24), isTrue);
    });

    test('returns false for non-multiples of 6', () {
      expect(QuizController.isBonusLevel(1), isFalse);
      expect(QuizController.isBonusLevel(5), isFalse);
      expect(QuizController.isBonusLevel(7), isFalse);
      expect(QuizController.isBonusLevel(11), isFalse);
    });
  });
}
