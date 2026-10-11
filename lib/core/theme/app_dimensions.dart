import 'package:flutter/material.dart';

abstract final class AppDimensions {
  static const setupCompactHeight = 780.0;
  static const setupMaxWidth = 560.0;
  static const setupHorizontalPadding = 16.0;
  static const setupTopPadding = 18.0;
  static const setupCompactTopPadding = 8.0;
  static const setupBottomPadding = 20.0;
  static const setupHeroSize = 178.0;
  static const setupCompactHeroSize = 142.0;
  static const setupHeroPieceSize = 120.0;
  static const setupCompactHeroPieceSize = 96.0;
  static const setupTitleSize = 24.0;
  static const setupHeroBorderWidth = 2.0;
  static const setupHeroGlowBlur = 28.0;
  static const setupHeroGlowSpread = 3.0;
  static const setupHeroTextHeight = .9;
  static const setupHeroShadowOffset = Offset(3, 5);
  static const setupHeroShadowBlur = 5.0;
  static const setupTitleSpacing = 22.0;
  static const setupCompactTitleSpacing = 12.0;
  static const setupOptionsSpacing = 18.0;
  static const setupCompactOptionsSpacing = 12.0;
  static const setupActionSpacing = 10.0;
  static const setupCompactActionSpacing = 7.0;
  static const setupButtonTextSize = 16.0;
  static const setupButtonPadding = 18.0;
  static const setupCompactButtonPadding = 14.0;
  static const setupCardPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
  static const setupCardBottomMargin = 10.0;
  static const setupIndicatorSize = 30.0;
  static const setupPieceSize = 31.0;
  static const setupCardTextSize = 17.0;
  static const setupBrandSize = 31.0;
  static const setupCompactBrandSize = 26.0;
  static const setupBrandHorizontalPadding = 12.0;
  static const setupTaglineSize = 9.0;
  static const setupIndicatorBorderWidth = 2.0;
  static const setupSelectedIndicatorBorderWidth = 4.0;
  static const setupCardBorderWidth = 1.5;
  static const setupSelectedCardBorderWidth = 2.0;
  static const setupPieceGap = 20.0;
  static const setupIndicatorGap = 18.0;

  static const dialogMaxWidth = 520.0;
  static const dialogHorizontalInset = 18.0;
  static const dialogVerticalInset = 24.0;
  static const dialogTitleSize = 32.0;
  static const dialogWinnerSize = 24.0;
  static const dialogButtonTextSize = 16.0;
  static const dialogBorderWidth = 1.5;
  static const dialogShadowBlur = 28.0;
  static const dialogShadowSpread = 2.0;
  static const dialogTitleSpacing = 8.0;
  static const dialogWinnerSpacing = 20.0;
  static const dialogDividerPadding = 10.0;
  static const dialogActionSpacing = 22.0;
  static const dialogButtonGap = 12.0;
  static const dialogCardRadius = 28.0;
  static const dialogButtonRadius = 32.0;
  static const dialogContentPadding = EdgeInsets.fromLTRB(22, 28, 22, 22);
  static const dialogButtonPadding = EdgeInsets.symmetric(vertical: 16);
  static const dialogSecondaryButtonPadding = EdgeInsets.symmetric(
    vertical: 14,
  );

  static const boardHorizontalPadding = 12.0;
  static const boardTopPadding = 20.0;
  static const boardBottomPadding = 26.0;
  static const boardMaxWidth = 620.0;
  static const boardMinAvailableWidth = 0.0;
  static const boardContentHorizontalPadding = 12.0;
  static const boardContentTopPadding = 20.0;
  static const boardContentBottomPadding = 26.0;
  static const playerGapBeforeBoard = 14.0;
  static const boardGapAfterBoard = 18.0;
  static const statusGap = 12.0;
  static const actionsGap = 14.0;
  static const headerTopGap = 1.0;
  static const headerBottomGap = 9.0;
  static const headerBrandSize = 31.0;
  static const headerTaglineSize = 9.0;
  static const playerPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );
  static const playerAvatarSize = 52.0;
  static const playerAvatarBorderWidth = 2.0;
  static const playerTextSize = 17.0;
  static const playerMetaTextSize = 11.0;
  static const boardFramePadding = 10.0;
  static const boardFrameBorderWidth = 2.0;
  static const boardPieceTargetSize = 42.0;
  static const boardEmptyTargetSize = 15.0;
  static const boardTargetBorderWidth = 3.0;
  static const boardPieceTextHeight = .9;
  static const boardCoordinateTextSize = 9.0;
  static const statusDotSize = 10.0;
  static const statusTextSize = 14.0;
  static const moveCountTextSize = 11.0;

  static EdgeInsets setupPagePadding(bool compact) => EdgeInsets.fromLTRB(
    setupHorizontalPadding,
    compact ? setupCompactTopPadding : setupTopPadding,
    setupHorizontalPadding,
    setupBottomPadding,
  );

  static double setupHeroSizeFor(bool compact) =>
      compact ? setupCompactHeroSize : setupHeroSize;

  static double setupHeroPieceSizeFor(bool compact) =>
      compact ? setupCompactHeroPieceSize : setupHeroPieceSize;

  static double setupBrandSizeFor(bool compact) =>
      compact ? setupCompactBrandSize : setupBrandSize;

  static double setupButtonPaddingFor(bool compact) =>
      compact ? setupCompactButtonPadding : setupButtonPadding;
}
