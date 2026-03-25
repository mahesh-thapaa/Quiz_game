// lib/models/powerup_model.dart

enum PowerupType { hint, fiftyFifty, skip }

class PowerupModel {
  final PowerupType type;
  final String label;
  final String countLabel;
  final bool isUsed;

  const PowerupModel({
    required this.type,
    required this.label,
    required this.countLabel,
    this.isUsed = false,
  });
}
