// lib/screens/main_screen/main_screen.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/home/home_screen.dart';
import 'package:quiz_game/screens/Quiz_screen/quiz_screen.dart';
import 'package:quiz_game/screens/profile/profile_screen.dart';
import 'package:quiz_game/screens/home/widgets/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final Set<int> _visitedIndexes = {0}; // only build screens that were visited

  final _screens = const [HomeScreen(), QuizScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_screens.length, (index) {
          if (!_visitedIndexes.contains(index)) {
            return const SizedBox.shrink();
          }
          return _screens[index];
        }),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _visitedIndexes.add(index); // mark as visited before switching
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
