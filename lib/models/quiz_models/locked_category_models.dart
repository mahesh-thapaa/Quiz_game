import 'package:flutter/material.dart';

class LockedCategoryModel {
  final String title;
  final String unlockText;
  final String imagePath;
  final String snackbarMessage;
  final Color snackbarColor;
  final bool requiresCoins;
  final String categoryId;
  final String firestoreName;

  LockedCategoryModel({
    required this.title,
    required this.snackbarColor,
    required this.snackbarMessage,
    required this.unlockText,
    required this.imagePath,
    required this.categoryId,
    required this.firestoreName,
    this.requiresCoins = false,
  });
}
