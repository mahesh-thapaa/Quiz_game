class JurseyQuestionModel {
  final int questionNumber;
  final int totalQuestions;
  final String imagePath;
  final String questionText;
  final List<String> options;
  final int correctIndex;

  JurseyQuestionModel({
    required this.questionNumber,
    required this.totalQuestions,
    required this.imagePath,
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });
}

class JurseyQuizResult {
  final int score;
  final int totalQuestions;
  final int starsEarned;
  final int xpEarned;
  final int coinsEarned;
  final int accuracy;

  JurseyQuizResult({
    required this.score,
    required this.totalQuestions,
    required this.starsEarned,
    required this.xpEarned,
    required this.coinsEarned,
    required this.accuracy,
  });
}
