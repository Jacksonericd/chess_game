import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../features/chess/domain/entities/chess_piece.dart';
import '../../features/chess/domain/services/chess_ai_service.dart';
import '../../features/chess/presentation/controllers/chess_controller.dart';
import '../../l10n/app_localizations.dart';
import 'web_ad_widget.dart';

class WebChessPage extends StatefulWidget {
  const WebChessPage({super.key});

  @override
  State<WebChessPage> createState() => _WebChessPageState();
}

enum _PageMode { dashboard, game }

class _WebChessPageState extends State<WebChessPage> {
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.jed.chess';

  _PageMode _mode = _PageMode.dashboard;
  AiDifficulty _difficulty = AiDifficulty.medium;
  ChessController? _controller;

  WebChessTheme get _webTheme => Theme.of(context).extension<WebChessTheme>()!;
  AppLocalizations get _l10n => AppLocalizations.of(context);

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _webTheme.page,
    body: SelectionArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _header()),
          SliverToBoxAdapter(
            child: _mode == _PageMode.dashboard
                ? _dashboard()
                : _gameWorkspace(),
          ),
          SliverToBoxAdapter(child: _footer()),
        ],
      ),
    ),
  );

  Widget _header() => Container(
    color: _webTheme.page,
    child: SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 16),
            child: SizedBox(
              width: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 620;
                  return Row(
                    children: [
                      _brand(),
                      const Spacer(),
                      if (!compact && _mode == _PageMode.dashboard)
                        _headerLabel(_l10n.playSolo),
                      if (!compact && _mode == _PageMode.game)
                        TextButton(
                          onPressed: _goToDashboard,
                          style: TextButton.styleFrom(
                            foregroundColor: _webTheme.muted,
                          ),
                          child: Text(_l10n.dashboard),
                        ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: _openDifficultyDialog,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _webTheme.accent,
                          side: BorderSide(color: _webTheme.accent),
                          padding: EdgeInsets.symmetric(
                            horizontal: compact ? 14 : 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          compact
                              ? _l10n.play
                              : _mode == _PageMode.game
                              ? _l10n.newGame
                              : _l10n.startPlaying,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _brand() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 34,
        height: 34,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: _webTheme.accent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Image.asset(AppAssets.appIcon, fit: BoxFit.cover),
      ),
      const SizedBox(width: 11),
      Text(
        _l10n.brandName,
        style: TextStyle(
          color: _webTheme.ink,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    ],
  );

  Widget _headerLabel(String text) => Text(
    text,
    style: TextStyle(
      color: _webTheme.muted,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
    ),
  );

  Widget _dashboard() => Container(
    color: _webTheme.page,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1440),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dashboardHero(),
                const SizedBox(height: 24),
                _dashboardLowerRow(),
                const SizedBox(height: 24),
                _dashboardAd(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _dashboardHero() => LayoutBuilder(
    builder: (context, constraints) {
      final copy = _heroCopy();
      final board = Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _heroBoard(),
        ),
      );
      if (constraints.maxWidth < 880) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [board, const SizedBox(height: 30), copy],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: copy),
          const SizedBox(width: 52),
          Expanded(flex: 5, child: board),
        ],
      );
    },
  );

  Widget _storeBanner() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
    decoration: BoxDecoration(
      color: _webTheme.hero,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _webTheme.border),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        final details = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: _webTheme.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(AppAssets.appIcon, fit: BoxFit.cover),
            ),
            const SizedBox(width: 11),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _l10n.availableOnGooglePlay,
                  style: TextStyle(
                    color: _webTheme.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _l10n.chessForAndroid,
                  style: TextStyle(
                    color: _webTheme.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        );
        final action = OutlinedButton.icon(
          onPressed: _openStore,
          icon: const Icon(Icons.open_in_new, size: 15),
          label: Text(_l10n.getTheApp),
          style: OutlinedButton.styleFrom(
            foregroundColor: _webTheme.accent,
            side: BorderSide(color: _webTheme.accent),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [details, const SizedBox(height: 12), action],
          );
        }
        return Row(children: [details, const Spacer(), action]);
      },
    ),
  );

  Widget _heroCopy() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _eyebrow(_l10n.quietPlaceToPlay),
      const SizedBox(height: 18),
      Text(
        _l10n.heroTitle,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: _webTheme.ink,
          height: .98,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.8,
        ),
      ),
      const SizedBox(height: 20),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Text(
          _l10n.heroDescription,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: _webTheme.muted,
            height: 1.45,
          ),
        ),
      ),
      const SizedBox(height: 28),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _primaryButton(_l10n.playAMatch, _openDifficultyDialog),
          OutlinedButton.icon(
            onPressed: _openStore,
            icon: const Icon(Icons.android, size: 18),
            label: Text(_l10n.androidApp),
            style: OutlinedButton.styleFrom(
              foregroundColor: _webTheme.ink,
              side: BorderSide(color: _webTheme.border),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
      const SizedBox(height: 30),
      Wrap(
        spacing: 22,
        runSpacing: 10,
        children: [
          _smallMetric('5', _l10n.levels),
          _smallMetric('2', _l10n.boardViews),
          _smallMetric('0', _l10n.signUps),
        ],
      ),
      const SizedBox(height: 24),
      _storeBanner(),
    ],
  );

  Widget _smallMetric(String value, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        value,
        style: TextStyle(
          color: _webTheme.accent,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(color: _webTheme.muted, fontSize: 13)),
    ],
  );

  Widget _heroBoard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _webTheme.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _webTheme.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .18),
          blurRadius: 30,
          offset: const Offset(0, 18),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
          child: Row(
            children: [
              _eyebrow(_l10n.yourBoard),
              const Spacer(),
              Icon(Icons.more_horiz, color: _webTheme.muted, size: 18),
            ],
          ),
        ),
        AspectRatio(aspectRatio: 1, child: _previewBoard()),
      ],
    ),
  );

  Widget _previewBoard() => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 64,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemBuilder: (context, index) {
        final row = index ~/ 8;
        final column = index % 8;
        final dark = (row + column).isOdd;
        final top = row <= 1;
        final bottom = row >= 6;
        return Container(
          color: dark ? AppColors.blackSquare : AppColors.whiteSquare,
          alignment: Alignment.center,
          child: Text(
            _previewPiece(index),
            style: TextStyle(
              fontSize: 27,
              height: .9,
              color: top
                  ? AppColors.blackPiece
                  : bottom
                  ? AppColors.whitePiece
                  : Colors.transparent,
              shadows: const [
                Shadow(
                  color: Colors.black38,
                  offset: Offset(1, 1),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  String _previewPiece(int index) {
    const back = ['♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜'];
    if (index < 8) return back[index];
    if (index < 16) return '♟';
    if (index >= 48 && index < 56) return '♙';
    if (index >= 56) return back[index - 56];
    return '';
  }

  Widget _dashboardLowerRow() => Builder(
    builder: (context) {
      final how = _howItWorks();
      final app = _appPanel();
      final screenWidth = MediaQuery.of(context).size.width;

      if (screenWidth < 800) {
        return Column(children: [how, const SizedBox(height: 16), app]);
      }

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: how),
            const SizedBox(width: 16),
            Expanded(flex: 4, child: app),
          ],
        ),
      );
    },
  );

  Widget _howItWorks() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _webTheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _webTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _l10n.simpleMatchFlow,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: _webTheme.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 18),
        for (final step in [
          ('01', _l10n.chooseLevel, _l10n.chooseLevelDescription),
          ('02', _l10n.readBoard, _l10n.readBoardDescription),
          ('03', _l10n.playItThrough, _l10n.playItThroughDescription),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.$1,
                  style: TextStyle(
                    color: _webTheme.accent,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.$2,
                        style: TextStyle(
                          color: _webTheme.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(step.$3, style: TextStyle(color: _webTheme.muted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );

  Widget _appPanel() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _webTheme.hero,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _webTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.phone_android_rounded, color: _webTheme.accent, size: 24),
        const SizedBox(height: 18),
        Text(
          _l10n.takeBoardWithYou,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: _webTheme.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _l10n.androidAvailability,
          style: TextStyle(color: _webTheme.muted, height: 1.4),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _openStore,
          icon: const Icon(Icons.open_in_new, size: 17),
          label: Text(_l10n.openGooglePlay),
          style: OutlinedButton.styleFrom(
            foregroundColor: _webTheme.accent,
            side: BorderSide(color: _webTheme.accent),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          ),
        ),
      ],
    ),
  );

  Widget _dashboardAd() => const Padding(
    padding: EdgeInsets.only(top: 2),
    child: WebAdWidget(slotId: '3089347046'),
  );

  Widget _gameWorkspace() {
    final controller = _controller!;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Container(
        color: _webTheme.page,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 26, 24, 44),
                child: Column(
                  children: [
                    _gameHeading(controller),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final board = _gameBoard(controller);
                        final controls = _gameControls(controller);
                        if (constraints.maxWidth < 1000) {
                          return Column(
                            children: [
                              board,
                              const SizedBox(height: 18),
                              controls,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(width: 440, child: board),
                              ),
                            ),
                            const SizedBox(width: 22),
                            SizedBox(width: 330, child: controls),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const WebAdWidget(slotId: '1365201838'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gameHeading(ChessController controller) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _eyebrow(_l10n.liveMatch),
            const SizedBox(height: 7),
            Text(
              _gameStatus(controller),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: _webTheme.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      TextButton.icon(
        onPressed: _goToDashboard,
        icon: const Icon(Icons.arrow_back, size: 17),
        label: Text(_l10n.leaveMatch),
        style: TextButton.styleFrom(foregroundColor: _webTheme.muted),
      ),
    ],
  );

  Widget _gameBoard(ChessController controller) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.boardFrame,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.boardBorder, width: 2),
    ),
    child: AspectRatio(aspectRatio: 1, child: _interactiveBoard(controller)),
  );

  Widget _interactiveBoard(ChessController controller) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 64,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemBuilder: (context, visualIndex) {
        final index = controller.flipped ? 63 - visualIndex : visualIndex;
        final row = visualIndex ~/ 8;
        final column = visualIndex % 8;
        final dark = (row + column).isOdd;
        final piece = controller.board[index];
        final selected = controller.selected == index;
        final target = controller.availableMoves.contains(index);
        final last =
            controller.lastMove?.from == index ||
            controller.lastMove?.to == index;
        return GestureDetector(
          onTap: () => controller.tapSquare(index),
          child: Container(
            color: selected
                ? AppColors.accentDark
                : last
                ? (dark
                      ? AppColors.lastMoveDarkSquare
                      : AppColors.lastMoveLightSquare)
                : (dark ? AppColors.blackSquare : AppColors.whiteSquare),
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
                      style: const TextStyle(
                        fontSize: 42,
                        height: .9,
                        color: Colors.white,
                        shadows: [
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
                        97 + (controller.flipped ? 7 - column : column),
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

  Widget _gameControls(ChessController controller) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _playerPanel(
        _l10n.computer,
        _l10n.levelLabel(controller.difficulty.index + 1),
        Icons.smart_toy_outlined,
        false,
      ),
      const SizedBox(height: 10),
      _playerPanel(
        _l10n.you,
        controller.turn == PieceColor.white && !controller.isThinking
            ? _l10n.yourMove
            : _l10n.white,
        Icons.person_outline,
        true,
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: _secondaryButton(
              Icons.undo_rounded,
              _l10n.undo,
              controller.undo,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _secondaryButton(
              Icons.rotate_right_rounded,
              _l10n.rotate,
              controller.toggleFlip,
            ),
          ),
        ],
      ),
      if (controller.gameOver) ...[
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _webTheme.selectedSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _webTheme.accent),
          ),
          child: Column(
            children: [
              Text(
                _gameStatus(controller),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _webTheme.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              _primaryButton(_l10n.playAgain, controller.reset),
            ],
          ),
        ),
      ],
    ],
  );

  Widget _playerPanel(String name, String meta, IconData icon, bool human) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _webTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _webTheme.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: human ? _webTheme.accent : _webTheme.muted),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: _webTheme.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  meta,
                  style: TextStyle(color: _webTheme.muted, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _primaryButton(String label, VoidCallback onPressed) =>
      FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: _webTheme.accent,
          foregroundColor: AppColors.textOnGold,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  Widget _secondaryButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 17),
    label: Text(label),
    style: OutlinedButton.styleFrom(
      foregroundColor: _webTheme.accent,
      side: BorderSide(color: _webTheme.accent),
      padding: const EdgeInsets.symmetric(vertical: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  Widget _eyebrow(String text) => Text(
    text,
    style: TextStyle(
      color: _webTheme.accent,
      fontSize: 11,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.2,
    ),
  );

  Widget _footer() => Container(
    color: _webTheme.surface,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 26, 28, 34),
        child: Text(
          _l10n.footerTagline,
          style: TextStyle(color: _webTheme.muted, fontSize: 12),
        ),
      ),
    ),
  );

  String _gameStatus(ChessController controller) => switch (controller.status) {
    GameStatus.checkmate =>
      controller.turn == PieceColor.white
          ? _l10n.checkmateComputerWins
          : _l10n.checkmateYouWin,
    GameStatus.stalemate => _l10n.stalemateDraw,
    GameStatus.check =>
      controller.isThinking ? _l10n.computerThinking : _l10n.check,
    GameStatus.playing =>
      controller.isThinking
          ? _l10n.computerThinking
          : controller.turn == PieceColor.white
          ? _l10n.yourMove
          : _l10n.computerThinking,
  };

  Future<void> _openDifficultyDialog() async {
    var selected = _difficulty;
    final result = await showDialog<AiDifficulty>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: _webTheme.page,
          insetPadding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _l10n.setUpMatch,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: _webTheme.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _l10n.chooseComputerDifficulty,
                    style: TextStyle(color: _webTheme.muted),
                  ),
                  const SizedBox(height: 20),
                  for (final option in AiDifficulty.values) ...[
                    InkWell(
                      onTap: () => setDialogState(() => selected = option),
                      borderRadius: BorderRadius.circular(11),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selected == option
                              ? _webTheme.selectedSurface
                              : _webTheme.surface,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: selected == option
                                ? _webTheme.accent
                                : _webTheme.border,
                            width: selected == option ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_outlined,
                              color: _webTheme.accent,
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Text(
                                _difficultyLabel(option),
                                style: TextStyle(
                                  color: _webTheme.ink,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (selected == option)
                              Icon(Icons.check_circle, color: _webTheme.accent),
                          ],
                        ),
                      ),
                    ),
                    if (option != AiDifficulty.expert)
                      const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _primaryButton(
                      _l10n.openBoard,
                      () => Navigator.of(dialogContext).pop(selected),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (result == null || !mounted) return;
    _difficulty = result;
    _controller?.dispose();
    final controller = ChessController(difficulty: result)
      ..addListener(_refreshGame);
    setState(() {
      _controller = controller;
      _mode = _PageMode.game;
    });
  }

  String _difficultyLabel(AiDifficulty difficulty) => switch (difficulty) {
    AiDifficulty.beginner => _l10n.levelOne,
    AiDifficulty.easy => _l10n.levelTwo,
    AiDifficulty.medium => _l10n.levelThree,
    AiDifficulty.hard => _l10n.levelFour,
    AiDifficulty.expert => _l10n.levelFive,
  };

  void _refreshGame() {
    if (mounted) setState(() {});
  }

  void _goToDashboard() {
    _controller?.dispose();
    setState(() {
      _controller = null;
      _mode = _PageMode.dashboard;
    });
  }

  Future<void> _openStore() async {
    await launchUrl(Uri.parse(playStoreUrl), webOnlyWindowName: '_blank');
  }
}
