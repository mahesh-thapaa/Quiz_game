// lib/models/discover/discover_models.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UnlockType { level, coins, comingSoon }

class DiscoverModels {
  final String id;
  final String title;
  final String categoryId;
  final String firestoreName;
  final String snackbarMessage;
  final Color snackbarColor;
  final String imageUrl;
  final UnlockType unlockType;
  final String? unlockText;
  final int? unlockValue;
  final DateTime createdAt;

  DiscoverModels({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.firestoreName,
    required this.imageUrl,
    required this.snackbarColor,
    required this.snackbarMessage,
    required this.unlockType,
    required this.createdAt,
    this.unlockText,
    this.unlockValue,
  });

  factory DiscoverModels.fromFirestore(Map<String, dynamic> data, String id) {
    final bool isComingSoon = data['isComingSoon'] ?? false;
    final int coinCost = data['coinCost'] ?? 0;
    final int levelReq = data['levelRequired'] ?? 0;

    UnlockType type = UnlockType.level;
    String unlockText = "";
    int unlockValue = 0;
    String snackMsg = "";

    if (isComingSoon) {
      type = UnlockType.comingSoon;
      snackMsg = "Coming Soon";
    } else if (coinCost > 0) {
      type = UnlockType.coins;
      unlockText = "$coinCost Coins";
      unlockValue = coinCost;
      snackMsg = "$coinCost Coins required to unlock this level";
    } else {
      type = UnlockType.level;
      unlockText = "$levelReq Star";
      unlockValue = levelReq;
      snackMsg = "$levelReq Star required to unlock this level";
    }

    return DiscoverModels(
      id: id,
      title: data['title'] ?? '',
      categoryId: id,
      firestoreName: data['title'] ?? '',
      imageUrl: ((data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty)
              ? data['imageUrl']
              : (data['imagePath'] ?? ''))
          .toString()
          .replaceAll('asstes/', 'assets/'),
      snackbarColor: Colors.blue,
      snackbarMessage: snackMsg,
      unlockType: type,
      unlockText: unlockText,
      unlockValue: unlockValue,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
