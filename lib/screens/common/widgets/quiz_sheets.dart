import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/level_overview_model.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/provider/theme_provider.dart';

class QuizSheets {
  /// Shows a centered Level Overview dialog
  static void showLevelOverview({
    required BuildContext context,
    required LevelOverviewModel model,
    required VoidCallback onPlay,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.7), // Dimmed background
      builder: (context) => Center(
        child: _BaseDialog(
          title: "LEVEL ${model.levelNumber}:",
          subtitle: model.levelName.toUpperCase(),
          description: model.description,
          starsEarned: model.starsEarned,
          onPlay: onPlay,
        ),
      ),
    );
  }

  /// Shows a centered Bonus Level dialog
  static void showBonusLevel({
    required BuildContext context,
    required int bonusNumber,
    required VoidCallback onPlay,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Center(
        child: _BaseDialog(
          title: "BONUS LEVEL",
          subtitle: "DOUBLE XP & COINS",
          description: "Test your football knowledge and earn extra rewards!",
          starsEarned: 0,
          isBonus: true,
          onPlay: onPlay,
        ),
      ),
    );
  }
}

class _BaseDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final int starsEarned;
  final bool isBonus;
  final VoidCallback onPlay;

  const _BaseDialog({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.starsEarned,
    this.isBonus = false,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeColors.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85, // Centered width
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: themeColors.cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(height: 10),
            _buildTitle(context),
            const SizedBox(height: 20),
            _buildStars(context),
            const SizedBox(height: 24),
            _buildDescription(context),
            const SizedBox(height: 32),
            _buildPlayButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Align(
    alignment: Alignment.topRight,
    child: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ThemeColors.of(context).hText.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          color: ThemeColors.of(context).hText.withValues(alpha: 0.54),
          size: 20,
        ),
      ),
    ),
  );

  Widget _buildTitle(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          "LEVEL OVERVIEW",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Text(
        title,
        style: TextStyle(
          color: ThemeColors.of(context).hText.withValues(alpha: 0.7),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ThemeColors.of(context).hText,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    ],
  );

  Widget _buildStars(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index) {
      bool isFilled = isBonus ? (index == 1) : (index < starsEarned);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          isBonus ? Icons.star : Icons.star_rounded,
          size: isBonus && index == 1 ? 48 : 40,
          color: isFilled
              ? AppColors.doller
              : ThemeColors.of(context).hText.withValues(alpha: 0.05),
        ),
      );
    }),
  );

  Widget _buildDescription(BuildContext context) => Text(
    description,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: ThemeColors.of(context).hText.withValues(alpha: 0.6),
      fontSize: 14,
      height: 1.5,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _buildPlayButton(BuildContext context) => GestureDetector(
    onTap: () {
      Navigator.pop(context);
      onPlay();
    },
    child: Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "PLAY",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
    ),
  );
}
