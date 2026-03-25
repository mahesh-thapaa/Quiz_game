// lib/models/profile/profile_models.dart

class ProfileModel {
  final String name;
  final String bio;
  final String avatarAsset;
  final int rank;
  final int level;
  final int coins;
  final bool isVerified;

  const ProfileModel({
    required this.name,
    required this.bio,
    required this.avatarAsset,
    required this.rank,
    required this.level,
    required this.coins,
    this.isVerified = true,
  });
}

class LeaderboardEntry {
  final int rank;
  final String username;
  final int xpPoints;
  final String? avatarAsset;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.username,
    required this.xpPoints,
    this.avatarAsset,
    this.isCurrentUser = false,
  });
}

class ProfileData {
  static const ProfileModel user = ProfileModel(
    name: 'Sushant',
    bio: 'Football Enthusiast • Pro Quizzer',
    avatarAsset: 'asstes/images/ronaldo.png',
    rank: 1204,
    level: 3,
    coins: 340,
  );

  static const List<LeaderboardEntry> leaderboard = [
    LeaderboardEntry(rank: 1, username: 'Fabrizio_Rom', xpPoints: 24500),
    LeaderboardEntry(rank: 2, username: 'GoalDigger', xpPoints: 22180),
    LeaderboardEntry(rank: 3, username: 'OffsideExpert', xpPoints: 21400),
    LeaderboardEntry(
      rank: 1204,
      username: 'Sushant (You)',
      xpPoints: 1250,
      isCurrentUser: true,
    ),
  ];
}
