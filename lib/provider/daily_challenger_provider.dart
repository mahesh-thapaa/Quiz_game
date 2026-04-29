import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_game/controllers/daily_challenger_controller.dart';

class DailyChallengerProvider extends ChangeNotifier {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  Duration get remaining => _remaining;

  DailyChallengerProvider() {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  void _update() {
    _remaining = DailyChallengerController.getRemainingTime();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
