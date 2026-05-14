class LeaderboardEntry {
  final String username;
  final int xpPoints;
  final int weeklyXP;
  final int rank;
  final int rankChange;
  final bool isCurrentUser;
  final int coins;
  final String name;
  final String bio;
  final String avatarUrl;
  final bool isVerified;

  const LeaderboardEntry({
    required this.username,
    required this.xpPoints,
    required this.weeklyXP,
    this.rank = 0,
    this.rankChange = 0,
    this.isCurrentUser = false,
    this.coins = 0,
    this.name = '',
    this.bio = '',
    this.avatarUrl = '',
    this.isVerified = false,
  });

  // ✅ Default current user

  LeaderboardEntry copyWith({
    String? username,
    int? xpPoints,
    int? weeklyXP,
    int? rank,
    int? rankChange,
    bool? isCurrentUser,
    int? level,
    int? coins,
    String? name,
    String? bio,
    String? avatarUrl,
    bool? isVerified,
  }) {
    return LeaderboardEntry(
      username: username ?? this.username,
      xpPoints: xpPoints ?? this.xpPoints,
      weeklyXP: weeklyXP ?? this.weeklyXP,
      rank: rank ?? this.rank,
      rankChange: rankChange ?? this.rankChange,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,

      coins: coins ?? this.coins,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
