import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_game/controllers/notification_controller.dart';

class NotificationProvider extends ChangeNotifier {
  static const String _keyNotificationsEnabled = 'notifications_enabled';

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  final _controller = NotificationController();

  NotificationProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool(_keyNotificationsEnabled) ?? true;

    // If enabled, ensure they are scheduled (in case of reboot etc)
    if (_notificationsEnabled) {
      _scheduleAll();
    }

    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, value);

    if (value) {
      debugPrint('🔔 Enabling and scheduling notifications...');
      await _scheduleAll();
    } else {
      debugPrint('🔕 Disabling all notifications...');
      await _controller.cancelAllNotifications();
    }

    notifyListeners();
  }

  Future<void> _scheduleAll() async {
    // Remove old notifications first
    await _controller.cancelAllNotifications();

    debugPrint('⏰ Scheduling all daily notifications...');

    await _controller.scheduleDailyNotification(
      id: 1,
      title: 'Kick Off Your Day With Football Trivia',
      body: 'One quick game could push you to the top of the leaderboard.',
      hour: 7,
      minute: 0,
    );

    await _controller.scheduleDailyNotification(
      id: 2,
      title: 'Last Chance to Keep Your Streak',
      body:
          'Miss today and your streak resets. One match quiz is all it takes.',
      hour: 18,
      minute: 0,
    );
  }
}
