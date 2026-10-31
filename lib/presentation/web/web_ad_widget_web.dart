import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class WebAdWidget extends StatefulWidget {
  const WebAdWidget({required this.slotId, super.key});

  final String slotId;

  @override
  State<WebAdWidget> createState() => _WebAdWidgetState();
}

class _WebAdWidgetState extends State<WebAdWidget> {
  static int _nextViewId = 0;
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'chess-adsense-${_nextViewId++}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
      final container = web.HTMLElement.section()
        ..style.width = '100%'
        ..style.height = '140px'
        ..style.minHeight = '120px';
      final ad = web.document.createElement('ins') as web.HTMLElement
        ..classList.add('adsbygoogle')
        ..setAttribute('style', 'display:block; width:100%;')
        ..setAttribute('data-ad-client', 'ca-pub-1467587305582185')
        ..setAttribute('data-ad-slot', widget.slotId)
        ..setAttribute('data-ad-format', 'auto')
        ..setAttribute('data-full-width-responsive', 'true');
      container.append(ad);
      container.append(
        web.HTMLScriptElement()
          ..text = '''
(function (ad) {
  function requestAd() {
    if (ad && ad.getBoundingClientRect().width > 0) {
      window.adsbygoogle = window.adsbygoogle || [];
      window.adsbygoogle.push({});
      return;
    }
    window.requestAnimationFrame(requestAd);
  }
  window.requestAnimationFrame(requestAd);
})(document.currentScript.previousElementSibling);
''',
      );
      return container;
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 140,
    child: HtmlElementView(viewType: _viewType),
  );
}
