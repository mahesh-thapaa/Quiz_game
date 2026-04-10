class StreakRewardModel {
  final int streakDays;
  final int coinsEarned;
  final String title;
  final String subtitle;

  const StreakRewardModel({
    required this.streakDays,
    required this.coinsEarned,
    required this.title,
    required this.subtitle,
  });

  factory StreakRewardModel.defaultReward() {
    return const StreakRewardModel(
      streakDays: 7,
      coinsEarned: 500,
      title: 'Streak Reward Claimed!',
      subtitle: 'You completed a 7-day streak.',
    );
  }
}
