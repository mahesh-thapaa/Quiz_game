import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/provider/theme_provider.dart';
import 'package:quiz_game/screens/splash_screen/splash_screesn.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()),
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

      home: SplashScreen(),
    );
  }
}
