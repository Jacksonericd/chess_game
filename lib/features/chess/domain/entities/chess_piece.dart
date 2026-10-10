enum PieceColor { white, black }

enum PieceType { king, queen, rook, bishop, knight, pawn }

class ChessPiece {
  const ChessPiece(this.type, this.color);

  final PieceType type;
  final PieceColor color;

  String get symbol {
    const symbols = {
      PieceType.king: '♚︎',
      PieceType.queen: '♛︎',
      PieceType.rook: '♜︎',
      PieceType.bishop: '♝︎',
      PieceType.knight: '♞︎',
      PieceType.pawn: '♟︎',
    };
    return symbols[type]!;
  }

  ChessPiece copyWith({PieceType? type, PieceColor? color}) =>
      ChessPiece(type ?? this.type, color ?? this.color);
}
