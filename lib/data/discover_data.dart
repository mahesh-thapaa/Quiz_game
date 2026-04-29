// lib/data/discover_data.dart

// import 'package:quiz_game/models/discover_models.dart';
import 'package:flutter/material.dart';
import 'package:quiz_game/models/discover/discover_models.dart';
import 'package:quiz_game/api_keys.dart';

class DiscoverData {
  static List<DiscoverModels> getChallenges() {
    return [
      DiscoverModels(
        id: "ballon_dor_quiz",
        title: "Ballon d'Or Quiz",
        categoryId: "ballon_dor_quiz",
        firestoreName: "Ballon d'Or Quiz",
        imageUrl: "${ApiKeys.cloudinaryBaseUrl}ballon_dor_quiz_thumbnail.jpg",
        unlockType: UnlockType.level,
        snackbarMessage: "220 Star Required to Unlock Ballon d'Or Quiz!",
        snackbarColor: Colors.blue,
        unlockText: "220 Star",
        unlockValue: 220,
        createdAt: DateTime.now(),
      ),
      DiscoverModels(
        id: "world_cup_quiz",
        title: "World Cup",
        categoryId: "world_cup_quiz",
        firestoreName: "World Cup",
        imageUrl: "${ApiKeys.cloudinaryBaseUrl}world_cup_quiz_thumbnail.jpg",
        snackbarMessage: "35000 Coins Required to Unlock World Cup!",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.coins,
        unlockText: "35000 Coins",
        unlockValue: 35000,
        createdAt: DateTime.now(),
      ),
      DiscoverModels(
        id: "goalkeeper_legends",
        title: "Goalkeeper Legends",
        categoryId: "goalkeeper_legends",
        firestoreName: "Goalkeeper Legends",
        imageUrl: "${ApiKeys.cloudinaryBaseUrl}goalkeeper_legends_thumbnail.jpg",
        snackbarMessage: "250 Star Required to Unlock Goalkeeper Legends!",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.level,
        unlockText: "250 Star",
        unlockValue: 250,
        createdAt: DateTime.now(),
      ),
      DiscoverModels(
        id: "golden_boot_quiz",
        title: "Golden Boot",
        categoryId: "golden_boot_quiz",
        firestoreName: "Golden Boot",
        imageUrl: "${ApiKeys.cloudinaryBaseUrl}golden_boot_quiz_thumbnail.jpg",
        snackbarMessage: "450000 Coins Required to Unlock Golden Boot!",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.coins,
        unlockText: "450000 Coins",
        unlockValue: 450000,
        createdAt: DateTime.now(),
      ),
      DiscoverModels(
        id: "derby_rivalries",
        title: "Derby Rivalries",
        categoryId: "derby_rivalries",
        firestoreName: "Derby Rivalries",
        imageUrl: "${ApiKeys.cloudinaryBaseUrl}derby_rivalries_thumbnail.jpg",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
        createdAt: DateTime.now(),
      ),
      DiscoverModels(
        id: "tactics_quiz",
        title: "Tactics Quiz",
        categoryId: "tactics_quiz",
        firestoreName: "Tactics Quiz",
        imageUrl: "${ApiKeys.cloudinaryBaseUrl}tactics_quiz_thumbnail.jpg",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
        createdAt: DateTime.now(),
      ),
      DiscoverModels(
        id: "top_assists_quiz",
        title: "Top Assists Quiz",
        categoryId: "top_assists_quiz",
        firestoreName: "Top Assists Quiz",
        imageUrl: "${ApiKeys.cloudinaryBaseUrl}top_assists_quiz_thumbnail.jpg",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
        createdAt: DateTime.now(),
      ),
      DiscoverModels(
        id: "historic_finals",
        title: "Historic Finals",
        categoryId: "historic_finals",
        firestoreName: "Historic Finals",
        imageUrl: "${ApiKeys.cloudinaryBaseUrl}historic_finals_thumbnail.jpg",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
        createdAt: DateTime.now(),
      ),
    ];
  }
}
