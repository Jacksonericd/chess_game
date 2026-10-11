import '../entities/chess_move.dart';
import '../entities/chess_piece.dart';
import '../repositories/chess_repository.dart';

enum AiDifficulty { beginner, easy, medium, hard, expert }

class ChessAiService {
  const ChessAiService(this._repository);

  final ChessRepository _repository;

  ChessMove? chooseMove(
    List<ChessPiece?> board,
    PieceColor color, {
    AiDifficulty difficulty = AiDifficulty.medium,
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
    if (difficulty == AiDifficulty.beginner) {
      return candidates[candidates.length ~/ 2];
    }
    candidates.sort((a, b) => _score(b).compareTo(_score(a)));
    // A greedy material-only move is particularly bad in chess: it will
    // happily move a queen onto a square where the opponent can capture it
    // next turn. Even the easier levels should look at the opponent's reply.
    final depth = switch (difficulty) {
      AiDifficulty.easy => 2,
      AiDifficulty.medium => 3,
      AiDifficulty.hard => 4,
      AiDifficulty.expert => 4,
      AiDifficulty.beginner => 1,
    };
    return _minimaxMove(board, color, candidates, depth);
  }

  ChessMove _minimaxMove(
    List<ChessPiece?> board,
    PieceColor color,
    List<ChessMove> moves,
    int depth,
  ) {
    var bestMove = moves.first;
    var bestScore = -100000;
    for (final move in moves) {
      final score = _search(
        _repository.applyMove(board, move),
        color == PieceColor.white ? PieceColor.black : PieceColor.white,
        color,
        depth - 1,
        -100000,
        100000,
      );
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    return bestMove;
  }

  int _search(
    List<ChessPiece?> board,
    PieceColor turn,
    PieceColor maximizingColor,
    int depth,
    int alpha,
    int beta,
  ) {
    if (depth == 0) return _evaluate(board, maximizingColor);
    final moves = <ChessMove>[];
    for (var from = 0; from < board.length; from++) {
      final piece = board[from];
      if (piece?.color != turn) continue;
      for (final to in _repository.legalMoves(board, from, turn)) {
        moves.add(
          ChessMove(from: from, to: to, piece: piece!, captured: board[to]),
        );
      }
    }
    if (moves.isEmpty) {
      return _repository.isInCheck(board, turn)
          ? (turn == maximizingColor ? -10000 : 10000)
          : 0;
    }
    final maximizing = turn == maximizingColor;
    var best = maximizing ? -100000 : 100000;
    for (final move in moves) {
      final score = _search(
        _repository.applyMove(board, move),
        turn == PieceColor.white ? PieceColor.black : PieceColor.white,
        maximizingColor,
        depth - 1,
        alpha,
        beta,
      );
      if (maximizing) {
        best = _max(best, score);
        alpha = _max(alpha, best);
      } else {
        best = _min(best, score);
        beta = _min(beta, best);
      }
      if (beta <= alpha) break;
    }
    return best;
  }

  int _max(int first, int second) => first > second ? first : second;
  int _min(int first, int second) => first < second ? first : second;

  int _evaluate(List<ChessPiece?> board, PieceColor color) {
    const values = {
      PieceType.pawn: 100,
      PieceType.knight: 320,
      PieceType.bishop: 330,
      PieceType.rook: 500,
      PieceType.queen: 900,
      PieceType.king: 20000,
    };
    var score = 0;
    for (var index = 0; index < board.length; index++) {
      final piece = board[index];
      if (piece == null) continue;
      final value = values[piece.type]!;
      final signedValue = piece.color == color ? value : -value;
      final positional = _positionalBonus(piece, index);
      score += signedValue + (piece.color == color ? positional : -positional);
    }
    for (var index = 0; index < board.length; index++) {
      final piece = board[index];
      if (piece == null) continue;
      final row = index ~/ 8;
      final column = index % 8;
      if (row >= 2 && row <= 5 && column >= 2 && column <= 5) {
        score += piece.color == color ? 8 : -8;
      }
    }
    return score;
  }

  int _positionalBonus(ChessPiece piece, int index) {
    final row = index ~/ 8;
    final column = index % 8;
    final distanceFromCenter = (row - 3.5).abs() + (column - 3.5).abs();
    final centerBonus = (7 - distanceFromCenter).round();
    switch (piece.type) {
      case PieceType.pawn:
        final progress = piece.color == PieceColor.white ? 6 - row : row - 1;
        return progress * 4 + centerBonus;
      case PieceType.knight:
      case PieceType.bishop:
        return centerBonus * 3;
      case PieceType.queen:
        return centerBonus;
      case PieceType.rook:
        return row == (piece.color == PieceColor.white ? 1 : 6) ? 8 : 0;
      case PieceType.king:
        // Keep the king away from the centre in the middlegame.
        return -centerBonus * 2;
    }
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
