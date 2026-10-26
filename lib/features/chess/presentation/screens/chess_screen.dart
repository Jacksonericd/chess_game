import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/presentation/widgets/banner_ad_widget.dart';
import '../../../../core/services/interstitial_ad_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/chess_piece.dart';
import '../../domain/services/chess_ai_service.dart';
import '../controllers/chess_controller.dart';

class ChessScreen extends StatefulWidget {
  const ChessScreen({super.key, this.difficulty = AiDifficulty.medium});

  final AiDifficulty difficulty;

  @override
  State<ChessScreen> createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> {
  late final ChessController controller;
  late final InterstitialAdManager _interstitialAdManager;
  bool _checkmateDialogShown = false;

  @override
  void initState() {
    super.initState();
    _interstitialAdManager = InterstitialAdManager()..loadAd();
    controller = ChessController(difficulty: widget.difficulty)
      ..addListener(_refresh);
  }

  void _refresh() {
    if (!mounted) return;
    if (controller.status != GameStatus.checkmate) {
      _checkmateDialogShown = false;
    }
    setState(() {});
    if (controller.status == GameStatus.checkmate && !_checkmateDialogShown) {
      _checkmateDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || controller.status != GameStatus.checkmate) {
          _checkmateDialogShown = false;
          return;
        }
        _showCheckmateDialog();
      });
    }
  }

  Future<void> _showCheckmateDialog() async {
    final l10n = AppLocalizations.of(context);
    final showDialogBanner = MediaQuery.sizeOf(context).height >= 700;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.scrim,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.dialogHorizontalInset,
          vertical: AppDimensions.dialogVerticalInset,
        ),
        child: Container(
          padding: AppDimensions.dialogContentPadding,
          decoration: BoxDecoration(
            color: AppColors.panelDark,
            borderRadius: BorderRadius.circular(AppDimensions.dialogCardRadius),
            border: Border.all(
              color: AppColors.goldOutline,
              width: AppDimensions.dialogBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldGlow.withValues(alpha: .22),
                blurRadius: AppDimensions.dialogShadowBlur,
                spreadRadius: AppDimensions.dialogShadowSpread,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.workspace_premium,
                size: 72,
                color: AppColors.gold,
              ),
              const SizedBox(height: AppDimensions.dialogTitleSpacing),
              Text(
                l10n.checkmate,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.gold,
                  fontSize: AppDimensions.dialogTitleSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: AppDimensions.dialogTitleSpacing),
              Text(
                _winnerText(l10n),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppDimensions.dialogWinnerSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppDimensions.dialogWinnerSpacing),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.dialogDividerPadding,
                    ),
                    child: Icon(
                      Icons.diamond,
                      size: 14,
                      color: AppColors.goldAction,
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: AppDimensions.dialogActionSpacing),
              if (showDialogBanner) ...[
                Center(
                  child: BannerAdWidget(
                    maxWidth: (MediaQuery.sizeOf(context).width - 80)
                        .clamp(1.0, AppDimensions.dialogMaxWidth - 44)
                        .toDouble(),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: BannerAdWidget(
                    maxWidth: (MediaQuery.sizeOf(context).width - 80)
                        .clamp(1.0, AppDimensions.dialogMaxWidth - 44)
                        .toDouble(),
                  ),
                ),
                const SizedBox(height: AppDimensions.dialogActionSpacing),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _interstitialAdManager.show(
                      onFinished: () {
                        if (mounted) controller.reset();
                      },
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded, size: 28),
                  label: Text(l10n.startGame.toUpperCase()),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.goldAction,
                    foregroundColor: AppColors.textOnGold,
                    padding: AppDimensions.dialogButtonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.dialogButtonRadius,
                      ),
                    ),
                    textStyle: const TextStyle(
                      fontSize: AppDimensions.dialogButtonTextSize,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.dialogButtonGap),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _interstitialAdManager.show(
                      onFinished: () {
                        if (mounted) controller.reset();
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.tealText,
                    side: const BorderSide(color: AppColors.cyan),
                    padding: AppDimensions.dialogSecondaryButtonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.dialogButtonRadius,
                      ),
                    ),
                    textStyle: const TextStyle(
                      fontSize: AppDimensions.dialogButtonTextSize,
                    ),
                  ),
                  child: Text(l10n.newGame.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _winnerText(AppLocalizations l10n) =>
      controller.turn == PieceColor.white ? l10n.computer : l10n.you;

  @override
  void dispose() {
    controller.removeListener(_refresh);
    controller.dispose();
    _interstitialAdManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenSize = MediaQuery.sizeOf(context);
    final safePadding = MediaQuery.paddingOf(context);
    final availableWidth = screenSize.width - safePadding.horizontal;
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final scale = (screenSize.height / 700).clamp(.65, 1.0).toDouble();
    final horizontalPadding = 12 * scale;
    final boardSide = landscape ? screenSize.height : screenSize.width;
    final showDialogBanner = screenSize.height >= 700;
    final board = AspectRatio(aspectRatio: 1, child: _board(boardSide));

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -.15),
            radius: 1.15,
            colors: [
              AppColors.backgroundGameTop,
              AppColors.backgroundGameMiddle,
              AppColors.backgroundGameBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12 * scale,
              horizontalPadding,
              12 * scale,
            ),
            child: landscape
                ? Row(
                    children: [
                      Expanded(flex: 2, child: Center(child: board)),
                      SizedBox(width: 14 * scale),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _header(l10n, scale: scale),
                            SizedBox(height: 8 * scale),
                            _player(
                              l10n,
                              PieceColor.black,
                              Icons.smart_toy_outlined,
                              scale: scale,
                            ),
                            SizedBox(height: 6 * scale),
                            _player(
                              l10n,
                              PieceColor.white,
                              Icons.person_outline,
                              scale: scale,
                            ),
                            const Spacer(),
                            _statusBanner(l10n, scale: scale),
                            const Spacer(),
                            if (!(_checkmateDialogShown && showDialogBanner))
                              Center(
                                child: BannerAdWidget(
                                  maxWidth:
                                      (availableWidth -
                                          horizontalPadding * 2 -
                                          14 * scale) /
                                      3,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(l10n, scale: scale),
                      SizedBox(height: 8 * scale),
                      _player(
                        l10n,
                        PieceColor.black,
                        Icons.smart_toy_outlined,
                        scale: scale,
                      ),
                      SizedBox(height: 8 * scale),
                      Expanded(child: Center(child: board)),
                      SizedBox(height: 8 * scale),
                      _player(
                        l10n,
                        PieceColor.white,
                        Icons.person_outline,
                        scale: scale,
                      ),
                      SizedBox(height: 8 * scale),
                      _statusBanner(l10n, scale: scale),
                      if (!(_checkmateDialogShown && showDialogBanner))
                        Center(
                          child: BannerAdWidget(
                            maxWidth: availableWidth - horizontalPadding * 2,
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _header(AppLocalizations l10n, {required double scale}) => Stack(
    clipBehavior: Clip.none,
    children: [
      Column(
        children: [
          ClipOval(
            child: Image.asset(
              AppAssets.appIcon,
              width: 38 * scale,
              height: 38 * scale,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: AppDimensions.headerTopGap * scale),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.dividerGold)),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.brandName.toUpperCase(),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: AppColors.goldLight,
                        fontSize: AppDimensions.headerBrandSize * scale,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(child: Divider(color: AppColors.dividerGold)),
            ],
          ),
          SizedBox(height: AppDimensions.headerBottomGap * scale),
          Text(
            l10n.brandTagline.toUpperCase(),
            style: TextStyle(
              color: AppColors.textGameSecondary,
              fontSize: AppDimensions.headerTaglineSize * scale,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
      Positioned(
        right: -8,
        top: 0,
        child: IconButton(
          onPressed: controller.reset,
          tooltip: l10n.startGame,
          icon: const Icon(Icons.refresh_rounded, color: AppColors.goldSoft),
        ),
      ),
    ],
  );

  Widget _player(
    AppLocalizations l10n,
    PieceColor color,
    IconData icon, {
    required double scale,
  }) {
    final active =
        color == PieceColor.white &&
        controller.turn == color &&
        !controller.gameOver &&
        !controller.isThinking;
    final label = color == PieceColor.white ? l10n.white : l10n.black;
    final name = color == PieceColor.white ? l10n.you : l10n.computer;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 10 * scale,
      ),
      decoration: BoxDecoration(
        color: AppColors.panelPlayer,
        border: Border.all(color: AppColors.playerBorderMuted),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.playerAvatarSize * scale,
            height: AppDimensions.playerAvatarSize * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color == PieceColor.white
                  ? AppColors.playerWhite
                  : AppColors.playerBlack,
              border: Border.all(
                color: AppColors.playerBorder,
                width: AppDimensions.playerAvatarBorderWidth,
              ),
            ),
            child: Icon(icon, size: 30, color: AppColors.playerIcon),
          ),
          SizedBox(width: 12 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: AppDimensions.playerTextSize * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                color == PieceColor.black
                    ? l10n.levelLabel(widget.difficulty.index + 1)
                    : active
                    ? l10n.yourTurn.toUpperCase()
                    : label.toUpperCase(),
                style: TextStyle(
                  fontSize: AppDimensions.playerMetaTextSize * scale,
                  color: active ? AppColors.success : AppColors.textMutedBlue,
                  letterSpacing: 1.5,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _board(double size) => Container(
    padding: const EdgeInsets.all(AppDimensions.boardFramePadding),
    decoration: BoxDecoration(
      color: AppColors.boardFrame,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: AppColors.boardBorder,
        width: AppDimensions.boardFrameBorderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .35),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
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
                  ? AppColors.accentDark
                  : isLastMove
                  ? dark
                        ? AppColors.lastMoveDarkSquare
                        : AppColors.lastMoveLightSquare
                  : dark
                  ? AppColors.blackSquare
                  : AppColors.whiteSquare,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (target)
                    Container(
                      width: piece == null
                          ? AppDimensions.boardEmptyTargetSize
                          : AppDimensions.boardPieceTargetSize,
                      height: piece == null
                          ? AppDimensions.boardEmptyTargetSize
                          : AppDimensions.boardPieceTargetSize,
                      decoration: BoxDecoration(
                        color: piece == null
                            ? AppColors.availableSquare
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: piece == null
                            ? null
                            : Border.all(
                                color: AppColors.availableBorder,
                                width: AppDimensions.boardTargetBorderWidth,
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
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          piece.symbol,
                          style: TextStyle(
                            fontSize: size / 11,
                            height: AppDimensions.boardPieceTextHeight,
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
                          fontSize: AppDimensions.boardCoordinateTextSize,
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
                          fontSize: AppDimensions.boardCoordinateTextSize,
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
    ),
  );

  Widget _statusBanner(AppLocalizations l10n, {required double scale}) {
    final status = _statusText(l10n);
    final isActive =
        controller.turn == PieceColor.white &&
        !controller.gameOver &&
        !controller.isThinking;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 12 * scale,
      ),
      decoration: BoxDecoration(
        color: AppColors.panelStatus,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? AppColors.statusActive : AppColors.statusBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.statusDotSize * scale,
            height: AppDimensions.statusDotSize * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.statusDot : AppColors.statusInactive,
            ),
          ),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Text(
              status,
              style: TextStyle(
                fontSize: AppDimensions.statusTextSize * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            l10n.movesCount(controller.moves.length),
            style: const TextStyle(
              color: AppColors.textMutedBlue,
              fontSize: AppDimensions.moveCountTextSize,
              letterSpacing: .7,
            ),
          ),
          const SizedBox(width: 4),
          _controlIconButton(
            icon: Icons.undo_rounded,
            tooltip: l10n.undo,
            onPressed: controller.undo,
          ),
          _controlIconButton(
            icon: Icons.rotate_right_rounded,
            tooltip: l10n.rotate,
            onPressed: controller.toggleFlip,
          ),
        ],
      ),
    );
  }

  Widget _controlIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    visualDensity: VisualDensity.compact,
    constraints: const BoxConstraints.tightFor(width: 36, height: 36),
    padding: EdgeInsets.zero,
    icon: Icon(icon, size: 20, color: AppColors.goldSoft),
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
