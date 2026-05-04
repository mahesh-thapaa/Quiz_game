// lib/screens/main_screen/main_screen.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/home/home_screen.dart';
import 'package:quiz_game/screens/Quiz_screen/quiz_screen.dart';
import 'package:quiz_game/screens/profile/profile_screen/profile_screen.dart';
import 'package:quiz_game/screens/home/widgets/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final Set<int> _visitedIndexes = {0};

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const QuizScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: ThemeColors.of(context).background,
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(screens.length, (index) {
          if (!_visitedIndexes.contains(index)) {
            return const SizedBox.shrink();
          }
          return screens[index];
        }),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _visitedIndexes.add(index);
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
