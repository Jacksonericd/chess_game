import '../../domain/entities/chess_move.dart';
import '../../domain/entities/chess_piece.dart';
import '../../domain/repositories/chess_repository.dart';

class InMemoryChessRepository implements ChessRepository {
  @override
  List<ChessPiece?> initialBoard() {
    final board = List<ChessPiece?>.filled(64, null);
    const order = [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ];
    for (var file = 0; file < 8; file++) {
      board[file] = ChessPiece(order[file], PieceColor.black);
      board[8 + file] = const ChessPiece(PieceType.pawn, PieceColor.black);
      board[48 + file] = const ChessPiece(PieceType.pawn, PieceColor.white);
      board[56 + file] = ChessPiece(order[file], PieceColor.white);
    }
    return board;
  }

  @override
  List<ChessPiece?> applyMove(List<ChessPiece?> board, ChessMove move) {
    final next = List<ChessPiece?>.from(board);
    next[move.to] = move.promotion == null
        ? move.piece
        : move.piece.copyWith(type: move.promotion);
    next[move.from] = null;
    if (move.isCastle) {
      next[move.rookTo!] = next[move.rookFrom!];
      next[move.rookFrom!] = null;
    }
    if (move.isEnPassant) {
      next[move.enPassantCapture!] = null;
    }
    return next;
  }

  @override
  List<int> legalMoves(
    List<ChessPiece?> board,
    int from,
    PieceColor turn, {
    bool canCastleKingside = false,
    bool canCastleQueenside = false,
    int? enPassantTarget,
  }) {
    final piece = board[from];
    if (piece == null || piece.color != turn) return const [];
    final pseudoMoves = _pseudoLegalMoves(
      board,
      from,
      turn,
      enPassantTarget: enPassantTarget,
    );
    final legal = pseudoMoves.where((to) {
      if (board[to]?.type == PieceType.king) return false;
      final move = _createMove(
        board,
        from,
        to,
        enPassantTarget: enPassantTarget,
      );
      return !isInCheck(applyMove(board, move), turn);
    }).toList();
    legal.addAll(
      _castleMoves(
        board,
        from,
        turn,
        canCastleKingside: canCastleKingside,
        canCastleQueenside: canCastleQueenside,
      ),
    );
    return legal;
  }

  @override
  bool isInCheck(List<ChessPiece?> board, PieceColor color) {
    final king = board.indexWhere(
      (piece) => piece?.type == PieceType.king && piece?.color == color,
    );
    if (king == -1) return true;
    final opponent = color == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;
    for (var from = 0; from < board.length; from++) {
      if (board[from]?.color == opponent &&
          _pseudoLegalMoves(board, from, opponent).contains(king)) {
        return true;
      }
    }
    return false;
  }

