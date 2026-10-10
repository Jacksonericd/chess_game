import 'chess_piece.dart';

class ChessMove {
  const ChessMove({
    required this.from,
    required this.to,
    required this.piece,
    this.captured,
    this.promotion,
    this.rookFrom,
    this.rookTo,
    this.enPassantCapture,
  });

  final int from;
  final int to;
  final ChessPiece piece;
  final ChessPiece? captured;
  final PieceType? promotion;
  final int? rookFrom;
  final int? rookTo;
  final int? enPassantCapture;

  bool get isCastle => rookFrom != null && rookTo != null;
  bool get isEnPassant => enPassantCapture != null;

  String get notation => '${_square(from)}–${_square(to)}';

  static String _square(int index) =>
      '${String.fromCharCode(97 + index % 8)}${8 - index ~/ 8}';
}
