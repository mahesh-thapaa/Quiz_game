import 'package:flutter/material.dart';

class LockedCategoryModel {
  final String title;
  final String unlockText;
  final String imageUrl;
  final String snackbarMessage;
  final Color snackbarColor;
  final bool requiresCoins;
  final String categoryId;
  final String firestoreName;
  final int unlockValue;

  LockedCategoryModel({
    required this.title,
    required this.snackbarColor,
    required this.snackbarMessage,
    required this.unlockText,
    required this.imageUrl,
    required this.categoryId,
    required this.firestoreName,
    required this.unlockValue,
    this.requiresCoins = false,
  });
}
