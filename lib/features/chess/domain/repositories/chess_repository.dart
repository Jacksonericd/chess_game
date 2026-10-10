import '../entities/chess_move.dart';
import '../entities/chess_piece.dart';

abstract interface class ChessRepository {
  List<ChessPiece?> initialBoard();
  List<int> legalMoves(
    List<ChessPiece?> board,
    int from,
    PieceColor turn, {
    bool canCastleKingside = false,
    bool canCastleQueenside = false,
    int? enPassantTarget,
  });
  List<ChessPiece?> applyMove(List<ChessPiece?> board, ChessMove move);
  bool isInCheck(List<ChessPiece?> board, PieceColor color);
  bool hasLegalMove(
    List<ChessPiece?> board,
    PieceColor color, {
    bool canCastleKingside = false,
    bool canCastleQueenside = false,
    int? enPassantTarget,
  });
}
