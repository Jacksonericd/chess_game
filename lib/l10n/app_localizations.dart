import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Chess'**
  String get appTitle;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'CHESS'**
  String get brandName;

  /// No description provided for @appSuffix.
  ///
  /// In en, this message translates to:
  /// **'APP'**
  String get appSuffix;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'CLASSIC BOARD'**
  String get brandTagline;

  /// No description provided for @opponent.
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get opponent;

  /// No description provided for @computer.
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get computer;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'BLACK'**
  String get black;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'WHITE'**
  String get white;

  /// No description provided for @yourTurn.
  ///
  /// In en, this message translates to:
  /// **'YOUR TURN'**
  String get yourTurn;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game over'**
  String get gameOver;

  /// No description provided for @movesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} MOVES'**
  String movesCount(int count);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @rotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotate;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get newGame;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {level}'**
  String levelLabel(int level);

  /// No description provided for @whiteToMove.
  ///
  /// In en, this message translates to:
  /// **'White to move'**
  String get whiteToMove;

  /// No description provided for @blackToMove.
  ///
  /// In en, this message translates to:
  /// **'Black to move'**
  String get blackToMove;

  /// No description provided for @computerThinking.
  ///
  /// In en, this message translates to:
  /// **'Computer is thinking...'**
  String get computerThinking;

  /// No description provided for @chooseDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Choose your opponent\'s difficulty'**
  String get chooseDifficulty;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'START GAME'**
  String get startGame;

  /// No description provided for @levelOne.
  ///
  /// In en, this message translates to:
  /// **'Level 1 · Beginner'**
  String get levelOne;

  /// No description provided for @levelOneDescription.
  ///
  /// In en, this message translates to:
  /// **'Casual moves with minimal strategy'**
  String get levelOneDescription;

  /// No description provided for @levelTwo.
  ///
  /// In en, this message translates to:
  /// **'Level 2 · Easy'**
  String get levelTwo;

  /// No description provided for @levelTwoDescription.
  ///
  /// In en, this message translates to:
  /// **'Looks for simple captures'**
  String get levelTwoDescription;

  /// No description provided for @levelThree.
  ///
  /// In en, this message translates to:
  /// **'Level 3 · Medium'**
  String get levelThree;

  /// No description provided for @levelThreeDescription.
  ///
  /// In en, this message translates to:
  /// **'Captures pieces and controls the center'**
  String get levelThreeDescription;

  /// No description provided for @levelFour.
  ///
  /// In en, this message translates to:
  /// **'Level 4 · Hard'**
  String get levelFour;

  /// No description provided for @levelFourDescription.
  ///
  /// In en, this message translates to:
  /// **'Thinks ahead with a deeper search'**
  String get levelFourDescription;

  /// No description provided for @levelFive.
  ///
  /// In en, this message translates to:
  /// **'Level 5 · Expert'**
  String get levelFive;

  /// No description provided for @levelFiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Strongest available computer play'**
  String get levelFiveDescription;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'CHECK'**
  String get check;

  /// No description provided for @checkmate.
  ///
  /// In en, this message translates to:
  /// **'CHECKMATE'**
  String get checkmate;

  /// No description provided for @checkmateWhiteWins.
  ///
  /// In en, this message translates to:
  /// **'CHECKMATE — YOU WIN'**
  String get checkmateWhiteWins;

  /// No description provided for @checkmateBlackWins.
  ///
  /// In en, this message translates to:
  /// **'CHECKMATE — COMPUTER WINS'**
  String get checkmateBlackWins;

  /// No description provided for @stalemate.
  ///
  /// In en, this message translates to:
  /// **'STALEMATE — DRAW'**
  String get stalemate;

  /// No description provided for @playSolo.
  ///
  /// In en, this message translates to:
  /// **'PLAY SOLO'**
  String get playSolo;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @startPlaying.
  ///
  /// In en, this message translates to:
  /// **'Start playing'**
  String get startPlaying;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @availableOnGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE ON GOOGLE PLAY'**
  String get availableOnGooglePlay;

  /// No description provided for @androidApp.
  ///
  /// In en, this message translates to:
  /// **'Android app'**
  String get androidApp;

  /// No description provided for @chessForAndroid.
  ///
  /// In en, this message translates to:
  /// **'Chess for Android'**
  String get chessForAndroid;

  /// No description provided for @getTheApp.
  ///
  /// In en, this message translates to:
  /// **'Get the app'**
  String get getTheApp;

  /// No description provided for @quietPlaceToPlay.
  ///
  /// In en, this message translates to:
  /// **'A QUIET PLACE TO PLAY'**
  String get quietPlaceToPlay;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Think ahead.\nMake your move.'**
  String get heroTitle;

  /// No description provided for @heroDescription.
  ///
  /// In en, this message translates to:
  /// **'A focused chess game against a computer opponent, with five levels, a readable board, and no account required.'**
  String get heroDescription;

  /// No description provided for @playAMatch.
  ///
  /// In en, this message translates to:
  /// **'Play a match'**
  String get playAMatch;

  /// No description provided for @levels.
  ///
  /// In en, this message translates to:
  /// **'levels'**
  String get levels;

  /// No description provided for @boardViews.
  ///
  /// In en, this message translates to:
  /// **'board views'**
  String get boardViews;

  /// No description provided for @signUps.
  ///
  /// In en, this message translates to:
  /// **'sign-ups'**
  String get signUps;

  /// No description provided for @yourBoard.
  ///
  /// In en, this message translates to:
  /// **'YOUR BOARD'**
  String get yourBoard;

  /// No description provided for @simpleMatchFlow.
  ///
  /// In en, this message translates to:
  /// **'A simple match flow'**
  String get simpleMatchFlow;

  /// No description provided for @chooseLevel.
  ///
  /// In en, this message translates to:
  /// **'Choose a level'**
  String get chooseLevel;

  /// No description provided for @chooseLevelDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick the opponent that fits your mood.'**
  String get chooseLevelDescription;

  /// No description provided for @readBoard.
  ///
  /// In en, this message translates to:
  /// **'Read the board'**
  String get readBoard;

  /// No description provided for @readBoardDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a piece to see its legal moves.'**
  String get readBoardDescription;

  /// No description provided for @playItThrough.
  ///
  /// In en, this message translates to:
  /// **'Play it through'**
  String get playItThrough;

  /// No description provided for @playItThroughDescription.
  ///
  /// In en, this message translates to:
  /// **'Undo or rotate whenever you need a new view.'**
  String get playItThroughDescription;

  /// No description provided for @takeBoardWithYou.
  ///
  /// In en, this message translates to:
  /// **'Take the board with you.'**
  String get takeBoardWithYou;

  /// No description provided for @androidAvailability.
  ///
  /// In en, this message translates to:
  /// **'The Android app is available on Google Play for games away from the browser.'**
  String get androidAvailability;

  /// No description provided for @openGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Open Google Play'**
  String get openGooglePlay;

  /// No description provided for @liveMatch.
  ///
  /// In en, this message translates to:
  /// **'LIVE MATCH'**
  String get liveMatch;

  /// No description provided for @leaveMatch.
  ///
  /// In en, this message translates to:
  /// **'Leave match'**
  String get leaveMatch;

  /// No description provided for @setUpMatch.
  ///
  /// In en, this message translates to:
  /// **'Set up a match'**
  String get setUpMatch;

  /// No description provided for @chooseComputerDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Choose how hard the computer should play.'**
  String get chooseComputerDifficulty;

  /// No description provided for @openBoard.
  ///
  /// In en, this message translates to:
  /// **'Open board'**
  String get openBoard;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @checkmateComputerWins.
  ///
  /// In en, this message translates to:
  /// **'Checkmate · Computer wins'**
  String get checkmateComputerWins;

  /// No description provided for @checkmateYouWin.
  ///
  /// In en, this message translates to:
  /// **'Checkmate · You win'**
  String get checkmateYouWin;

  /// No description provided for @stalemateDraw.
  ///
  /// In en, this message translates to:
  /// **'Stalemate · Draw'**
  String get stalemateDraw;

  /// No description provided for @yourMove.
  ///
  /// In en, this message translates to:
  /// **'Your move'**
  String get yourMove;

  /// No description provided for @footerTagline.
  ///
  /// In en, this message translates to:
  /// **'CHESS · A focused single-player board'**
  String get footerTagline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
