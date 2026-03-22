// lib/screens/playerQuizScreen/player_quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/level.dart';
// import 'package:quiz_game/models/level_overview_model.dart';
import 'package:quiz_game/screens/playerQuizScreen/widgets.dart/level_tile.dart';
// import 'package:quiz_game/screens/playerQuizScreen/widgets.dart/level_overview_sheet.dart'; // ✅ THIS is the fix

class PlayerQuizScreen extends StatelessWidget {
  const PlayerQuizScreen({super.key});

  List<Level> generateLevels() {
    return List.generate(24, (index) {
      int num = index + 1;
      return Level(
        number: num,
        isUnlocked: num <= 3,
        hasStar: [6, 11, 16, 21].contains(num),
        isCurrent: num == 1,
        starsEarned: num == 1 ? 2 : 0,
        name: _levelName(num),
      );
    });
  }

  String _levelName(int num) {
    const names = {
      1: 'Rookie Challenge',
      2: 'Rising Star',
      3: 'Mid-Table',
      4: 'Top Flight',
      5: 'Champions',
    };
    return names[num] ?? 'Level $num';
  }

  @override
  Widget build(BuildContext context) {
    final levels = generateLevels();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.iCOlor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GOALIQ',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.stext,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'PLAYER QUIZ',
              style: TextStyle(
                color: AppColors.hText,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.dShade.withValues(alpha: 0.4),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.star_rounded, color: AppColors.doller, size: 14),
                SizedBox(width: 4),
                Text(
                  '2',
                  style: TextStyle(
                    color: AppColors.hText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.dShade.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '640',
                  style: TextStyle(
                    color: AppColors.hText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 2),
                const Text(
                  '+',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: levels.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final level = levels[index];
                  return LevelTile(
                    level: level,
                    // onTap: () => _onLevelTap(context, level),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20, top: 8),
              child: Column(
                children: [
                  Text(
                    'Earn at least 1 star in previous level to unlock',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.stext, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Unlock Next Level with 50 ★ Stars',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.stext,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _onLevelTap(BuildContext context, Level level) {
  //   showLevelOverview(
  //     context: context,
  //     model: LevelOverviewModel(
  //       levelNumber: level.number,
  //       levelName: level.name,
  //       starsEarned: level.starsEarned,
  //       description:
  //           'Test your knowledge on football players.\nTry to earn 3 stars',
  //     ),
  //     onPlay: () {},
  //   );
  // }
}
