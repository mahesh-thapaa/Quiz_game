import 'package:flutter/material.dart';

enum UnlockType { level, coins, comingSoon }

class DiscoverModels {
  final String title;
  final String snackbarMessage;
  final Color snackbarColor;
  final String imagePath;
  final UnlockType unlockType;
  final String? unlockText;

  DiscoverModels({
    required this.title,
    required this.imagePath,
    required this.snackbarColor,
    required this.snackbarMessage,
    required this.unlockType,
    this.unlockText,
  });
}
