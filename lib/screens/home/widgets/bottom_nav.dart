// lib/widgets/bottom_nav.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class BottomNavItemModel {
  final IconData icon;
  final String label;

  const BottomNavItemModel({required this.icon, required this.label});
}

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItemModel> items;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = const [
      BottomNavItemModel(icon: Icons.home_rounded, label: 'HOME'),
      BottomNavItemModel(icon: Icons.help_outline_rounded, label: 'QUIZ'),
      BottomNavItemModel(icon: Icons.person_outline_rounded, label: 'PROFILE'),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeColors.of(context);
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: themeColors.navBg,
        border: Border(top: BorderSide(color: themeColors.divider, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16), // ← equal top/bottom
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final active = i == currentIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i].icon,
                    color: active ? AppColors.primary : themeColors.stext,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i].label,
                    style: TextStyle(
                      color: active ? AppColors.primary : themeColors.stext,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
