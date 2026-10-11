import 'package:flutter/material.dart';

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
    final options = [
      (AiDifficulty.beginner, l10n.levelOne, l10n.levelOneDescription),
      (AiDifficulty.easy, l10n.levelTwo, l10n.levelTwoDescription),
      (AiDifficulty.medium, l10n.levelThree, l10n.levelThreeDescription),
      (AiDifficulty.hard, l10n.levelFour, l10n.levelFourDescription),
      (AiDifficulty.expert, l10n.levelFive, l10n.levelFiveDescription),
    ];
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact =
                  constraints.maxHeight < AppDimensions.setupCompactHeight;
              return SingleChildScrollView(
                padding: AppDimensions.setupPagePadding(compact),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppDimensions.setupMaxWidth,
                    ),
                    child: Column(
                      children: [
                        _hero(l10n, compact: compact),
                        SizedBox(
                          height: compact
                              ? AppDimensions.setupCompactTitleSpacing
                              : AppDimensions.setupTitleSpacing,
                        ),
                        Text(
                          l10n.chooseDifficulty,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: AppDimensions.setupTitleSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: compact
                              ? AppDimensions.setupCompactOptionsSpacing
                              : AppDimensions.setupOptionsSpacing,
                        ),
                        for (var index = 0; index < options.length; index++)
                          _difficultyCard(options[index].$1, options[index].$2),
                        SizedBox(
                          height: compact
                              ? AppDimensions.setupCompactActionSpacing
                              : AppDimensions.setupActionSpacing,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () =>
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ChessScreen(difficulty: selected),
                                  ),
                                ),
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              size: 27,
                            ),
                            label: Text(l10n.startGame.toUpperCase()),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.goldAction,
                              foregroundColor: AppColors.textOnGold,
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimensions.setupButtonPaddingFor(
                                  compact,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                                side: const BorderSide(
                                  color: AppColors.goldHighlight,
                                ),
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _hero(AppLocalizations l10n, {bool compact = false}) => Column(
    children: [
      Container(
        width: AppDimensions.setupHeroSizeFor(compact),
        height: AppDimensions.setupHeroSizeFor(compact),
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
        child: Center(
          child: Text(
            '♞',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: AppDimensions.setupHeroPieceSizeFor(compact),
              height: AppDimensions.setupHeroTextHeight,
              shadows: [
                Shadow(
                  color: AppColors.goldShadow,
                  offset: AppDimensions.setupHeroShadowOffset,
                  blurRadius: AppDimensions.setupHeroShadowBlur,
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: compact ? 10 : 16),
      Row(
        children: [
          const Expanded(child: Divider(color: AppColors.dividerGold)),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.setupBrandHorizontalPadding,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${l10n.brandName} APP',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: AppColors.goldLight,
                    fontSize: AppDimensions.setupBrandSizeFor(compact),
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
      SizedBox(height: compact ? 3 : 6),
      Text(
        l10n.brandTagline.toUpperCase(),
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppDimensions.setupTaglineSize,
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
        margin: const EdgeInsets.only(
          bottom: AppDimensions.setupCardBottomMargin,
        ),
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
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.cyanBright : AppColors.blueGray,
                  width: isSelected
                      ? AppDimensions.setupSelectedIndicatorBorderWidth
                      : AppDimensions.setupIndicatorBorderWidth,
                ),
              ),
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
