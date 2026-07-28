import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() => _instance;

  NotificationController._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _permissionGranted = false;

  bool get isInitialized => _initialized;
  bool get hasPermission => _permissionGranted;

  static const String _dailyChannelId = 'football_quiz_daily_v2';
  static const String _dailyChannelName = 'Football Quiz Daily Notifications';
  static const String _dailyChannelDesc = 'Daily football quiz reminders';

  static const String _instantChannelId = 'football_quiz_instant_v1';
  static const String _instantChannelName =
      'Football Quiz Instant Notifications';
  static const String _instantChannelDesc = 'Instant football quiz alerts';

  static const AndroidNotificationDetails _dailyAndroidDetails =
      AndroidNotificationDetails(
    _dailyChannelId,
    _dailyChannelName,
    channelDescription: _dailyChannelDesc,
    importance: Importance.max,
    priority: Priority.high,
  );

  static const AndroidNotificationDetails _instantAndroidDetails =
      AndroidNotificationDetails(
    _instantChannelId,
    _instantChannelName,
    channelDescription: _instantChannelDesc,
    importance: Importance.max,
    priority: Priority.high,
  );

  static const NotificationDetails _dailyDetails = NotificationDetails(
    android: _dailyAndroidDetails,
    iOS: DarwinNotificationDetails(),
  );

  static const NotificationDetails _instantDetails = NotificationDetails(
    android: _instantAndroidDetails,
    iOS: DarwinNotificationDetails(),
  );

  Future<bool> init() async {
    if (_initialized) return _permissionGranted;

    try {
      tz.initializeTimeZones();
      final String deviceTimezone = DateTime.now().timeZoneName;
      try {
        tz.setLocalLocation(tz.getLocation(deviceTimezone));
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }
    } catch (e) {
      debugPrint('Timezone initialization warning: $e');
    }

    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      _permissionGranted =
          await androidImpl.requestNotificationsPermission() ?? false;

      final canScheduleExact =
          await androidImpl.canScheduleExactNotifications();
      if (canScheduleExact != true) {
        await androidImpl.requestExactAlarmsPermission();
      }

      await androidImpl.createNotificationChannel(
        const AndroidNotificationChannel(
          _dailyChannelId,
          _dailyChannelName,
          description: _dailyChannelDesc,
          importance: Importance.max,
        ),
      );
      await androidImpl.createNotificationChannel(
        const AndroidNotificationChannel(
          _instantChannelId,
          _instantChannelName,
          description: _instantChannelDesc,
          importance: Importance.max,
        ),
      );
    } else {
      _permissionGranted = true;
    }

    _initialized = true;
    return _permissionGranted;
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _dailyDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {}
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _instantDetails,
      );
    } catch (_) {}
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  Future<int> getPendingCount() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.length;
  }
}
