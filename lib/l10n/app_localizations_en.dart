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
  String get checkmateWhiteWins => 'CHECKMATE — YOU WIN';

  @override
  String get checkmateBlackWins => 'CHECKMATE — COMPUTER WINS';

  @override
  String get stalemate => 'STALEMATE — DRAW';
}
