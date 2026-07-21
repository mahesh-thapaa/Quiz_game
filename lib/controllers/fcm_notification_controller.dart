import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(settings.authorizationStatus.toString());
  }

  Future<String?> getFcmToken() async {
    String? token = await messaging.getToken();
    debugPrint("FCM Token: $token");
    return token;
  }

  Future<void> subscribeTopic() async {
    await messaging.subscribeToTopic("all_users");
  }
}
