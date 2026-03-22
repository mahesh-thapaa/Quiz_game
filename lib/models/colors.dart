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
