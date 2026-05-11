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

  /// True when user reached final day.
  bool get isComplete => currentDay >= totalDays;

  /// True when streak never started yet.
  bool get isNotStarted => currentDay == 0;

  /// Coins earned on completion.
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
  String toString() {
    return 'StreakModel(title: $title, currentDay: $currentDay, totalDays: $totalDays)';
  }
}
