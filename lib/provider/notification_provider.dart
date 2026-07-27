// notification_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_game/controllers/notification_controller.dart';

class NotificationProvider extends ChangeNotifier with WidgetsBindingObserver {
  static const String _prefsKey = 'notifications_enabled';

  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  final NotificationController _controller = NotificationController();

  NotificationProvider() {
    WidgetsBinding.instance.addObserver(this);
    _loadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _notificationsEnabled) {
      _rescheduleIfMissing();
    }
  }

  Future<void> _rescheduleIfMissing() async {
    final pendingCount = await _controller.getPendingCount();
    if (pendingCount < 2) {
      debugPrint('Notifications missing ($pendingCount pending), re-scheduling...');
      await scheduleAllNotifications();
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _notificationsEnabled = prefs.getBool(_prefsKey) ?? true;

    if (_notificationsEnabled) {
      await scheduleAllNotifications();
    }

    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_prefsKey, value);

    if (value) {
      debugPrint('🔔 Notifications Enabled');

      await scheduleAllNotifications();
    } else {
      debugPrint('🔕 Notifications Disabled');

      await _controller.cancelAllNotifications();
    }

    notifyListeners();
  }

  Future<void> scheduleAllNotifications() async {
    await _controller.cancelAllNotifications();

    await _controller.scheduleDailyNotification(
      id: 101,
      title: 'Kick Off Your Day With Football Trivia',
      body: 'One quick game could push you to the top of the leaderboard.',
      hour: 7,
      minute: 0,
    );

    await _controller.scheduleDailyNotification(
      id: 102,
      title: 'Last Chance to Keep Your Streak',
      body:
          'Miss today and your streak resets. One match quiz is all it takes.',
      hour: 18,
      minute: 0,
    );

    await _controller.printPendingNotifications();
  }

  // Future<void> sendNewEventNotification() async {
  //   await _controller.showInstantNotification(
  //     id: 999,
  //     title: '⚽ New Football Tournament',
  //     body: 'Play now and earn bonus coins!',
  //   );
  // }
}
