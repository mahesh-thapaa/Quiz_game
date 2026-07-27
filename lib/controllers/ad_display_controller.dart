import 'package:flutter/foundation.dart';
import 'package:quiz_game/services/ads/ad_service.dart';

class AdDisplayController {
  static final AdDisplayController _instance = AdDisplayController._internal();
  factory AdDisplayController() => _instance;
  AdDisplayController._internal();

  int _levelsCompletedSinceLastAd = 0;
  static const int adFrequency = 4;


  void handleLevelTransition({required VoidCallback onComplete}) {
    _levelsCompletedSinceLastAd++;
    debugPrint(
      'Levels completed since last ad: $_levelsCompletedSinceLastAd / $adFrequency',
    );

    if (_levelsCompletedSinceLastAd >= adFrequency) {
      _levelsCompletedSinceLastAd = 0;
      _showAutomaticAd(onComplete: onComplete);
    } else {
      onComplete();
    }
  }

  void _showAutomaticAd({required VoidCallback onComplete}) {
    debugPrint(
      'AdDisplayController: Showing automatic ad after $adFrequency levels.',
    );
    AdService().showInterstitialAd(
      onAdDismissed: onComplete,
      onAdFailedToShow: onComplete,
    );
  }
}
