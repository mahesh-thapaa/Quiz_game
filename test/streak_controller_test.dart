import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_game/controllers/daily_challenger_controller.dart';

void main() {
  group('DailyChallengerController', () {
    test('getRemainingTime returns non-negative duration', () {
      final remaining = DailyChallengerController.getRemainingTime();
      expect(remaining.isNegative, isFalse);
    });

    test('getRemainingTime is at most 24 hours', () {
      final remaining = DailyChallengerController.getRemainingTime();
      expect(remaining.inHours, lessThanOrEqualTo(24));
    });

    test('getNextResetTime is always in the future', () {
      final resetTime = DailyChallengerController.getNextResetTime();
      expect(resetTime.isAfter(DateTime.now()), isTrue);
    });

    test('getNextResetTime is always at 7:00 AM', () {
      final resetTime = DailyChallengerController.getNextResetTime();
      expect(resetTime.hour, 7);
      expect(resetTime.minute, 0);
      expect(resetTime.second, 0);
    });
  });
}
