import 'package:flutter/widgets.dart';
import 'package:quiz_game/controllers/notification_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSchedule {
  final int id;
  final int hour;
  final int minute;
  final String title;
  final String body;

  const NotificationSchedule({
    required this.id,
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
  });
}

class NotificationProvider extends ChangeNotifier with WidgetsBindingObserver {
  static const String _prefsKey = 'notifications_enabled';

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  final NotificationController _controller = NotificationController();

  static const List<NotificationSchedule> schedules = [
    NotificationSchedule(
      id: 101,
      hour: 7,
      minute: 0,
      title: 'Kick Off Your Day With Football Trivia',
      body: 'One quick game could push you to the top of the leaderboard.',
    ),
    NotificationSchedule(
      id: 102,
      hour: 18,
      minute: 0,
      title: 'Last Chance to Keep Your Streak',
      body:
          'Miss today and your streak resets. One match quiz is all it takes.',
    ),
  ];

  NotificationProvider() {
    WidgetsBinding.instance.addObserver(this);
    _loadPrefs();
  }

  /// Must be called during app initialization (e.g. in main.dart)
  Future<void> init() async {
    // Ensure NotificationController (and timezones) are initialized first
    final hasPermission = await _controller.init();

    if (!hasPermission) {
      _notificationsEnabled = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, false);
      notifyListeners();
      return;
    }

    if (_notificationsEnabled) {
      await _scheduleAll();
    }
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool(_prefsKey) ?? true;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _notificationsEnabled) {
      _onAppResumed();
    }
  }

  Future<void> _onAppResumed() async {
    if (_notificationsEnabled) {
      // Re-schedule daily alarms on resume to keep repeat timers accurate across OS timezone changes
      await _scheduleAll();
    }
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);

    if (value) {
      if (!_controller.hasPermission) {
        final granted = await _controller.init();
        if (!granted) {
          _notificationsEnabled = false;
          await prefs.setBool(_prefsKey, false);
          notifyListeners();
          return;
        }
      }
      await _scheduleAll();
    } else {
      await _controller.cancelAllNotifications();
    }

    notifyListeners();
  }

  Future<void> _scheduleAll() async {
    // Cancel existing schedules first to prevent duplicate pending alarms
    await _controller.cancelAllNotifications();

    for (final s in schedules) {
      await _controller.scheduleDailyNotification(
        id: s.id,
        title: s.title,
        body: s.body,
        hour: s.hour,
        minute: s.minute,
      );
    }
  }
}
