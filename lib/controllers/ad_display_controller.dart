import 'package:flutter/foundation.dart';
import 'package:quiz_game/services/ads/ad_service.dart';

class AdDisplayController {
  static final AdDisplayController _instance = AdDisplayController._internal();
  factory AdDisplayController() => _instance;
  AdDisplayController._internal();

  int _levelsCompletedSinceLastAd = 0;
  static const int adFrequency = 2;

  /// Call this whenever a level is completed to track when to show an automatic ad.
  void onLevelCompleted() {
    _levelsCompletedSinceLastAd++;
    debugPrint('Levels completed since last ad: $_levelsCompletedSinceLastAd / $adFrequency');

    if (_levelsCompletedSinceLastAd >= adFrequency) {
      _showAutomaticAd();
      _levelsCompletedSinceLastAd = 0;
    }
  }

  void _showAutomaticAd() {
    debugPrint('AdDisplayController: Showing automatic ad after $adFrequency levels.');
    AdService().showInterstitialAd();
  }
}
