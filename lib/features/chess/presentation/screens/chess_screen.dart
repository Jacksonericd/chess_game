import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/chess_piece.dart';
import '../controllers/chess_controller.dart';

class ChessScreen extends StatefulWidget {
  const ChessScreen({super.key});

  @override
  State<ChessScreen> createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> {
  late final ChessController controller;

  @override
  void initState() {
    super.initState();
    controller = ChessController()..addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(_refresh);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boardSize = (constraints.maxWidth - 32).clamp(280.0, 620.0);
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Center(
                child: SizedBox(
                  width: boardSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(l10n),
                      const SizedBox(height: 26),
                      _player(l10n, PieceColor.black, Icons.computer_outlined),
                      const SizedBox(height: 12),
                      _board(boardSize),
                      const SizedBox(height: 12),
                      _player(l10n, PieceColor.white, Icons.person_outline),
                      const SizedBox(height: 24),
                      _gameInfo(l10n),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(AppLocalizations l10n) => Row(
    children: [
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Icon(Icons.auto_awesome, color: AppColors.blackPiece),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.brandName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.brandTagline,
              style: const TextStyle(
                color: AppColors.textSubtle,
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      IconButton(
        onPressed: controller.toggleFlip,
        icon: const Icon(Icons.flip, color: AppColors.accent),
      ),
      IconButton(
        onPressed: controller.reset,
        icon: const Icon(Icons.refresh, color: AppColors.accent),
      ),
    ],
  );

  Widget _player(AppLocalizations l10n, PieceColor color, IconData icon) {
    final active =
        color == PieceColor.white &&
        controller.turn == color &&
        !controller.gameOver &&
        !controller.isThinking;
    final label = color == PieceColor.white ? l10n.white : l10n.black;
    final name = color == PieceColor.white ? l10n.you : l10n.computer;
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color == PieceColor.white
                ? AppColors.whitePlayer
                : AppColors.blackPlayer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 19,
            color: color == PieceColor.white
                ? AppColors.blackPlayer
                : AppColors.accent,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: active ? AppColors.accent : AppColors.textMuted,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (active)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.successBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.yourTurn,
              style: const TextStyle(
                color: AppColors.success,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
      ],
    );
  }

  Widget _board(double size) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .35),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 64,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemBuilder: (_, visualIndex) {
        final index = controller.flipped ? 63 - visualIndex : visualIndex;
        final row = visualIndex ~/ 8;
        final col = visualIndex % 8;
        final dark = (row + col).isOdd;
        final piece = controller.board[index];
        final selected = controller.selected == index;
        final target = controller.availableMoves.contains(index);
        final isLastMove =
            controller.lastMove?.from == index ||
            controller.lastMove?.to == index;
        return GestureDetector(
          onTap: () => controller.tapSquare(index),
          child: Container(
            color: selected
                ? AppColors.selectedSquare
                : isLastMove
                ? AppColors.lastMoveSquare
                : dark
                ? AppColors.blackSquare
                : AppColors.whiteSquare,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (target)
                  Container(
                    width: piece == null ? 15 : 42,
                    height: piece == null ? 15 : 42,
                    decoration: BoxDecoration(
                      color: piece == null
                          ? AppColors.availableSquare
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: piece == null
                          ? null
                          : Border.all(
                              color: AppColors.availableBorder,
                              width: 3,
                            ),
                    ),
                  ),
                if (piece != null)
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      piece.color == PieceColor.white
                          ? AppColors.whitePiece
                          : AppColors.blackPiece,
                      BlendMode.srcIn,
                    ),
                    child: Text(
                      piece.symbol,
                      style: TextStyle(
                        fontSize: size / 11,
                        height: .9,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 2),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (visualIndex >= 56)
                  Positioned(
                    bottom: 3,
                    right: 4,
                    child: Text(
                      String.fromCharCode(
                        97 + (controller.flipped ? 7 - col : col),
                      ),
                      style: TextStyle(
                        fontSize: 9,
                        color: dark
                            ? AppColors.whiteSquare
                            : AppColors.blackSquare,
                      ),
                    ),
                  ),
                if (visualIndex % 8 == 0)
                  Positioned(
                    top: 3,
                    left: 4,
                    child: Text(
                      '${controller.flipped ? row + 1 : 8 - row}',
                      style: TextStyle(
                        fontSize: 9,
                        color: dark
                            ? AppColors.whiteSquare
                            : AppColors.blackSquare,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );

  Widget _gameInfo(AppLocalizations l10n) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        Icon(
          controller.gameOver
              ? Icons.emoji_events_outlined
              : Icons.timer_outlined,
          color: AppColors.accent,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _statusText(l10n),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          l10n.movesCount(controller.moves.length),
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: controller.undo,
          icon: const Icon(Icons.undo, size: 20),
          tooltip: l10n.undo,
        ),
      ],
    ),
  );

  String _statusText(AppLocalizations l10n) {
    switch (controller.status) {
      case GameStatus.checkmate:
        return controller.turn == PieceColor.white
            ? l10n.checkmateBlackWins
            : l10n.checkmateWhiteWins;
      case GameStatus.stalemate:
        return l10n.stalemate;
      case GameStatus.check:
        return controller.isThinking ? l10n.computerThinking : l10n.check;
      case GameStatus.playing:
        if (controller.isThinking) return l10n.computerThinking;
        return controller.turn == PieceColor.white
            ? l10n.whiteToMove
            : l10n.blackToMove;
    }
  }
}
