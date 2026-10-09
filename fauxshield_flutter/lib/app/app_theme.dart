import 'package:flutter/material.dart';

/// Builds the FauxShield theme for the given [brightness].
ThemeData buildFauxShieldTheme(Brightness brightness) {
  const brandPrimary = Color(0xFF24A374); // HSL(158, 64%, 39%).
  final isDark = brightness == Brightness.dark;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: brandPrimary,
        brightness: brightness,
      ).copyWith(
        // Keep prominent auth controls on-brand in light mode and brighter in dark.
        primary: isDark ? const Color(0xFF57C895) : brandPrimary,
        onPrimary: isDark ? const Color(0xFF10231A) : Colors.white,
        surface: isDark ? const Color(0xFF17211B) : const Color(0xFFEAF1EB),
        surfaceContainerLowest: isDark
            ? const Color(0xFF1B2720)
            : const Color(0xFFF9FBF9),
        surfaceContainerLow: isDark
            ? const Color(0xFF202E26)
            : const Color(0xFFDFE9E1),
        surfaceContainer: isDark
            ? const Color(0xFF26372D)
            : const Color(0xFFD5E2D8),
        surfaceContainerHigh: isDark
            ? const Color(0xFF2D4034)
            : const Color(0xFFDDE9E0),
        onSurface: isDark ? const Color(0xFFE4EEE7) : const Color(0xFF19251E),
        onSurfaceVariant: isDark
            ? const Color(0xFFB8C8BD)
            : const Color(0xFF526258),
        outline: isDark ? const Color(0xFF718579) : const Color(0xFF829487),
        outlineVariant: isDark
            ? const Color(0xFF3C5144)
            : const Color(0xFFC9D7CC),
      );
  final baseTextTheme = ThemeData(brightness: brightness).textTheme;
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    canvasColor: scheme.surface,
    textTheme: baseTextTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),
    useMaterial3: true,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: scheme.outlineVariant),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      floatingLabelStyle: TextStyle(color: scheme.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      errorStyle: TextStyle(color: scheme.error),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      height: 68,
    ),
  );
}
