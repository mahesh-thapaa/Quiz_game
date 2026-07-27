import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quiz_game/firebase_options.dart';

import 'package:quiz_game/provider/theme_provider.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/provider/profile_image_provider.dart';
import 'package:quiz_game/provider/password_provider.dart';
import 'package:quiz_game/provider/daily_challenger_provider.dart';
import 'package:quiz_game/provider/leaderboard_provider.dart';
import 'package:quiz_game/provider/notification_provider.dart';
import 'package:quiz_game/services/internet/internet_service.dart';

import 'package:quiz_game/controllers/auth_controller.dart';
import 'package:quiz_game/controllers/notification_controller.dart';
import 'package:quiz_game/services/ads/ad_service.dart';
import 'package:quiz_game/screens/splash_screen/splash_screen.dart';

/// Background notification handler
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("📩 Background Message Received: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    /// Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Initialize Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    Isolate.current.addErrorListener(
      RawReceivePort((pair) {
        final error = pair[0];
        final stack = pair[1] is StackTrace
            ? pair[1] as StackTrace
            : StackTrace.empty;
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }).sendPort,
    );

    /// Initialize Ads
    await AdService().init();

    /// Initialize local notifications
    await NotificationController().init();

    /// Register FCM background handler
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    /// 💡 1. Request FCM Push Notification Permission (Mandatory for Android 13+ and iOS)
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);
    debugPrint('🔔 FCM Permission Status: ${settings.authorizationStatus}');

    /// 💡 2. Enable Foreground Heads-Up Banners (iOS)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    /// 💡 3. Handle FCM Messages When App is Open (Foreground Listener)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Foreground FCM Message: ${message.notification?.title}');

      // Display foreground message as a heads-up local banner
      if (message.notification != null) {
        NotificationController().showInstantNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: message.notification!.title ?? 'GoalIQ Alert',
          body: message.notification!.body ?? '',
        );
      }
    });

    /// 💡 4. Fetch & Print Fresh FCM Device Token (For Testing in Firebase Console)
    final String? fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('🔑 CURRENT FCM DEVICE TOKEN: $fcmToken');
  } catch (e, st) {
    debugPrint("⚠️ Firebase init error: $e");
    try {
      await FirebaseCrashlytics.instance.recordError(e, st, fatal: true);
    } catch (_) {
      // Crashlytics unavailable — Firebase init failed
    }
  }

  /// Global error widget — shows a friendly error screen instead of white screen
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: const Color(0xFF0B141E),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'An unexpected issue occurred. Please restart the app or try again in a moment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProgressProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => DailyChallengerProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider.value(
          value: InternetService()..startMonitoring(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<ThemeProvider>().themeMode,
      theme: ThemeData(brightness: Brightness.light, fontFamily: 'Inter'),
      darkTheme: ThemeData(brightness: Brightness.dark, fontFamily: 'Inter'),
      home: const InternetConnectionWrapper(child: SplashScreen()),
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        );
      },
    );
  }
}
