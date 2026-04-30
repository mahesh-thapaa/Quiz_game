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
    debugPrint('⏰ Scheduling all daily notifications...');
    // 7:00 AM Daily Challenge
    await _controller.scheduleDailyNotification(
      id: 1,
      title: 'Daily Challenge Started',
      body: 'Jump in and complete today\'s challenge!',
      hour: 7,
      minute: 0,
    );

    // 6:00 PM Keep Streak Alive
    await _controller.scheduleDailyNotification(
      id: 2,
      title: 'Keep Streak Alive',
      body: 'Don\'t forget to play a game to maintain your streak!',
      hour: 18,
      minute: 0,
    );
    await _controller.scheduleDailyNotification(
      id: 3,
      title: 'Test Notification',
      body: 'This is a test notification.',
      hour: 11,
      minute: 50,
    );
  }

  /// Explanation for adding others:
  /// To add more notifications, simply call _controller.scheduleDailyNotification
  /// with a unique ID and your desired time/content within the _scheduleAll method.
  /// You can also create other methods in the controller for one-time notifications
  /// or weekly reminders by changing the matchDateTimeComponents parameter.
}
