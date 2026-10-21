import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';

import 'core/services/app_open_ad_manager.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'features/chess/presentation/screens/game_setup_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await MobileAds.instance.initialize();

  runApp(const ChessApp());
}

class ChessApp extends StatefulWidget {
  const ChessApp({super.key});

  @override
  State<ChessApp> createState() => _ChessAppState();
}

class _ChessAppState extends State<ChessApp> {
  late final AppOpenAdManager _appOpenAdManager;
  StreamSubscription<AppState>? _appStateSubscription;

  @override
  void initState() {
    super.initState();
    _appOpenAdManager = AppOpenAdManager();
    _appStateSubscription = AppStateEventNotifier.appStateStream.listen((
      state,
    ) {
      if (state == AppState.foreground) {
        _appOpenAdManager.showAdIfAvailable();
      }
    });
    AppStateEventNotifier.startListening();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appOpenAdManager.loadAd(showWhenLoaded: true);
    });
  }

  @override
  void dispose() {
    _appStateSubscription?.cancel();
    AppStateEventNotifier.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.dark(),
    home: UpgradeAlert(
      barrierDismissible: false,
      showIgnore: false,
      showLater: false,
      shouldPopScope: () => false,
      child: const GameSetupScreen(),
    ),
  );
}
