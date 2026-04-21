// lib/painters/confetti_painter.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:quiz_game/models/confetti_particle.dart';

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress; // 0.0 → 1.0, loops

  const ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Each particle has its own phase so they don't all move in sync.
      final t = ((progress * p.speed + p.delay) % 1.0);
      if (t < 0.05) continue; // hide the teleport-back moment

      final x = p.x * size.width;
      final y = t * (size.height + 20) - 10;
      final angle = p.rotation + t * p.rotationSpeed * math.pi * 2;
      final opacity = (1.0 - t * 0.6).clamp(0.0, 1.0);

      final paint = Paint()..color = p.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      if (p.isRect) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size * 0.5, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter old) => old.progress != progress;
}
