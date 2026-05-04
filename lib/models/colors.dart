// lib/models/colors.dart

import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0B141E);
  static const Color cardBg = Color(0xFF112233);
  static const Color deepCard = Color(0xFF0F1E2D);
  static const Color navBg = Color(0xFF0F1E2D);
  static const Color hText = Colors.white;
  static const Color stext = Color(0xFF94A3B8);
  static const Color titleColor = Color(0xFF1DB954);
  static const Color iCOlor = Colors.white;
  static const Color primary = Color(0xFF19B357);
  static const Color dShade = Color(0xFFE6A817);
  static const Color doller = Color(0xFFFFD700);
  static const Color secondary = Color(0xFF059669);
  static const Color divider = Color(0xFF1E2D3D);
  static const Color shade = Colors.blueGrey;
  static const progess = Color(0xFF1F2937);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF19B357), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient iconBoxGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color outlineBorder = const Color(0xFF19B357).withValues(alpha: 0.56);
  static Color shadow = const Color(0xFF19B357).withValues(alpha: 0.35);
}

class ThemeColors {
  final Color background;
  final Color cardBg;
  final Color deepCard;
  final Color navBg;
  final Color hText;
  final Color stext;
  final Color divider;
  final Color primary;
  final Color doller;

  const ThemeColors._({
    required this.background,
    required this.cardBg,
    required this.deepCard,
    required this.navBg,
    required this.hText,
    required this.stext,
    required this.divider,
    required this.primary,
    required this.doller,
  });

  factory ThemeColors.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const ThemeColors._(
        background: Color(0xFF0B141E),
        cardBg: Color(0xFF112233),
        deepCard: Color(0xFF0F1E2D),
        navBg: Color(0xFF0F1E2D),
        hText: Colors.white,
        stext: Color(0xFF94A3B8),
        divider: Color(0xFF1E2D3D),
        primary: Color(0xFF19B357),
        doller: Color(0xFFFFD700),
      );
    } else {
      return const ThemeColors._(
        background: Color(0xFFF1F5F9),
        cardBg: Color(0xFFFFFFFF),
        deepCard: Color(0xFFE2E8F0),
        navBg: Color(0xFFFFFFFF),
        hText: Color(0xFF0F172A),
        stext: Color(0xFF64748B),
        divider: Color(0xFFE2E8F0),
        primary: Color(0xFF19B357),
        doller: Color(0xFFFFD700),
      );
    }
  }
}
