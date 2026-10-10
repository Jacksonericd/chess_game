import 'package:flutter/foundation.dart';
import '../../data/repositories/in_memory_chess_repository.dart';
import '../../domain/entities/chess_move.dart';
import '../../domain/entities/chess_piece.dart';
import '../../domain/repositories/chess_repository.dart';
import '../../domain/services/chess_ai_service.dart';

enum GameStatus { playing, check, checkmate, stalemate }

class ChessController extends ChangeNotifier {
  ChessController({
    ChessRepository? repository,
    this.difficulty = AiDifficulty.medium,
  }) : _repository = repository ?? InMemoryChessRepository(),
       _ai = ChessAiService(repository ?? InMemoryChessRepository()) {
    reset();
  }
  final ChessRepository _repository;
  final ChessAiService _ai;
  final AiDifficulty difficulty;
  late List<ChessPiece?> board;
  PieceColor turn = PieceColor.white;
  int? selected;
  List<int> availableMoves = const [];
  final List<ChessMove> moves = [];
  final List<_GameSnapshot> _history = [];
  ChessMove? lastMove;
  bool flipped = false;
  GameStatus status = GameStatus.playing;
  bool isThinking = false;
  int _gameEpoch = 0;
  bool _disposed = false;
  bool whiteKingMoved = false;
  bool whiteRookAMoved = false;
  bool whiteRookHMoved = false;
  bool blackKingMoved = false;
  bool blackRookAMoved = false;
  bool blackRookHMoved = false;
  int? enPassantTarget;

  bool get gameOver =>
      status == GameStatus.checkmate || status == GameStatus.stalemate;
  bool get inCheck => status == GameStatus.check;

