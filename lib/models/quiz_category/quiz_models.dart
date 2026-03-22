class QuizModel {
  final String title;
  final String subtitle;
  final String image;
  final bool isLocked;

  QuizModel({
    required this.title,
    required this.subtitle,
    required this.image,
    this.isLocked = false,
  });
}