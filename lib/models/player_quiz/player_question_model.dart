class PlayerQuestionModel {
  final int questionNumber;
  final int totalQuestions;
  final String imagePath;
  final String questionText;
  final List<String> options;
  final int correctIndex;

  PlayerQuestionModel({
    required this.questionNumber,
    required this.totalQuestions,
    required this.imagePath,
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });
}

class PlayerQuizResult {
  final int score;
  final int totalQuestions;
  final int starsEarned;
  final int xpEarned;
  final int coinsEarned;
  final int accuracy;

  PlayerQuizResult({
    required this.score,
    required this.totalQuestions,
    required this.starsEarned,
    required this.xpEarned,
    required this.coinsEarned,
    required this.accuracy,
  });
}
