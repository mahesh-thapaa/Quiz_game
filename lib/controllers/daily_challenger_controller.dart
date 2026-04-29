class DailyChallengerController {
  /// Calculates the next 7:00 AM reset point.
  static DateTime getNextResetTime() {
    final now = DateTime.now();
    DateTime resetTime;

    // Daily reset at 7:00 AM
    if (now.hour >= 7) {
      // If past 7:00 AM today, next reset is tomorrow at 7:00 AM
      resetTime = DateTime(now.year, now.month, now.day + 1, 7);
    } else {
      // If before 7:00 AM today, next reset is today at 7:00 AM
      resetTime = DateTime(now.year, now.month, now.day, 7);
    }
    return resetTime;
  }

  /// Calculates the duration between now and the next reset.
  static Duration getRemainingTime() {
    final now = DateTime.now();
    final resetTime = getNextResetTime();
    final diff = resetTime.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }
}
