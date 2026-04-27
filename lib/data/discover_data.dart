// lib/data/discover_data.dart

// import 'package:quiz_game/models/discover_models.dart';
import 'package:flutter/material.dart';
import 'package:quiz_game/models/discover/discover_models.dart';

class DiscoverData {
  static List<DiscoverModels> getChallenges() {
    return [
      DiscoverModels(
        title: "Ballon d'Or Quiz",
        categoryId: "ballon_dor_quiz",
        firestoreName: "Ballon d'Or Quiz",
        imagePath: "asstes/images/ballon.jpg",
        unlockType: UnlockType.level,
        snackbarMessage: "Level 9 Required",
        snackbarColor: Colors.blue,
        unlockText: "Level 9 Required",
        unlockValue: 9,
      ),
      DiscoverModels(
        title: "World Cup",
        categoryId: "world_cup_quiz",
        firestoreName: "World Cup",
        imagePath: "asstes/images/world.jpg",
        snackbarMessage: "10000 Coins Requied",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.coins,
        unlockText: "10000 Coins",
        unlockValue: 10000,
      ),
      DiscoverModels(
        title: "Goalkeeper Legends",
        categoryId: "goalkeeper_legends",
        firestoreName: "Goalkeeper Legends",
        imagePath: "asstes/images/goalkeeper.png",
        snackbarMessage: "Level 11 Required",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.level,
        unlockText: "Level 11 Required",
        unlockValue: 11,
      ),
      DiscoverModels(
        title: "Golden Boot",
        categoryId: "golden_boot_quiz",
        firestoreName: "Golden Boot",
        imagePath: "asstes/images/goldenboot.jpg",
        snackbarMessage: "1000 Coins",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.coins,
        unlockText: "20000 Coins",
        unlockValue: 20000,
      ),
      DiscoverModels(
        title: "Derby Rivalries",
        categoryId: "derby_rivalries",
        firestoreName: "Derby Rivalries",
        imagePath: "asstes/images/derby.jpg",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
      ),
      DiscoverModels(
        title: "Tactics Quiz",
        categoryId: "tactics_quiz",
        firestoreName: "Tactics Quiz",
        imagePath: "asstes/images/tactuse.png",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
      ),
      DiscoverModels(
        title: "Top Assists Quiz",
        categoryId: "top_assists_quiz",
        firestoreName: "Top Assists Quiz",
        imagePath: "asstes/images/assists.png",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
      ),
      DiscoverModels(
        title: "Historic Finals",
        categoryId: "historic_finals",
        firestoreName: "Historic Finals",
        imagePath: "asstes/images/finals.jpg",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
      ),
    ];
  }
}
