// lib/models/discover/discover_models.dart

import 'package:flutter/material.dart';

enum UnlockType { level, coins, comingSoon }

class DiscoverModels {
  final String title;
  final String categoryId;
  final String firestoreName;
  final String snackbarMessage;
  final Color snackbarColor;
  final String imagePath;
  final UnlockType unlockType;
  final String? unlockText;
  final int? unlockValue;

  DiscoverModels({
    required this.title,
    required this.categoryId,
    required this.firestoreName,
    required this.imagePath,
    required this.snackbarColor,
    required this.snackbarMessage,
    required this.unlockType,
    this.unlockText,
    this.unlockValue,
  });
}
