import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/player_quiz/player_level_tile.dart';
import 'package:quiz_game/models/club/level_overview_model.dart';
import 'widgets/level_tile.dart';
import 'package:quiz_game/screens/player_quiz/player_quiz_gameplay/player_quiz_gameplay_screen.dart';

import 'widgets/level_overview_sheet.dart';

class PlayerScreenQuiz extends StatefulWidget {
  const PlayerScreenQuiz({super.key});

  @override
  State<PlayerScreenQuiz> createState() => _PlayerScreenQuizState();
}

class _PlayerScreenQuizState extends State<PlayerScreenQuiz> {
  late List<ProfileLevel> block1Items;
  late List<ProfileLevel> block2Items;

  @override
  void initState() {
    super.initState();
    block1Items = _generateLevelBlock(startLevel: 1); // Levels 1 to 20
    block2Items = _generateLevelBlock(startLevel: 21); // Levels 21 to 40
  }

  List<ProfileLevel> _generateLevelBlock({required int startLevel}) {
    List<ProfileLevel> items = [];
    int currentLevel = startLevel;

    for (int i = 0; i < 24; i++) {
      if (i == 5 || i == 11 || i == 17 || i == 23) {
        items.add(ProfileLevel(hasStar: true));
      } else {
        items.add(
          ProfileLevel(
            number: currentLevel,
            isCurrent: currentLevel == 1,
            isUnlocked: currentLevel <= 3, // Unlock first 3 levels
            starsEarned: currentLevel == 1 ? 2 : 0,
          ),
        );
        currentLevel++;
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: _buildGridSection(block1Items),
            ),

            SliverToBoxAdapter(child: _buildMilestoneSeparator()),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              sliver: _buildGridSection(block2Items),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.iCOlor,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOALIQ',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.stext,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                ' PLAYER QUIZ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.hText,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildStatChip(Icons.star_rounded, '2', AppColors.doller),
          const SizedBox(width: 8),
          _buildStatChip(
            Icons.monetization_on_rounded,
            '640 +',
            AppColors.doller,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.stext,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneSeparator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: const Column(
        children: [
          Text(
            'Earn at least 1 star in previous level to\nunlock',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.stext, height: 1.5),
          ),
          SizedBox(height: 36),
          Text(
            'Unlock Next Level with 50 ★ Stars',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.stext,
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildGridSection(List<ProfileLevel> items) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = items[index];
        return LevelTile(
          level: item,
          onTap: () {
            if (item.isUnlocked && !item.hasStar) {
              // 🚀 SHOW THE DIALOG WHEN LEVEL IS TAPPED
              showLevelOverview(
                context: context,
                model: LevelOverviewModel(
                  levelNumber: item.number ?? 1,
                  levelName: 'ROOKIE CHALLENGE',
                  starsEarned: item.starsEarned,
                  description:
                      'Test your knowledge on football clubs.\nTry to earn 3 stars',
                ),
                onPlay: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlayerQuizGameplayScreen(),
                    ),
                  );
                },
              );
            } else if (item.hasStar) {
              print('Tapped Bonus Level!');
            }
          },
        );
      }, childCount: items.length),
    );
  }
}
