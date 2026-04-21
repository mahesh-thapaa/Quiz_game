// lib/models/confetti_particle.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiParticle {
  final double x;
  final double delay;
  final double speed;
  final double size;
  final Color color;
  final double rotation;
  final double rotationSpeed;
  final bool isRect;

  const ConfettiParticle({
    required this.x,
    required this.delay,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.isRect,
  });

  static const List<Color> _defaultColors = [
    Color(0xFFFFD700),
    Color(0xFF19B357),
    Color(0xFFFF6B6B),
    Color(0xFF4FC3F7),
    Color(0xFFCE93D8),
    Color(0xFFFFAB40),
  ];

  factory ConfettiParticle.random({List<Color>? colors}) {
    final rng = math.Random();
    final palette = colors ?? _defaultColors;
    return ConfettiParticle(
      x: rng.nextDouble(),
      delay: rng.nextDouble(),
      speed: 0.4 + rng.nextDouble() * 0.6,
      size: 5 + rng.nextDouble() * 6,
      color: palette[rng.nextInt(palette.length)],
      rotation: rng.nextDouble() * math.pi * 2,
      rotationSpeed: (rng.nextDouble() - 0.5) * 6,
      isRect: rng.nextBool(),
    );
  }

  static List<ConfettiParticle> generate({
    int count = 28,
    List<Color>? colors,
  }) {
    return List.generate(count, (_) => ConfettiParticle.random(colors: colors));
  }
}
