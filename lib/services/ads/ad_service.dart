import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoading = false;
  int _rewardedAdRetryAttempt = 0;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoading = false;
  int _interstitialAdRetryAttempt = 0;

  // Real Ad IDs
  static const String _realRewardedUnitId = 'ca-app-pub-7334258098187344/5521965196';
  // Using same ID as fallback if real interstitial ID is not provided
  static const String _realInterstitialUnitId = 'ca-app-pub-7334258098187344/5521965196';

  // Official Google Test Ad IDs
  static const String _testRewardedUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testInterstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';

  /// Returns the appropriate Ad Unit ID based on debug/release mode.
  String get rewardedAdUnitId => kDebugMode ? _testRewardedUnitId : _realRewardedUnitId;
  String get interstitialAdUnitId => kDebugMode ? _testInterstitialUnitId : _realInterstitialUnitId;

  /// Initialize the Mobile Ads SDK and load the ads.
  Future<void> init() async {
    try {
      await MobileAds.instance.initialize();
      
      if (kDebugMode) {
        MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: ['796126DBFFAB056B43AAAEC26E75F79E']),
        );
      }
      
      loadRewardedAd();
      loadInterstitialAd();
    } catch (e) {
      debugPrint('AdService initialization error: $e');
    }
  }

  /// Load a rewarded ad.
  void loadRewardedAd() {
    if (_isRewardedAdLoading) return;
    _isRewardedAdLoading = true;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoading = false;
          _rewardedAdRetryAttempt = 0;
          debugPrint('Rewarded Ad Loaded Successfully');
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isRewardedAdLoading = false;
          _rewardedAdRetryAttempt++;
          debugPrint('Rewarded Ad Failed to Load: $error');
          if (_rewardedAdRetryAttempt < 6) {
            Future.delayed(Duration(seconds: _rewardedAdRetryAttempt * 5), loadRewardedAd);
          }
        },
      ),
    );
  }

  /// Load an interstitial ad.
  void loadInterstitialAd() {
    if (_isInterstitialAdLoading) return;
    _isInterstitialAdLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoading = false;
          _interstitialAdRetryAttempt = 0;
          debugPrint('Interstitial Ad Loaded Successfully');
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialAdLoading = false;
          _interstitialAdRetryAttempt++;
          debugPrint('Interstitial Ad Failed to Load: $error');
          if (_interstitialAdRetryAttempt < 6) {
            Future.delayed(Duration(seconds: _interstitialAdRetryAttempt * 5), loadInterstitialAd);
          }
        },
      ),
    );
  }

  /// Show the rewarded ad if available.
  void showRewardedAd({
    required VoidCallback onRewardEarned,
    VoidCallback? onAdDismissed,
    VoidCallback? onAdFailedToShow,
  }) {
    if (_rewardedAd == null) {
      debugPrint('Rewarded Ad not ready yet');
      loadRewardedAd();
      if (onAdFailedToShow != null) onAdFailedToShow();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
        if (onAdDismissed != null) onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadRewardedAd();
        if (onAdFailedToShow != null) onAdFailedToShow();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onRewardEarned();
      },
    );
    _rewardedAd = null;
  }

  /// Show the interstitial ad if available.
  void showInterstitialAd({
    VoidCallback? onAdDismissed,
    VoidCallback? onAdFailedToShow,
  }) {
    if (_interstitialAd == null) {
      debugPrint('Interstitial Ad not ready yet');
      loadInterstitialAd();
      if (onAdFailedToShow != null) onAdFailedToShow();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
        if (onAdDismissed != null) onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadInterstitialAd();
        if (onAdFailedToShow != null) onAdFailedToShow();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
