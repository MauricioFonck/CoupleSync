import 'package:flutter/material.dart';

/// Theme Material 3 de CoupleSync (light/dark) a partir de un color semilla.
abstract final class AppTheme {
  static const Color seed = Color(0xFFE91E63);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}

/// Breakpoints responsive.
abstract final class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;

  static bool isCompact(double width) => width < tablet;
  static bool isMedium(double width) => width >= tablet && width < desktop;
  static bool isExpanded(double width) => width >= desktop;
}