  void reset() {
    _gameEpoch++;
    board = _repository.initialBoard();
    turn = PieceColor.white;
    selected = null;
    availableMoves = const [];
    moves.clear();
    _history.clear();
    lastMove = null;
    whiteKingMoved = false;
    whiteRookAMoved = false;
    whiteRookHMoved = false;
    blackKingMoved = false;
    blackRookAMoved = false;
    blackRookHMoved = false;
    enPassantTarget = null;
    status = GameStatus.playing;
    isThinking = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void toggleFlip() {
    flipped = !flipped;
    notifyListeners();
  }

  void undo() {
    if (_history.isEmpty || isThinking) return;
    final undoCount =
        moves.isNotEmpty &&
            moves.last.piece.color == PieceColor.black &&
            _history.length >= 2
        ? 2
        : 1;
    _GameSnapshot snapshot = _history.removeLast();
    if (undoCount == 2) {
      snapshot = _history.removeLast();
    }
    board = List<ChessPiece?>.from(snapshot.board);
    for (var index = 0; index < undoCount && moves.isNotEmpty; index++) {
      moves.removeLast();
    }
    lastMove = moves.isEmpty ? null : moves.last;
    whiteKingMoved = snapshot.whiteKingMoved;
    whiteRookAMoved = snapshot.whiteRookAMoved;
    whiteRookHMoved = snapshot.whiteRookHMoved;
    blackKingMoved = snapshot.blackKingMoved;
    blackRookAMoved = snapshot.blackRookAMoved;
    blackRookHMoved = snapshot.blackRookHMoved;
    enPassantTarget = snapshot.enPassantTarget;
    turn = PieceColor.white;
    selected = null;
    availableMoves = const [];
    _updateStatus();
    notifyListeners();
  }

  void tapSquare(int index) {
    if (gameOver || isThinking || turn != PieceColor.white) return;
    if (selected != null && availableMoves.contains(index)) {
      _move(selected!, index);
      _playComputerMove();
      return;
    }
    final piece = board[index];
    if (piece?.color == turn) {
      selected = index;
      availableMoves = _legalMoves(index, turn);
    } else {
      selected = null;
      availableMoves = const [];
    }
    notifyListeners();
  }

  Future<void> _playComputerMove() async {
    if (gameOver) return;
    isThinking = true;
    notifyListeners();
    final epoch = _gameEpoch;
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (_disposed || epoch != _gameEpoch || gameOver) return;
    final move = _ai.chooseMove(
      board,
      PieceColor.black,
      difficulty: difficulty,
      canCastleKingside: !blackKingMoved && !blackRookHMoved,
      canCastleQueenside: !blackKingMoved && !blackRookAMoved,
      enPassantTarget: enPassantTarget,
    );
    isThinking = false;
    if (move == null) {
      status = GameStatus.stalemate;
      notifyListeners();
      return;
    }
    _move(move.from, move.to);
  }

  void _move(int from, int to) {
    final piece = board[from]!;
    final promotion =
        piece.type == PieceType.pawn && (to ~/ 8 == 0 || to ~/ 8 == 7)
        ? PieceType.queen
        : null;
    final captured = board[to];
    _history.add(
      _GameSnapshot(
        board: board,
        whiteKingMoved: whiteKingMoved,
        whiteRookAMoved: whiteRookAMoved,
        whiteRookHMoved: whiteRookHMoved,
        blackKingMoved: blackKingMoved,
        blackRookAMoved: blackRookAMoved,
        blackRookHMoved: blackRookHMoved,
        enPassantTarget: enPassantTarget,
      ),
    );
    final isCastle = piece.type == PieceType.king && (to - from).abs() == 2;
    final isEnPassant =
        piece.type == PieceType.pawn &&
        captured == null &&
        to == enPassantTarget;
    final move = ChessMove(
      from: from,
      to: to,
      piece: piece,
      captured: captured,
      promotion: promotion,
      rookFrom: isCastle ? (to > from ? from + 3 : from - 4) : null,
      rookTo: isCastle ? (to > from ? from + 1 : from - 1) : null,
      enPassantCapture: isEnPassant
          ? to + (piece.color == PieceColor.white ? 8 : -8)
          : null,
    );
    board = _repository.applyMove(board, move);
    moves.add(move);
    lastMove = move;
    _updateRights(piece, from, to, captured);
    enPassantTarget = piece.type == PieceType.pawn && (to - from).abs() == 16
        ? (from + to) ~/ 2
        : null;
    turn = turn == PieceColor.white ? PieceColor.black : PieceColor.white;
    selected = null;
    availableMoves = const [];
    _updateStatus();
    notifyListeners();
  }

  void _updateStatus() {
    final check = _repository.isInCheck(board, turn);
    if (_repository.hasLegalMove(
      board,
      turn,
      canCastleKingside: turn == PieceColor.white
          ? !whiteKingMoved && !whiteRookHMoved
          : !blackKingMoved && !blackRookHMoved,
      canCastleQueenside: turn == PieceColor.white
          ? !whiteKingMoved && !whiteRookAMoved
          : !blackKingMoved && !blackRookAMoved,
      enPassantTarget: enPassantTarget,
    )) {
      status = check ? GameStatus.check : GameStatus.playing;
    } else {
      status = check ? GameStatus.checkmate : GameStatus.stalemate;
    }
  }

  List<int> _legalMoves(int from, PieceColor color) => _repository.legalMoves(
    board,
    from,
    color,
    canCastleKingside: color == PieceColor.white
        ? !whiteKingMoved && !whiteRookHMoved
        : !blackKingMoved && !blackRookHMoved,
    canCastleQueenside: color == PieceColor.white
        ? !whiteKingMoved && !whiteRookAMoved
        : !blackKingMoved && !blackRookAMoved,
    enPassantTarget: enPassantTarget,
  );

  void _updateRights(ChessPiece piece, int from, int to, ChessPiece? captured) {
    if (piece.color == PieceColor.white) {
      if (piece.type == PieceType.king) whiteKingMoved = true;
      if (from == 56) whiteRookAMoved = true;
      if (from == 63) whiteRookHMoved = true;
    } else {
      if (piece.type == PieceType.king) blackKingMoved = true;
      if (from == 0) blackRookAMoved = true;
      if (from == 7) blackRookHMoved = true;
    }
    if (captured?.type == PieceType.rook) {
      if (to == 56) whiteRookAMoved = true;
      if (to == 63) whiteRookHMoved = true;
      if (to == 0) blackRookAMoved = true;
      if (to == 7) blackRookHMoved = true;
    }
  }
}

class _GameSnapshot {
  const _GameSnapshot({
    required this.board,
    required this.whiteKingMoved,
    required this.whiteRookAMoved,
    required this.whiteRookHMoved,
    required this.blackKingMoved,
    required this.blackRookAMoved,
    required this.blackRookHMoved,
    required this.enPassantTarget,
  });

  final List<ChessPiece?> board;
  final bool whiteKingMoved;
  final bool whiteRookAMoved;
  final bool whiteRookHMoved;
  final bool blackKingMoved;
  final bool blackRookAMoved;
  final bool blackRookHMoved;
  final int? enPassantTarget;
}
