class QuizQuestionModel {
  final int id;
  final String questionText;
  final String imageUrl;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestionModel({
    required this.id,
    required this.questionText,
    required this.imageUrl,
    required this.options,
    required this.correctOptionIndex,
  });
}

class QuizResultModel {
  final int score;
  final int totalQuestions;
  final int starsEarned;
  final int xpEarned;
  final int coinsEarned;
  final int accuracy;

  QuizResultModel({
    required this.score,
    required this.totalQuestions,
    required this.starsEarned,
    required this.xpEarned,
    required this.coinsEarned,
    required this.accuracy,
  });
}
