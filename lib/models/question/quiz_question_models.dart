// lib/models/quiz_question_model.dart

class QuizOption {
  final String label; // A, B, C, D
  final String text;

  const QuizOption({required this.label, required this.text});
}

class QuizQuestion {
  final int questionNumber;
  final int totalQuestions;
  final String questionText;
  final String imagePath;
  final List<QuizOption> options;
  final String correctLabel; // which label is correct e.g. "B"
  final int progressPercent; // e.g. 80

  const QuizQuestion({
    required this.questionNumber,
    required this.totalQuestions,
    required this.questionText,
    required this.imagePath,
    required this.options,
    required this.correctLabel,
    required this.progressPercent,
  });
}
