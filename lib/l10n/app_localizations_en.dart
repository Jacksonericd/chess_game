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
  String get check => 'CHECK';

  @override
  String get checkmateWhiteWins => 'CHECKMATE — YOU WIN';

  @override
  String get checkmateBlackWins => 'CHECKMATE — COMPUTER WINS';

  @override
  String get stalemate => 'STALEMATE — DRAW';
}
