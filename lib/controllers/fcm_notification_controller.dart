import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print(settings.authorizationStatus);
  }

  Future<String?> getFcmToken() async {
    String? token = await messaging.getToken();
    print("FCM Token: $token");
    return token;
  }

  Future<void> subscribeTopic() async {
    await messaging.subscribeToTopic("all_users");
  }
}
