import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() => _instance;

  NotificationController._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      final String deviceTimezone = timezone.toString();
      tz.setLocalLocation(tz.getLocation(deviceTimezone));
      debugPrint('Timezone set: $deviceTimezone');
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));
      debugPrint('Timezone fallback to Asia/Kathmandu: $e');
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();

      // Check exact notification permissions on Android
      final bool? canScheduleExact = await androidImplementation
          .canScheduleExactNotifications();
      if (canScheduleExact == false) {
        await androidImplementation.requestExactAlarmsPermission();
      }
    }

    await _createChannels();
  }

  Future<void> _createChannels() async {
    const AndroidNotificationChannel dailyChannel = AndroidNotificationChannel(
      'football_quiz_daily_v2',
      'Football Quiz Daily Notifications',
      description: 'Daily football quiz reminders',
      importance: Importance.max,
    );

    const AndroidNotificationChannel instantChannel =
        AndroidNotificationChannel(
          'football_quiz_instant_v1',
          'Football Quiz Instant Notifications',
          description: 'Instant football quiz alerts',
          importance: Importance.max,
        );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.createNotificationChannel(dailyChannel);
    await androidImplementation?.createNotificationChannel(instantChannel);
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
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'football_quiz_daily_v2',
            'Football Quiz Daily Notifications',
            channelDescription: 'Daily football quiz reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      final localDisplay = scheduledDate.toLocal();
      debugPrint(
        'Scheduled Daily Notification -> ID: $id at local time: ${localDisplay.hour}:${localDisplay.minute}',
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'football_quiz_instant_v1',
            'Football Quiz Instant Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );

      debugPrint('⚡ Instant Notification Sent -> ID: $id');
    } catch (e) {
      debugPrint('Instant notification error: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
    debugPrint('Notification Cancelled -> ID: $id');
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    debugPrint('All Notifications Cancelled');
  }

  Future<void> printPendingNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();

    debugPrint('Pending Notifications: ${pending.length}');
    for (final item in pending) {
      debugPrint('ID: ${item.id}, TITLE: ${item.title}');
    }
    debugPrint('');
  }

  Future<int> getPendingCount() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    return pending.length;
  }
}
