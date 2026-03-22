// lib/data/discover_data.dart

// import 'package:quiz_game/models/discover_models.dart';
import 'package:quiz_game/models/discover/discover_models.dart';

class DiscoverData {
  static List<ChallengeModel> getChallenges() {
    return [
      ChallengeModel(
        title: "Ballon d'Or Quiz",
        imagePath: "asstes/images/ballon.jpg",
        unlockType: UnlockType.level,
        unlockText: "Level 10 Required",
      ),
      ChallengeModel(
        title: "World Cup",
        imagePath: "asstes/images/world.jpg",
        unlockType: UnlockType.coins,
        unlockText: "2000 Coins",
      ),
      ChallengeModel(
        title: "Goalkeeper Legends",
        imagePath: "asstes/images/goalkeeper.png",
        unlockType: UnlockType.level,
        unlockText: "Level 15 Required",
      ),
      ChallengeModel(
        title: "Golden Boot",
        imagePath: "asstes/images/goldenboot.jpg",
        unlockType: UnlockType.coins,
        unlockText: "1000 Coins",
      ),
      ChallengeModel(
        title: "Derby Rivalries",
        imagePath: "asstes/images/derby.jpg",
        unlockType: UnlockType.comingSoon,
      ),
      ChallengeModel(
        title: "Tactics Quiz",
        imagePath: "asstes/images/tactuse.png",
        unlockType: UnlockType.comingSoon,
      ),
      ChallengeModel(
        title: "Top Assists Quiz",
        imagePath: "asstes/images/assists.png",
        unlockType: UnlockType.comingSoon,
      ),
      ChallengeModel(
        title: "Historic Finals",
        imagePath: "asstes/images/finals.jpg",
        unlockType: UnlockType.comingSoon,
      ),
    ];
  }
}
