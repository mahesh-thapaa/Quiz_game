// lib/widgets/star_rating.dart

import 'package:flutter/material.dart';
import '../models/colors.dart';

class StarRating extends StatelessWidget {
  final int stars;
  final int maxStars;
  final double size;

  const StarRating({
    super.key,
    required this.stars,
    this.maxStars = 3,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (i) {
        return Icon(
          Icons.star_rounded,
          size: size,
          color: i < stars ? AppColors.doller : Colors.white.withOpacity(0.15),
        );
      }),
    );
  }
}
