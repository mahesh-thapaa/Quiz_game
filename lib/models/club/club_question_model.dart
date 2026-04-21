class ClubQuestionModel {
  final int questionNumber;
  final int totalQuestions;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String? imagePath;

  ClubQuestionModel({
    required this.questionNumber,
    required this.totalQuestions,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.imagePath,
  });
}

class ClubQuizResult {
  final int score;
  final int totalQuestions;
  final int starsEarned;
  final int xpEarned;
  final int coinsEarned;
  final int accuracy;

  ClubQuizResult({
    required this.score,
    required this.totalQuestions,
    required this.starsEarned,
    required this.xpEarned,
    required this.coinsEarned,
    required this.accuracy,
  });
}
