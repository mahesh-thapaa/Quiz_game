import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quiz_game/services/ads/ad_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdDisplayController {
  static final AdDisplayController _instance = AdDisplayController._internal();
  factory AdDisplayController() => _instance;
  AdDisplayController._internal();

  static const String _counterKey = 'levels_completed_since_last_ad';
  static const String _premiumKey = 'is_premium_ad_free';
  static const int adFrequency = 4;
  static const Duration _adTimeout = Duration(seconds: 10);

  int _levelsCompletedSinceLastAd = 0;
  bool _isPremium = false;
  bool _isShowingAd = false;
  bool _isDisposed = false;
  Timer? _adTimeoutTimer;
  AdService? _adService;

  bool get isPremium => _isPremium;

  Future<void> init({AdService? adService}) async {
    _adService = adService ?? AdService();
    final prefs = await SharedPreferences.getInstance();
    _levelsCompletedSinceLastAd = prefs.getInt(_counterKey) ?? 0;
    _isPremium = prefs.getBool(_premiumKey) ?? false;
  }

  Future<void> setPremium(bool value) async {
    _isPremium = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, value);
    debugPrint('AdDisplayController: Premium ad-free = $value');
  }

  Future<void> _persistCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, _levelsCompletedSinceLastAd);
  }

  void handleLevelTransition({required VoidCallback onComplete}) {
    if (_isDisposed) return;

    if (_isPremium) {
      debugPrint('AdDisplayController: Premium user, skipping ad.');
      onComplete();
      return;
    }

    _levelsCompletedSinceLastAd++;
    debugPrint(
      'Levels completed since last ad: $_levelsCompletedSinceLastAd / $adFrequency',
    );

    if (_levelsCompletedSinceLastAd >= adFrequency) {
      _levelsCompletedSinceLastAd = 0;
      _showAutomaticAd(onComplete: onComplete);
    } else {
      _persistCounter();
      onComplete();
    }
  }

  void _showAutomaticAd({required VoidCallback onComplete}) {
    if (_isDisposed) return;

    _isShowingAd = true;
    debugPrint(
      'AdDisplayController: Showing automatic ad after $adFrequency levels.',
    );

    _adTimeoutTimer?.cancel();
    _adTimeoutTimer = Timer(_adTimeout, () {
      if (_isShowingAd) {
        debugPrint('AdDisplayController: Ad timed out, proceeding.');
        _finalizeAd(callback: onComplete);
      }
    });

    _adService?.showInterstitialAd(
      onAdDismissed: () => _finalizeAd(callback: onComplete),
      onAdFailedToShow: () => _finalizeAd(callback: onComplete),
    );
  }

  void _finalizeAd({required VoidCallback callback}) {
    if (!_isShowingAd || _isDisposed) return;
    _isShowingAd = false;
    _adTimeoutTimer?.cancel();
    _persistCounter();
    callback();
  }

  void dispose() {
    _isDisposed = true;
    _adTimeoutTimer?.cancel();
  }
}
