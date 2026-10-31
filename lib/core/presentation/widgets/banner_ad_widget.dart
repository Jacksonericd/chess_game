import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key, this.maxWidth});

  static const adUnitId = 'ca-app-pub-1467587305582185/7916936818';
  final double? maxWidth;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  AdSize? _adSize;
  int _requestedWidth = 0;
  int _loadGeneration = 0;
  int _retryCount = 0;
  Timer? _retryTimer;
  bool _isLoaded = false;

  void _scheduleRetry(int width) {
    _retryTimer?.cancel();
    final seconds = 1 << _retryCount.clamp(0, 5).toInt();
    _retryCount++;
    _retryTimer = Timer(Duration(seconds: seconds), () {
      _requestedWidth = 0;
      _loadAd(width);
    });
  }

  Future<void> _loadAd(int width) async {
    if (width <= 0 || width == _requestedWidth) return;
    _retryTimer?.cancel();
    _requestedWidth = width;
    final generation = ++_loadGeneration;
    _bannerAd?.dispose();
    _bannerAd = null;
    _adSize = null;
    _isLoaded = false;
    if (mounted) setState(() {});

    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || generation != _loadGeneration) return;
    if (size == null) {
      _scheduleRetry(width);
      return;
    }

    final ad = BannerAd(
      adUnitId: BannerAdWidget.adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted && generation == _loadGeneration) {
            _retryCount = 0;
            setState(() => _isLoaded = true);
          }
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          if (mounted && generation == _loadGeneration) {
            _bannerAd = null;
            setState(() => _isLoaded = false);
            debugPrint('Banner ad failed to load: $error');
            _scheduleRetry(width);
          }
        },
      ),
    );
    _bannerAd = ad;
    _adSize = size;
    setState(() {});
    ad.load();
  }

  @override
  void dispose() {
    _loadGeneration++;
    _retryTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final width = (widget.maxWidth ?? screenWidth - 32)
        .clamp(1.0, screenWidth)
        .floor();
    if (width != _requestedWidth) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadAd(width));
    }

    final size = _adSize;
    final ad = _bannerAd;
    return SizedBox(
      width: width.toDouble(),
      height: (size?.height ?? AdSize.banner.height).toDouble(),
      child: _isLoaded && ad != null && size != null
          ? Center(
              child: SizedBox(
                width: size.width.toDouble(),
                height: size.height.toDouble(),
                child: AdWidget(ad: ad),
              ),
            )
          : null,
    );
  }
}
