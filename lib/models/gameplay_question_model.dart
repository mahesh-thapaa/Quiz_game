/// A single question displayed during gameplay.
/// Replaces the per-quiz duplicates (ClubQuestionModel, PlayerQuestionModel,
/// StadiumQuestionModel, JurseyQuestionModel) with one shared model.
class GameplayQuestionModel {
  final int questionNumber;
  final int totalQuestions;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String? imagePath;

  GameplayQuestionModel({
    required this.questionNumber,
    required this.totalQuestions,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.imagePath,
  });
}
