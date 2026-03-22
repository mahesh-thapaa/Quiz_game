// lib/models/discover_models.dart

enum UnlockType { level, coins, comingSoon }

class ChallengeModel {
  final String title;
  final String imagePath;
  final UnlockType unlockType;
  final String? unlockText;

  ChallengeModel({
    required this.title,
    required this.imagePath,
    required this.unlockType,
    this.unlockText,
  });
}
