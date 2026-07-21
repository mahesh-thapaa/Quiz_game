import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  BannerAd? _cachedBannerAd;
  bool _isInterstitialLoading = false;
  int _retryAttempt = 0;

  // Test ad units (used in debug builds)
  static const String _testBannerUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';

  // Production ad units
  static const String _prodBannerUnitId = 'ca-app-pub-2829352214511086/1997866154';
  static const String _prodInterstitialUnitId = 'ca-app-pub-2829352214511086/9555276602';

  // Overridable via --dart-define
  static const String _overrideBannerUnitId = String.fromEnvironment(
    'ADMOB_BANNER_UNIT_ID',
    defaultValue: '',
  );
  static const String _overrideInterstitialUnitId = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_UNIT_ID',
    defaultValue: '',
  );

  static String get _bannerUnitId {
    if (_overrideBannerUnitId.isNotEmpty) return _overrideBannerUnitId;
    return kDebugMode ? _testBannerUnitId : _prodBannerUnitId;
  }

  static String get _interstitialUnitId {
    if (_overrideInterstitialUnitId.isNotEmpty) return _overrideInterstitialUnitId;
    return kDebugMode ? _testInterstitialUnitId : _prodInterstitialUnitId;
  }

  Future<void> init() async {
    try {
      await MobileAds.instance.initialize();

      // IMPORTANT: Register your device as a test device to see ads before Play Store launch
      // await MobileAds.instance.updateRequestConfiguration(
      //   RequestConfiguration(
      //     testDeviceIds: ['796126DBFFAB056B43AAAEC26E75F79E'], // Your device ID
      //   ),
      // );

      loadInterstitialAd();
      preloadBannerAd();
      debugPrint("Ads Initialized");
    } catch (e) {
      debugPrint("Ads Init Error: $e");
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _cachedBannerAd?.dispose();
    _cachedBannerAd = null;
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
  }

  BannerAd createBannerAd() {
    // Reuse cached banner ad if available
    if (_cachedBannerAd != null) {
      final ad = _cachedBannerAd!;
      _cachedBannerAd = null;
      return ad;
    }

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

  /// Preloads a banner ad for faster display next time.
  void preloadBannerAd() {
    if (_cachedBannerAd != null) return;
    final ad = BannerAd(
      adUnitId: _bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _cachedBannerAd = ad as BannerAd;
          debugPrint("✅ Banner Preloaded");
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("❌ Banner Preload Failed: ${error.message}");
        },
      ),
    );
    ad.load();
  }
}
