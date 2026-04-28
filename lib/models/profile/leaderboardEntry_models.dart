class LeaderboardEntry {
  final String username;
  final int xpPoints;
  final int weeklyXP;
  final int rank;
  final int rankChange;
  final bool isCurrentUser;
  final int level;
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
    this.level = 1,
    this.coins = 0,
    this.name = '',
    this.bio = '',
    this.avatarUrl = '',
    this.isVerified = false,
  });

  // ✅ Default current user
  static const LeaderboardEntry user = LeaderboardEntry(
    username: 'sushant123',
    xpPoints: 1200,
    weeklyXP: 300,
    rank: 1,
    rankChange: 2,
    isCurrentUser: true,
    level: 3,
    coins: 640,
    name: 'Sushant',
    bio: 'Football fanatic 🔥',
    avatarUrl: '',
    isVerified: true,
  );

  // ✅ Default leaderboard list sorted by weeklyXP descending
  static const List<LeaderboardEntry> leaderboard = [
    LeaderboardEntry(
      username: 'sushant123',
      xpPoints: 1200,
      weeklyXP: 300,
      rank: 1,
      rankChange: 2,
      isCurrentUser: true,
      level: 3,
      coins: 640,
      name: 'Sushant',
      bio: 'Football fanatic 🔥',
      avatarUrl: '',
      isVerified: true,
    ),
    LeaderboardEntry(
      username: 'alex99',
      xpPoints: 980,
      weeklyXP: 250,
      rank: 2,
      rankChange: 0,
      level: 2,
      coins: 500,
      name: 'Alex',
      bio: 'Quiz master',
      avatarUrl: '',
      isVerified: false,
    ),
    LeaderboardEntry(
      username: 'maria_k',
      xpPoints: 870,
      weeklyXP: 200,
      rank: 3,
      rankChange: -1,
      level: 2,
      coins: 420,
      name: 'Maria',
      bio: 'Sports lover',
      avatarUrl: '',
      isVerified: false,
    ),
    LeaderboardEntry(
      username: 'john_doe',
      xpPoints: 750,
      weeklyXP: 180,
      rank: 4,
      rankChange: 1,
      level: 1,
      coins: 300,
      name: 'John',
      bio: 'Football forever',
      avatarUrl: '',
      isVerified: false,
    ),
    LeaderboardEntry(
      username: 'sara_x',
      xpPoints: 600,
      weeklyXP: 150,
      rank: 5,
      rankChange: -1,
      level: 1,
      coins: 200,
      name: 'Sara',
      bio: 'New player',
      avatarUrl: '',
      isVerified: false,
    ),
  ];

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
      level: level ?? this.level,
      coins: coins ?? this.coins,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
