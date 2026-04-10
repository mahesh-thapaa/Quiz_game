class PlayerQuestionModel {
  final int questionNumber;
  final int totalQuestions;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String imagePath;

  PlayerQuestionModel({
    required this.questionNumber,
    required this.totalQuestions,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.imagePath,
  });
}
