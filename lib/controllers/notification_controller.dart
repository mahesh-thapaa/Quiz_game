import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() => _instance;

  NotificationController._internal();

  static const MethodChannel _timezoneChannel =
      MethodChannel('com.luminotechnology.goaliq/timezone');

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

  Future<bool> init({
    void Function(NotificationResponse)? onNotificationTap,
  }) async {
    if (_initialized) return _permissionGranted;

    // 1. Timezone Setup & Alias Normalization
    try {
      tz.initializeTimeZones();
      String deviceTimezone = 'UTC';
      try {
        final String? zone =
            await _timezoneChannel.invokeMethod<String>('getLocalTimezone');
        if (zone != null && zone.isNotEmpty) {
          deviceTimezone = zone;
        }
      } catch (e) {
        debugPrint('Native timezone MethodChannel failed: $e');
        deviceTimezone = DateTime.now().timeZoneName;
      }

      // Guard against old deprecated alias still present on some devices
      if (deviceTimezone == 'Asia/Katmandu') {
        deviceTimezone = 'Asia/Kathmandu';
      }

      try {
        tz.setLocalLocation(tz.getLocation(deviceTimezone));
      } catch (e) {
        debugPrint('Location lookup failed for $deviceTimezone: $e');
        tz.setLocalLocation(tz.local);
      }
    } catch (e) {
      debugPrint('Timezone initialization warning: $e');
    }

    // 2. Settings Initialization
    const androidSettings = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    // 3. Platform Permissions & Channels
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      _permissionGranted =
          await androidImpl.requestNotificationsPermission() ?? false;

      final canScheduleExact = await androidImpl
          .canScheduleExactNotifications();
      if (canScheduleExact == false) {
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
      final iosImpl = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (iosImpl != null) {
        _permissionGranted =
            await iosImpl.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      } else {
        _permissionGranted = true;
      }
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
    } catch (e) {
      debugPrint('Exact scheduling failed ($e). Retrying inexact mode...');
      try {
        await _plugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: _dailyDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (err) {
        debugPrint('Error scheduling daily notification: $err');
      }
    }
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
    } catch (e) {
      debugPrint('Error showing instant notification: $e');
    }
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
