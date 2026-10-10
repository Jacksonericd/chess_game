import '../entities/chess_move.dart';
import '../entities/chess_piece.dart';
import '../repositories/chess_repository.dart';

class ChessAiService {
  const ChessAiService(this._repository);

  final ChessRepository _repository;

  ChessMove? chooseMove(
    List<ChessPiece?> board,
    PieceColor color, {
    bool canCastleKingside = false,
    bool canCastleQueenside = false,
    int? enPassantTarget,
  }) {
    final candidates = <ChessMove>[];
    for (var from = 0; from < board.length; from++) {
      final piece = board[from];
      if (piece?.color != color) continue;
      final movingPiece = piece!;
      for (final to in _repository.legalMoves(
        board,
        from,
        color,
        canCastleKingside: canCastleKingside,
        canCastleQueenside: canCastleQueenside,
        enPassantTarget: enPassantTarget,
      )) {
        final isCastle =
            movingPiece.type == PieceType.king && (to - from).abs() == 2;
        final isEnPassant =
            movingPiece.type == PieceType.pawn &&
            board[to] == null &&
            to == enPassantTarget;
        candidates.add(
          ChessMove(
            from: from,
            to: to,
            piece: movingPiece,
            captured: board[to],
            promotion:
                movingPiece.type == PieceType.pawn &&
                    (to ~/ 8 == 0 || to ~/ 8 == 7)
                ? PieceType.queen
                : null,
            rookFrom: isCastle ? (to > from ? from + 3 : from - 4) : null,
            rookTo: isCastle ? (to > from ? from + 1 : from - 1) : null,
            enPassantCapture: isEnPassant
                ? to + (movingPiece.color == PieceColor.white ? 8 : -8)
                : null,
          ),
        );
      }
    }
    if (candidates.isEmpty) return null;
    candidates.sort((a, b) => _score(b).compareTo(_score(a)));
    return candidates.first;
  }

  int _score(ChessMove move) {
    const values = {
      PieceType.pawn: 1,
      PieceType.knight: 3,
      PieceType.bishop: 3,
      PieceType.rook: 5,
      PieceType.queen: 9,
      PieceType.king: 100,
    };
    var score = values[move.captured?.type] ?? 0;
    final row = move.to ~/ 8;
    final column = move.to % 8;
    if (row >= 2 && row <= 5 && column >= 2 && column <= 5) score += 1;
    if (move.promotion != null) score += 8;
    return score;
  }
}
