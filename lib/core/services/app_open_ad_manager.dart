import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  static const adUnitId = 'ca-app-pub-1467587305582185/5437171180';

  AppOpenAd? _appOpenAd;
  DateTime? _loadedAt;
  bool _isLoading = false;
  bool _isShowing = false;

  void loadAd({bool showWhenLoaded = false}) {
    if (_isLoading || _appOpenAd != null) {
      return;
    }

    _isLoading = true;
    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _appOpenAd = ad;
          _loadedAt = DateTime.now();
          if (showWhenLoaded) {
            showAdIfAvailable();
          }
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          debugPrint('App-open ad failed to load: $error');
        },
      ),
    );
  }

  void showAdIfAvailable() {
    if (_isShowing) {
      return;
    }

    final ad = _appOpenAd;
    if (ad == null) {
      loadAd(showWhenLoaded: true);
      return;
    }

    if (_loadedAt != null &&
        DateTime.now().difference(_loadedAt!) > const Duration(hours: 4)) {
      ad.dispose();
      _appOpenAd = null;
      _loadedAt = null;
      loadAd(showWhenLoaded: true);
      return;
    }

    _appOpenAd = null;
    _loadedAt = null;
    _isShowing = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowing = false;
        ad.dispose();
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        _isShowing = false;
        ad.dispose();
        loadAd();
      },
    );
    ad.show();
  }
}
