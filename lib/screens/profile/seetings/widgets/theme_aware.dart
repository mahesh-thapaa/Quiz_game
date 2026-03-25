// // lib/widgets/theme_aware.dart

// import 'package:flutter/material.dart';
// import 'package:quiz_game/provider/theme_provider.dart';

// /// Wrap your Scaffold (or any widget) with this so it
// /// rebuilds automatically when dark/light mode is toggled.
// ///
// /// Usage:
// ///   return ThemeAware(
// ///     builder: (context) => Scaffold(...),
// ///   );
// class ThemeAware extends StatelessWidget {
//   final WidgetBuilder builder;
//   const ThemeAware({super.key, required this.builder});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeProvider,
//       builder: (context, _, __) => builder(context),
//     );
//   }
// }
