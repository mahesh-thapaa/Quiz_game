import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  int _retryAttempt = 0;

  static String get _bannerUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Google Test Banner
    }
    return 'ca-app-pub-7334258098187344/3053792918';
  }

  static String get _interstitialUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Google Test Interstitial
    }
    return 'ca-app-pub-7334258098187344/7625032700';
  }

  Future<void> init() async {
    try {
      await MobileAds.instance.initialize();

      // IMPORTANT: Register your device as a test device to see ads before Play Store launch
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: ['796126DBFFAB056B43AAAEC26E75F79E'], // Your device ID
        ),
      );

      loadInterstitialAd();
      debugPrint("Ads Initialized");
    } catch (e) {
      debugPrint("Ads Init Error: $e");
    }
  }

  void loadInterstitialAd() {
    if (_isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _retryAttempt = 0;
          debugPrint("✅ Interstitial Loaded Successfully");
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
          _retryAttempt++;

          // Log specific error to diagnose No Fill (Error 3)
          debugPrint(
            "❌ Interstitial Failed to Load: ${error.message} (Code: ${error.code})",
          );

          if (_retryAttempt <= 5) {
            Future.delayed(
              Duration(seconds: _retryAttempt * 5),
              loadInterstitialAd,
            );
          }
        },
      ),
    );
  }

  void showInterstitialAd({
    VoidCallback? onAdDismissed,
    VoidCallback? onAdFailedToShow,
  }) {
    if (_interstitialAd == null) {
      debugPrint("⚠️ Interstitial not ready. Loading for next time.");
      loadInterstitialAd();
      if (onAdFailedToShow != null) onAdFailedToShow();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
        if (onAdDismissed != null) onAdDismissed();
      },
      // Change 'ToLoad' to 'ToShow' below
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
        if (onAdFailedToShow != null) onAdFailedToShow();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => debugPrint("✅ Banner Loaded"),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("❌ Banner Failed: ${error.message}");
        },
      ),
    );
  }
}
