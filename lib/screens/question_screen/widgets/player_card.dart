import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String image;

  const PlayerCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
}
