import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  static const adUnitId = 'ca-app-pub-1467587305582185/7370119824';

  InterstitialAd? _ad;
  bool _isLoading = false;

  void loadAd() {
    if (_isLoading || _ad != null) return;

    _isLoading = true;
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _ad = ad;
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          debugPrint('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void show({required VoidCallback onFinished}) {
    final ad = _ad;
    if (ad == null) {
      loadAd();
      onFinished();
      return;
    }

    _ad = null;
    var finished = false;
    void finish() {
      if (finished) return;
      finished = true;
      onFinished();
      loadAd();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        finish();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial ad failed to show: $error');
        ad.dispose();
        finish();
      },
    );
    ad.show();
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
