// // lib/main.dart

// import 'package:flutter/material.dart';
// import 'package:quiz_game/provider/theme_provider.dart';
// import 'package:quiz_game/screens/login.dart';
// // import 'package:quiz_game/screens/profile/seetings/settings_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeProvider,
//       builder: (context, mode, _) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           themeMode: mode,
//           darkTheme: ThemeData(
//             brightness: Brightness.dark,
//             scaffoldBackgroundColor: const Color(0xFF0B141E),
//             colorScheme: const ColorScheme.dark(
//               primary: Color(0xFF19B357),
//               surface: Color(0xFF112233),
//             ),
//             appBarTheme: const AppBarTheme(
//               backgroundColor: Color(0xFF0B141E),
//               foregroundColor: Colors.white,
//               elevation: 0,
//             ),
//           ),
//           theme: ThemeData(
//             brightness: Brightness.light,
//             scaffoldBackgroundColor: const Color(0xFFF1F5F9),
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF19B357),
//               surface: Colors.white,
//             ),
//             appBarTheme: const AppBarTheme(
//               backgroundColor: Color(0xFFF1F5F9),
//               foregroundColor: Color(0xFF0F172A),
//               elevation: 0,
//             ),
//           ),
//           home: Login(),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/provider/theme_provider.dart';
import 'package:quiz_game/screens/login.dart';

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

      home: Login(),
    );
  }
}