  @override
  bool hasLegalMove(
    List<ChessPiece?> board,
    PieceColor color, {
    bool canCastleKingside = false,
    bool canCastleQueenside = false,
    int? enPassantTarget,
  }) {
    for (var from = 0; from < board.length; from++) {
      if (board[from]?.color == color &&
          legalMoves(
            board,
            from,
            color,
            canCastleKingside: canCastleKingside,
            canCastleQueenside: canCastleQueenside,
            enPassantTarget: enPassantTarget,
          ).isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  List<int> _pseudoLegalMoves(
    List<ChessPiece?> board,
    int from,
    PieceColor turn, {
    int? enPassantTarget,
  }) {
    final piece = board[from];
    if (piece == null || piece.color != turn) return const [];
    final row = from ~/ 8;
    final col = from % 8;
    final targets = <int>[];
    void add(int r, int c) {
      if (r < 0 || r > 7 || c < 0 || c > 7) return;
      final index = r * 8 + c;
      if (board[index]?.color != turn) targets.add(index);
    }

    void ray(int dr, int dc) {
      var r = row + dr;
      var c = col + dc;
      while (r >= 0 && r < 8 && c >= 0 && c < 8) {
        final index = r * 8 + c;
        if (board[index] == null) {
          targets.add(index);
        } else {
          if (board[index]!.color != turn) targets.add(index);
          break;
        }
        r += dr;
        c += dc;
      }
    }

    switch (piece.type) {
      case PieceType.pawn:
        final direction = piece.color == PieceColor.white ? -1 : 1;
        final start = piece.color == PieceColor.white ? 6 : 1;
        final next = row + direction;
        if (next >= 0 && next < 8 && board[next * 8 + col] == null) {
          targets.add(next * 8 + col);
          final jump = row + direction * 2;
          if (row == start && board[jump * 8 + col] == null) {
            targets.add(jump * 8 + col);
          }
        }
        for (final dc in [-1, 1]) {
          final c = col + dc;
          if (next >= 0 && next < 8 && c >= 0 && c < 8) {
            final index = next * 8 + c;
            if ((board[index] != null && board[index]!.color != turn) ||
                (board[index] == null && index == enPassantTarget)) {
              targets.add(index);
            }
          }
        }
      case PieceType.knight:
        for (final move in [
          [-2, -1],
          [-2, 1],
          [-1, -2],
          [-1, 2],
          [1, -2],
          [1, 2],
          [2, -1],
          [2, 1],
        ]) {
          add(row + move[0], col + move[1]);
        }
      case PieceType.bishop:
        ray(-1, -1);
        ray(-1, 1);
        ray(1, -1);
        ray(1, 1);
      case PieceType.rook:
        ray(-1, 0);
        ray(1, 0);
        ray(0, -1);
        ray(0, 1);
      case PieceType.queen:
        ray(-1, -1);
        ray(-1, 1);
        ray(1, -1);
        ray(1, 1);
        ray(-1, 0);
        ray(1, 0);
        ray(0, -1);
        ray(0, 1);
      case PieceType.king:
        for (var dr = -1; dr <= 1; dr++) {
          for (var dc = -1; dc <= 1; dc++) {
            if (dr != 0 || dc != 0) add(row + dr, col + dc);
          }
        }
    }
    return targets;
  }

  ChessMove _createMove(
    List<ChessPiece?> board,
    int from,
    int to, {
    int? enPassantTarget,
  }) {
    final piece = board[from]!;
    final isEnPassant =
        piece.type == PieceType.pawn &&
        board[to] == null &&
        to == enPassantTarget;
    final captureSquare = isEnPassant
        ? to + (piece.color == PieceColor.white ? 8 : -8)
        : null;
    return ChessMove(
      from: from,
      to: to,
      piece: piece,
      captured:
          board[to] ?? (captureSquare == null ? null : board[captureSquare]),
      enPassantCapture: captureSquare,
    );
  }

  List<int> _castleMoves(
    List<ChessPiece?> board,
    int from,
    PieceColor color, {
    required bool canCastleKingside,
    required bool canCastleQueenside,
  }) {
    final kingStart = color == PieceColor.white ? 60 : 4;
    if (from != kingStart ||
        board[from]?.type != PieceType.king ||
        isInCheck(board, color)) {
      return const [];
    }
    final row = color == PieceColor.white ? 7 : 0;
    final result = <int>[];
    if (canCastleKingside) {
      final rook = row * 8 + 7;
      final through = row * 8 + 5;
      final destination = row * 8 + 6;
      if (board[rook]?.type == PieceType.rook &&
          board[rook]?.color == color &&
          board[through] == null &&
          board[destination] == null &&
          !isInCheck(
            applyMove(
              board,
              ChessMove(from: from, to: through, piece: board[from]!),
            ),
            color,
          ) &&
          !isInCheck(
            applyMove(
              board,
              ChessMove(
                from: from,
                to: destination,
                piece: board[from]!,
                rookFrom: rook,
                rookTo: through,
              ),
            ),
            color,
          )) {
        result.add(destination);
      }
    }
    if (canCastleQueenside) {
      final rook = row * 8;
      final through = row * 8 + 3;
      final destination = row * 8 + 2;
      if (board[rook]?.type == PieceType.rook &&
          board[rook]?.color == color &&
          board[through] == null &&
          board[destination] == null &&
          board[row * 8 + 1] == null &&
          !isInCheck(
            applyMove(
              board,
              ChessMove(from: from, to: through, piece: board[from]!),
            ),
            color,
          ) &&
          !isInCheck(
            applyMove(
              board,
              ChessMove(
                from: from,
                to: destination,
                piece: board[from]!,
                rookFrom: rook,
                rookTo: through,
              ),
            ),
            color,
          )) {
        result.add(destination);
      }
    }
    return result;
  }
}
