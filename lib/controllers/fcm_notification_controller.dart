import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

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

  /// Gets the FCM token and saves it to Firestore for the current user.
  Future<String?> getFcmToken() async {
    try {
      String? token = await messaging.getToken();
      if (kDebugMode) debugPrint("FCM Token: $token");

      if (token != null) {
        await _saveFcmToken(token);
      }

      // Refresh token when it rotates
      messaging.onTokenRefresh.listen((newToken) {
        _saveFcmToken(newToken);
      });

      return token;
    } catch (e) {
      debugPrint('❌ getFcmToken error: $e');
      return null;
    }
  }

  Future<void> _saveFcmToken(String token) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ FCM token saved to Firestore');
    } catch (e) {
      debugPrint('❌ Failed to save FCM token: $e');
    }
  }

  Future<void> subscribeTopic() async {
    await messaging.subscribeToTopic("all_users");
    debugPrint('✅ Subscribed to topic: all_users');
  }
}
