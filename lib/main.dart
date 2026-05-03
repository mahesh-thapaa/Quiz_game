import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

import 'package:quiz_game/controllers/auth_controller.dart';
import 'package:quiz_game/controllers/notification_controller.dart';

import 'package:quiz_game/screens/splash_screen/splash_screen.dart';

/// Background notification handler
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint("Background Message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    /// Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Initialize local notifications
    await NotificationController().init();

    /// Register FCM background handler
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  } catch (e) {
    debugPrint("⚠️ Firebase init error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProgressProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => DailyChallengerProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: context.watch<ThemeProvider>().themeMode,

      theme: ThemeData(brightness: Brightness.light),

      darkTheme: ThemeData(brightness: Brightness.dark),

      home: const SplashScreen(),
    );
  }
}
