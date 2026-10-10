import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/banner_ad_widget.dart';
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: AppColors.blackPiece,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
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
                          const SizedBox(height: 3),
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
                    ],
                  ),
                  const SizedBox(height: 42),
                  Text(
                    l10n.chooseDifficulty,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.computer}  ·  ${l10n.black}',
                    style: const TextStyle(
                      color: AppColors.textSubtle,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (var index = 0; index < options.length; index++)
                    _difficultyCard(
                      options[index].$1,
                      options[index].$2,
                      options[index].$3,
                      index + 1,
                    ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ChessScreen(difficulty: selected),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(l10n.startGame),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.blackPiece,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(child: BannerAdWidget()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _difficultyCard(
    AiDifficulty difficulty,
    String title,
    String description,
    int level,
  ) {
    final isSelected = selected == difficulty;
    return GestureDetector(
      onTap: () => setState(() => selected = difficulty),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.successBackground : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$level',
                style: TextStyle(
                  color: isSelected
                      ? AppColors.blackPiece
                      : AppColors.textMuted,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                for (var index = 0; index < 5; index++)
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      color: index < level
                          ? AppColors.accent
                          : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
