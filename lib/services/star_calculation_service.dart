/// Star Calculation Service
/// Calculates stars based on correct answers using consistent logic across all quizzes

class StarCalculationService {
  /// Calculate stars based on number of correct answers
  ///
  /// Rules:
  /// - 0 correct answers → 0 stars
  /// - 1-4 correct answers → 1 star
  /// - 5-9 correct answers → 2 stars
  /// - 10+ correct answers → 3 stars
  static int calculateStars(int correctAnswers) {
    if (correctAnswers == 0) {
      return 0;
    } else if (correctAnswers >= 1 && correctAnswers <= 4) {
      return 1;
    } else if (correctAnswers >= 5 && correctAnswers <= 9) {
      return 2;
    } else {
      return 3;
    }
  }

  /// Calculate stars based on score and total questions
  /// This is an alternative method for percentage-based calculation if needed
  static int calculateStarsByPercentage(int score, int total) {
    if (total == 0) return 0;

    final int correctAnswers = score;
    return calculateStars(correctAnswers);
  }
}
