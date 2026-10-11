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
  );
}
