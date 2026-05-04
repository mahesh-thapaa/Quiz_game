import 'package:flutter/foundation.dart';
import 'package:quiz_game/services/ads/ad_service.dart';

class AdDisplayController {
  static final AdDisplayController _instance = AdDisplayController._internal();
  factory AdDisplayController() => _instance;
  AdDisplayController._internal();

  int _levelsCompletedSinceLastAd = 0;
  static const int adFrequency = 2;

  /// Call this when the user wants to proceed to the next level.
  /// If an ad is due, it shows the ad and then calls [onComplete].
  /// If no ad is due, it calls [onComplete] immediately.
  void handleLevelTransition({required VoidCallback onComplete}) {
    _levelsCompletedSinceLastAd++;
    debugPrint('Levels completed since last ad: $_levelsCompletedSinceLastAd / $adFrequency');

    if (_levelsCompletedSinceLastAd >= adFrequency) {
      _levelsCompletedSinceLastAd = 0;
      _showAutomaticAd(onComplete: onComplete);
    } else {
      onComplete();
    }
  }

  void _showAutomaticAd({required VoidCallback onComplete}) {
    debugPrint('AdDisplayController: Showing automatic ad after $adFrequency levels.');
    AdService().showInterstitialAd(
      onAdDismissed: onComplete,
      onAdFailedToShow: onComplete,
    );
  }
}
