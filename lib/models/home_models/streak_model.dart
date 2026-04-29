// lib/models/home_models/streak_model.dart

class StreakModel {
  final String title;
  final int currentDay;
  final int totalDays;
  final bool rewardClaimed;
  final bool justCompleted;

  const StreakModel({
    required this.title,
    required this.currentDay,
    required this.totalDays,
    this.rewardClaimed = false,
    this.justCompleted = false,
  });

  /// True when the user just completed the final day of the streak.
  bool get isComplete => currentDay >= totalDays;

  /// True when no streak has started (or was reset).
  /// True when the user failed to maintain their streak.
  /// We only show this if they haven't finished today's cycle.
  bool get isBroken => currentDay == 0 && !rewardClaimed;

  /// Coins awarded when the 7-day streak is completed.
  int get rewardCoins => isComplete ? 500 : 0;

  StreakModel copyWith({
    String? title,
    int? currentDay,
    int? totalDays,
    bool? rewardClaimed,
    bool? justCompleted,
  }) {
    return StreakModel(
      title: title ?? this.title,
      currentDay: currentDay ?? this.currentDay,
      totalDays: totalDays ?? this.totalDays,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      justCompleted: justCompleted ?? this.justCompleted,
    );
  }

  @override
  String toString() =>
      'StreakModel(title: $title, currentDay: $currentDay, totalDays: $totalDays, rewardClaimed: $rewardClaimed, justCompleted: $justCompleted)';
}
