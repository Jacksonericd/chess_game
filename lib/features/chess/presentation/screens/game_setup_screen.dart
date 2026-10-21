import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/presentation/widgets/banner_ad_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/services/chess_ai_service.dart';
import 'chess_screen.dart';

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  AiDifficulty selected = AiDifficulty.medium;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenPadding = MediaQuery.paddingOf(context);
    final screenSize = MediaQuery.sizeOf(context);
    final width = screenSize.width - screenPadding.horizontal - 32;
    final heroScale = (screenSize.height * .13 / AppDimensions.setupHeroSize)
        .clamp(.45, 1.0)
        .toDouble();
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final options = [
      (AiDifficulty.beginner, l10n.levelOne),
      (AiDifficulty.easy, l10n.levelTwo),
      (AiDifficulty.medium, l10n.levelThree),
      (AiDifficulty.hard, l10n.levelFour),
      (AiDifficulty.expert, l10n.levelFive),
    ];
    final optionList = landscape
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var row = 0; row < 3; row++) ...[
                Row(
                  children: [
                    Expanded(
                      child: _difficultyCard(
                        options[row * 2].$1,
                        options[row * 2].$2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: row * 2 + 1 < options.length
                          ? _difficultyCard(
                              options[row * 2 + 1].$1,
                              options[row * 2 + 1].$2,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
                if (row < 2) const SizedBox(height: 8),
              ],
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < options.length; index++) ...[
                _difficultyCard(options[index].$1, options[index].$2),
                if (index < options.length - 1) const SizedBox(height: 8),
              ],
            ],
          );

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -.45),
            radius: 1.2,
            colors: [
              AppColors.backgroundTeal,
              AppColors.backgroundMiddle,
              AppColors.backgroundDeep,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SizedBox(
                  height:
                      (AppDimensions.setupHeroSize +
                          16 +
                          AppDimensions.setupBrandSize +
                          6 +
                          AppDimensions.setupTaglineSize) *
                      heroScale,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: width,
                        child: _hero(l10n, scale: heroScale),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.chooseDifficulty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimensions.setupTitleSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(width: width, child: optionList),
                    ),
                  ),
                ),
                Center(child: BannerAdWidget(maxWidth: width)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ChessScreen(difficulty: selected),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 27),
                    label: Text(l10n.startGame.toUpperCase()),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.goldAction,
                      foregroundColor: AppColors.textOnGold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: const BorderSide(color: AppColors.goldHighlight),
                      ),
                      textStyle: const TextStyle(
                        fontSize: AppDimensions.setupButtonTextSize,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hero(AppLocalizations l10n, {required double scale}) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: AppDimensions.setupHeroSize * scale,
        height: AppDimensions.setupHeroSize * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.panelHighlight,
          border: Border.all(
            color: AppColors.goldBorder,
            width: AppDimensions.setupHeroBorderWidth,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cyanGlow,
              blurRadius: AppDimensions.setupHeroGlowBlur,
              spreadRadius: AppDimensions.setupHeroGlowSpread,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            AppAssets.appIcon,
            width: AppDimensions.setupHeroSize * scale,
            height: AppDimensions.setupHeroSize * scale,
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(height: 16 * scale),
      Row(
        children: [
          const Expanded(child: Divider(color: AppColors.dividerGold)),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.setupBrandHorizontalPadding * scale,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${l10n.brandName} ${l10n.appSuffix}',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: AppColors.goldLight,
                    fontSize: AppDimensions.setupBrandSize * scale,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.dividerGold)),
        ],
      ),
      SizedBox(height: 6 * scale),
      Text(
        l10n.brandTagline.toUpperCase(),
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.setupTaglineSize * scale,
          letterSpacing: 3,
        ),
      ),
    ],
  );

  Widget _difficultyCard(AiDifficulty difficulty, String title) {
    final isSelected = selected == difficulty;
    return GestureDetector(
      onTap: () => setState(() => selected = difficulty),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: AppDimensions.setupCardPadding,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.panelHighlight : AppColors.panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.cyan : AppColors.blueBorder,
            width: isSelected
                ? AppDimensions.setupSelectedCardBorderWidth
                : AppDimensions.setupCardBorderWidth,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: AppDimensions.setupIndicatorSize,
              height: AppDimensions.setupIndicatorSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.cyanBright : AppColors.blueGray,
                  width: isSelected
                      ? AppDimensions.setupSelectedIndicatorBorderWidth
                      : AppDimensions.setupIndicatorBorderWidth,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 19,
                      color: AppColors.cyanBright,
                    )
                  : null,
            ),
            const SizedBox(width: AppDimensions.setupIndicatorGap),
            Text(
              _pieceSymbol(difficulty),
              style: TextStyle(
                color: isSelected ? AppColors.cyanLight : AppColors.textBright,
                fontSize: AppDimensions.setupPieceSize,
              ),
            ),
            const SizedBox(width: AppDimensions.setupPieceGap),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textBright,
                  fontSize: AppDimensions.setupCardTextSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _pieceSymbol(AiDifficulty difficulty) => switch (difficulty) {
    AiDifficulty.beginner => '♟',
    AiDifficulty.easy => '♟',
    AiDifficulty.medium => '♞',
    AiDifficulty.hard => '♜',
    AiDifficulty.expert => '♛',
  };
}
