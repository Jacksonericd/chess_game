import 'package:flutter_test/flutter_test.dart';

import 'package:chess_app/features/chess/data/repositories/in_memory_chess_repository.dart';
import 'package:chess_app/features/chess/domain/entities/chess_piece.dart';
import 'package:chess_app/features/chess/domain/services/chess_ai_service.dart';

void main() {
  final repository = InMemoryChessRepository();

  List<ChessPiece?> boardWith({
    required int whiteKing,
    required int blackKing,
    Map<int, ChessPiece> pieces = const {},
  }) {
    final board = List<ChessPiece?>.filled(64, null);
    board[whiteKing] = const ChessPiece(PieceType.king, PieceColor.white);
    board[blackKing] = const ChessPiece(PieceType.king, PieceColor.black);
    pieces.forEach((index, piece) => board[index] = piece);
    return board;
  }

  test('initial position exposes correct pawn and knight moves', () {
    final board = repository.initialBoard();
    expect(
      repository.legalMoves(board, 52, PieceColor.white),
      containsAll([44, 36]),
    );
    expect(
      repository.legalMoves(board, 57, PieceColor.white),
      containsAll([40, 42]),
    );
    expect(repository.legalMoves(board, 58, PieceColor.white), isEmpty);
    expect(repository.legalMoves(board, 59, PieceColor.white), isEmpty);
  });

  test('queen and bishop slide until the first occupied square', () {
    final board = boardWith(
      whiteKing: 60,
      blackKing: 4,
      pieces: {
        27: const ChessPiece(PieceType.queen, PieceColor.white),
        18: const ChessPiece(PieceType.bishop, PieceColor.white),
        11: const ChessPiece(PieceType.pawn, PieceColor.white),
      },
    );
    final queenMoves = repository.legalMoves(board, 27, PieceColor.white);
    expect(queenMoves, contains(19));
    expect(queenMoves, isNot(contains(3)));
    expect(queenMoves, isNot(contains(11)));
    expect(repository.legalMoves(board, 18, PieceColor.white), contains(9));
  });

  test('king cannot move into check or leave itself in check', () {
    final board = boardWith(
      whiteKing: 60,
      blackKing: 4,
      pieces: {
        4: const ChessPiece(PieceType.king, PieceColor.black),
        12: const ChessPiece(PieceType.rook, PieceColor.black),
      },
    );
    expect(repository.isInCheck(board, PieceColor.white), isTrue);
    expect(
      repository.legalMoves(board, 60, PieceColor.white),
      isNot(contains(52)),
    );
  });

  test('castling requires a clear, safe route', () {
    final board = boardWith(
      whiteKing: 60,
      blackKing: 4,
      pieces: {63: const ChessPiece(PieceType.rook, PieceColor.white)},
    );
    expect(
      repository.legalMoves(
        board,
        60,
        PieceColor.white,
        canCastleKingside: true,
      ),
      contains(62),
    );
    final blocked = List<ChessPiece?>.from(board)
      ..[61] = const ChessPiece(PieceType.bishop, PieceColor.white);
    expect(
      repository.legalMoves(
        blocked,
        60,
        PieceColor.white,
        canCastleKingside: true,
      ),
      isNot(contains(62)),
    );
  });

  test('en passant is available only on the target square', () {
    final board = boardWith(
      whiteKing: 60,
      blackKing: 4,
      pieces: {
        28: const ChessPiece(PieceType.pawn, PieceColor.white),
        27: const ChessPiece(PieceType.pawn, PieceColor.black),
      },
    );
    expect(
      repository.legalMoves(board, 28, PieceColor.white, enPassantTarget: 19),
      contains(19),
    );
  });

  test('checkmate and stalemate are distinguished', () {
    final mate = boardWith(
      whiteKing: 21,
      blackKing: 7,
      pieces: {14: const ChessPiece(PieceType.queen, PieceColor.white)},
    );
    expect(repository.isInCheck(mate, PieceColor.black), isTrue);
    expect(repository.hasLegalMove(mate, PieceColor.black), isFalse);

    final stalemate = boardWith(
      whiteKing: 21,
      blackKing: 7,
      pieces: {22: const ChessPiece(PieceType.queen, PieceColor.white)},
    );
    expect(repository.isInCheck(stalemate, PieceColor.black), isFalse);
    expect(repository.hasLegalMove(stalemate, PieceColor.black), isFalse);
  });

  test('computer only chooses legal moves', () {
    final board = repository.initialBoard();
    final move = ChessAiService(repository).chooseMove(board, PieceColor.black);
    expect(move, isNotNull);
    expect(
      repository.legalMoves(board, move!.from, PieceColor.black),
      contains(move.to),
    );
  });
}
