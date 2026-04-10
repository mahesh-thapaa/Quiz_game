class QuizLevel {
  final String id;
  final int levelNumber;
  final String title;
  final int order;
  final bool isBonus;
  final int totalQuestions;
  final String quizId;

  const QuizLevel({
    required this.id,
    required this.levelNumber,
    required this.title,
    required this.order,
    required this.isBonus,
    required this.totalQuestions,
    required this.quizId,
  });

  factory QuizLevel.fromMap(String docId, Map<String, dynamic> data) {
    return QuizLevel(
      id: docId,
      levelNumber: data['levelNumber'] as int? ?? 0,
      title: data['title'] as String? ?? 'Level',
      order: data['order'] as int? ?? 0,
      isBonus: data['isBonus'] as bool? ?? false,
      totalQuestions: data['totalQuestions'] as int? ?? 0,
      quizId: data['quizId'] as String? ?? '',
    );
  }
}

class QuizQuestion {
  final String title;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imagePath;
  final int order;
  final String levelId;
  final String quizId;

  const QuizQuestion({
    required this.title,
    required this.options,
    required this.correctAnswerIndex,
    this.imagePath,
    required this.order,
    required this.levelId,
    required this.quizId,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> data) {
    // options is stored as a Firestore array → List<String>
    final rawOptions = data['options'];
    final List<String> options;
    if (rawOptions is List) {
      options = rawOptions.map((e) => e.toString()).toList();
    } else {
      options = [];
    }

    return QuizQuestion(
      title: data['title'] as String? ?? '',
      options: options,
      correctAnswerIndex: data['correctAnswerIndex'] as int? ?? 0,
      imagePath: data['imagePath'] as String?,
      order: data['order'] as int? ?? 0,
      levelId: data['levelId'] as String? ?? '',
      quizId: data['quizId'] as String? ?? '',
    );
  }
}
