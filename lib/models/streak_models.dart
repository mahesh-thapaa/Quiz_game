// lib/models/home_models/streak_model.dart

class StreakModel {
  final String title;
  final int currentDay;
  final int totalDays;

  const StreakModel({
    required this.title,
    required this.currentDay,
    required this.totalDays,
  });

  /// True when the user just completed the final day of the streak.
  bool get isComplete => currentDay >= totalDays;

  /// True when no streak has started (or was reset).
  bool get isBroken => currentDay == 0;

  /// Coins awarded when the 7-day streak is completed.
  int get rewardCoins => isComplete ? 500 : 0;

  StreakModel copyWith({String? title, int? currentDay, int? totalDays}) {
    return StreakModel(
      title: title ?? this.title,
      currentDay: currentDay ?? this.currentDay,
      totalDays: totalDays ?? this.totalDays,
    );
  }

  @override
  String toString() =>
      'StreakModel(title: $title, currentDay: $currentDay, totalDays: $totalDays)';
}
