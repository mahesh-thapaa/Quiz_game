import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_game/controllers/star_calculation_service.dart';

void main() {
  group('StarCalculationService.calculateStars', () {
    test('returns 3 stars for 10 or more correct answers', () {
      expect(StarCalculationService.calculateStars(10), 3);
      expect(StarCalculationService.calculateStars(15), 3);
      expect(StarCalculationService.calculateStars(100), 3);
    });

    test('returns 2 stars for 6-9 correct answers', () {
      expect(StarCalculationService.calculateStars(6), 2);
      expect(StarCalculationService.calculateStars(7), 2);
      expect(StarCalculationService.calculateStars(9), 2);
    });

    test('returns 1 star for 1-5 correct answers', () {
      expect(StarCalculationService.calculateStars(1), 1);
      expect(StarCalculationService.calculateStars(3), 1);
      expect(StarCalculationService.calculateStars(5), 1);
    });

    test('returns 0 stars for 0 correct answers', () {
      expect(StarCalculationService.calculateStars(0), 0);
    });
  });
}
