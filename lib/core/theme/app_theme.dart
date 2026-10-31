import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(fontFamily: 'serif'),
      headlineMedium: TextStyle(fontFamily: 'serif'),
    ),
    useMaterial3: true,
    extensions: const [WebChessTheme()],
  );
}

@immutable
class WebChessTheme extends ThemeExtension<WebChessTheme> {
  const WebChessTheme({
    this.page = const Color(0xFF0B1220),
    this.hero = const Color(0xFF17243A),
    this.surface = const Color(0xFF111A2B),
    this.ink = const Color(0xFFF6F8FC),
    this.muted = const Color(0xFF9AAAC0),
    this.accent = AppColors.gold,
    this.border = const Color(0xFF2A3A52),
    this.selectedSurface = const Color(0xFF263C57),
  });

  final Color page;
  final Color hero;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color accent;
  final Color border;
  final Color selectedSurface;

  @override
  WebChessTheme copyWith({
    Color? page,
    Color? hero,
    Color? surface,
    Color? ink,
    Color? muted,
    Color? accent,
    Color? border,
    Color? selectedSurface,
  }) => WebChessTheme(
    page: page ?? this.page,
    hero: hero ?? this.hero,
    surface: surface ?? this.surface,
    ink: ink ?? this.ink,
    muted: muted ?? this.muted,
    accent: accent ?? this.accent,
    border: border ?? this.border,
    selectedSurface: selectedSurface ?? this.selectedSurface,
  );

  @override
  WebChessTheme lerp(ThemeExtension<WebChessTheme>? other, double t) {
    if (other is! WebChessTheme) return this;
    return WebChessTheme(
      page: Color.lerp(page, other.page, t)!,
      hero: Color.lerp(hero, other.hero, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      border: Color.lerp(border, other.border, t)!,
      selectedSurface: Color.lerp(selectedSurface, other.selectedSurface, t)!,
    );
  }
}
