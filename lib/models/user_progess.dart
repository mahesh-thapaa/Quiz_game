// lib/models/user_progress.dart

class UserProgress {
  static int currentLevel = 0;
  static int totalXP = 0;
  static const int xpPerLevel = 100;

  static double get progress => (totalXP % xpPerLevel) / xpPerLevel;

  static void addXP(int xp) {
    totalXP += xp;
    currentLevel = totalXP ~/ xpPerLevel;
  }

  static String get nextUnlockName {
    switch (currentLevel) {
      case 0:
        return "Legends Quiz";
      case 1:
        return "Champions Mode";
      case 2:
        return "World Cup Quiz";
      default:
        return "Max Level";
    }
  }
}
