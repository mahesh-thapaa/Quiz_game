// lib/data/discover_data.dart

// import 'package:quiz_game/models/discover_models.dart';
import 'package:flutter/material.dart';
import 'package:quiz_game/models/discover/discover_models.dart';

class DiscoverData {
  static List<DiscoverModels> getChallenges() {
    return [
      DiscoverModels(
        title: "Ballon d'Or Quiz",
        imagePath: "asstes/images/ballon.jpg",
        unlockType: UnlockType.level,
        snackbarMessage: "Level 10 Required",
        snackbarColor: Colors.blue,
        unlockText: "Level 10 Required",
      ),
      DiscoverModels(
        title: "World Cup",
        imagePath: "asstes/images/world.jpg",
        snackbarMessage: "2000 Coins Requied",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.coins,
        unlockText: "2000 Coins",
      ),
      DiscoverModels(
        title: "Goalkeeper Legends",
        imagePath: "asstes/images/goalkeeper.png",
        snackbarMessage: "Level 15 Required",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.level,
        unlockText: "Level 15 Required",
      ),
      DiscoverModels(
        title: "Golden Boot",
        imagePath: "asstes/images/goldenboot.jpg",
        snackbarMessage: "1000 Coins",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.coins,
        unlockText: "1000 Coins",
      ),
      DiscoverModels(
        title: "Derby Rivalries",
        imagePath: "asstes/images/derby.jpg",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
      ),
      DiscoverModels(
        title: "Tactics Quiz",
        imagePath: "asstes/images/tactuse.png",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
      ),
      DiscoverModels(
        title: "Top Assists Quiz",
        imagePath: "asstes/images/assists.png",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
      ),
      DiscoverModels(
        title: "Historic Finals",
        imagePath: "asstes/images/finals.jpg",
        snackbarMessage: "Comming Soon",
        snackbarColor: Colors.blue,
        unlockType: UnlockType.comingSoon,
      ),
    ];
  }
}
