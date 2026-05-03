// lib/controllers/star_calculation_service.dart

class StarCalculationService {
  /// Logic for star rewards (e.g. 0-3 stars based on correct answers)
  static int calculateStars(int correctAnswers) {
    if (correctAnswers >= 10) return 3;
    if (correctAnswers >= 7) return 2;
    if (correctAnswers >= 4) return 1;
    return 0;
  }
}
