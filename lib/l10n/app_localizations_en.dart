// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Chess';

  @override
  String get brandName => 'CHESS';

  @override
  String get appSuffix => 'APP';

  @override
  String get brandTagline => 'CLASSIC BOARD';

  @override
  String get opponent => 'Opponent';

  @override
  String get computer => 'Computer';

  @override
  String get you => 'You';

  @override
  String get black => 'BLACK';

  @override
  String get white => 'WHITE';

  @override
  String get yourTurn => 'YOUR TURN';

  @override
  String get gameOver => 'Game over';

  @override
  String movesCount(int count) {
    return '$count MOVES';
  }

  @override
  String get undo => 'Undo';

  @override
  String get rotate => 'Rotate';

  @override
  String get newGame => 'New game';

  @override
  String levelLabel(int level) {
    return 'LEVEL $level';
  }

  @override
  String get whiteToMove => 'White to move';

  @override
  String get blackToMove => 'Black to move';

  @override
  String get computerThinking => 'Computer is thinking...';

  @override
  String get chooseDifficulty => 'Choose your opponent\'s difficulty';

  @override
  String get startGame => 'START GAME';

  @override
  String get levelOne => 'Level 1 · Beginner';

  @override
  String get levelOneDescription => 'Casual moves with minimal strategy';

  @override
  String get levelTwo => 'Level 2 · Easy';

  @override
  String get levelTwoDescription => 'Looks for simple captures';

  @override
  String get levelThree => 'Level 3 · Medium';

  @override
  String get levelThreeDescription => 'Captures pieces and controls the center';

  @override
  String get levelFour => 'Level 4 · Hard';

  @override
  String get levelFourDescription => 'Thinks ahead with a deeper search';

  @override
  String get levelFive => 'Level 5 · Expert';

  @override
  String get levelFiveDescription => 'Strongest available computer play';

  @override
  String get check => 'CHECK';

  @override
  String get checkmate => 'CHECKMATE';

  @override
  String get checkmateWhiteWins => 'CHECKMATE — YOU WIN';

  @override
  String get checkmateBlackWins => 'CHECKMATE — COMPUTER WINS';

  @override
  String get stalemate => 'STALEMATE — DRAW';

  @override
  String get playSolo => 'PLAY SOLO';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get startPlaying => 'Start playing';

  @override
  String get play => 'Play';

  @override
  String get availableOnGooglePlay => 'AVAILABLE ON GOOGLE PLAY';

  @override
  String get androidApp => 'Android app';

  @override
  String get chessForAndroid => 'Chess for Android';

  @override
  String get getTheApp => 'Get the app';

  @override
  String get quietPlaceToPlay => 'A QUIET PLACE TO PLAY';

  @override
  String get heroTitle => 'Think ahead.\nMake your move.';

  @override
  String get heroDescription =>
      'A focused chess game against a computer opponent, with five levels, a readable board, and no account required.';

  @override
  String get playAMatch => 'Play a match';

  @override
  String get levels => 'levels';

  @override
  String get boardViews => 'board views';

  @override
  String get signUps => 'sign-ups';

  @override
  String get yourBoard => 'YOUR BOARD';

  @override
  String get simpleMatchFlow => 'A simple match flow';

  @override
  String get chooseLevel => 'Choose a level';

  @override
  String get chooseLevelDescription => 'Pick the opponent that fits your mood.';

  @override
  String get readBoard => 'Read the board';

  @override
  String get readBoardDescription => 'Select a piece to see its legal moves.';

  @override
  String get playItThrough => 'Play it through';

  @override
  String get playItThroughDescription =>
      'Undo or rotate whenever you need a new view.';

  @override
  String get takeBoardWithYou => 'Take the board with you.';

  @override
  String get androidAvailability =>
      'The Android app is available on Google Play for games away from the browser.';

  @override
  String get openGooglePlay => 'Open Google Play';

  @override
  String get liveMatch => 'LIVE MATCH';

  @override
  String get leaveMatch => 'Leave match';

  @override
  String get setUpMatch => 'Set up a match';

  @override
  String get chooseComputerDifficulty =>
      'Choose how hard the computer should play.';

  @override
  String get openBoard => 'Open board';

  @override
  String get playAgain => 'Play again';

  @override
  String get checkmateComputerWins => 'Checkmate · Computer wins';

  @override
  String get checkmateYouWin => 'Checkmate · You win';

  @override
  String get stalemateDraw => 'Stalemate · Draw';

  @override
  String get yourMove => 'Your move';

  @override
  String get footerTagline => 'CHESS · A focused single-player board';
}
