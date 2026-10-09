import 'package:flutter/material.dart';

/// Builds the FauxShield theme for the given [brightness].
///
/// The color tokens are ported 1:1 from the design system used by the
/// reference implementation (`globals.css` in the inspiration repo), so the
/// Flutter app matches its light and dark palettes exactly:
///
/// * `--primary` hsl(158 64% 39%) / dark hsl(152 62% 46%)
/// * `--background` hsl(150 8% 99%) / dark hsl(160 14% 5%)
/// * `--card` white / dark hsl(160 12% 7%)
/// * `--muted-foreground` hsl(155 6% 44%) / dark hsl(150 6% 58%)
/// * `--border` hsl(150 8% 90%) / dark hsl(160 8% 15%)
/// * `--radius` 0.625rem (10px), buttons at 8px
ThemeData buildFauxShieldTheme(Brightness brightness) {
  const brandPrimary = Color(0xFF24A374); // hsl(158 64% 39%)
  final isDark = brightness == Brightness.dark;

  // --- Token values (see table above) -------------------------------------
  final background = isDark ? const Color(0xFF0B0E0D) : const Color(0xFFFCFCFC);
  final foreground = isDark ? const Color(0xFFF4F6F5) : const Color(0xFF121715);
  final card = isDark ? const Color(0xFF101413) : Colors.white;
  final secondary = isDark ? const Color(0xFF1C211F) : const Color(0xFFF4F6F5);
  final muted = isDark ? const Color(0xFF1C211F) : const Color(0xFFF1F3F2);
  final accent = isDark ? const Color(0xFF212725) : const Color(0xFFEEF1F0);
  final accentHighest = isDark
      ? const Color(0xFF2A322F)
      : const Color(0xFFE9ECEA);
  final mutedForeground = isDark
      ? const Color(0xFF8D9A94)
      : const Color(0xFF6A7771);
  final border = isDark ? const Color(0xFF232927) : const Color(0xFFE4E8E5);
  final destructive = isDark
      ? const Color(0xFFE03E3E)
      : const Color(0xFFDC2828);
  final warning = isDark ? const Color(0xFFFFAC17) : const Color(0xFFF59F0A);
  final primary = isDark ? const Color(0xFF2CBE7A) : brandPrimary;
  final primaryForeground = isDark ? const Color(0xFF0B1311) : Colors.white;
  final outline = isDark ? const Color(0xFF55605B) : const Color(0xFF98A39D);

  final scheme =
      ColorScheme.fromSeed(
        seedColor: brandPrimary,
        brightness: brightness,
      ).copyWith(
        primary: primary,
        onPrimary: primaryForeground,
        primaryContainer: primary.withValues(alpha: isDark ? 0.22 : 0.14),
        onPrimaryContainer: isDark
            ? const Color(0xFF9EE6C7)
            : const Color(0xFF0A3B29),
        secondary: secondary,
        onSecondary: foreground,
        secondaryContainer: primary.withValues(alpha: isDark ? 0.22 : 0.14),
        onSecondaryContainer: isDark
            ? const Color(0xFF9EE6C7)
            : const Color(0xFF0A3B29),
        tertiary: warning,
        onTertiary: isDark ? const Color(0xFF3A2602) : Colors.white,
        error: destructive,
        onError: Colors.white,
        errorContainer: isDark
            ? const Color(0xFF3A1616)
            : const Color(0xFFF9E4E4),
        onErrorContainer: isDark
            ? const Color(0xFFF5C6C6)
            : const Color(0xFF7A1D1D),
        surface: background,
        onSurface: foreground,
        surfaceContainerLowest: card,
        surfaceContainerLow: secondary,
        surfaceContainer: muted,
        surfaceContainerHigh: accent,
        surfaceContainerHighest: accentHighest,
        onSurfaceVariant: mutedForeground,
        outline: outline,
        outlineVariant: border,
        shadow: Colors.black,
        scrim: Colors.black.withValues(alpha: 0.4),
        inverseSurface: isDark
            ? const Color(0xFFF4F6F5)
            : const Color(0xFF121715),
        onInverseSurface: isDark ? const Color(0xFF121715) : Colors.white,
        inversePrimary: isDark ? brandPrimary : const Color(0xFF2CBE7A),
      );

  const cardRadius = BorderRadius.all(Radius.circular(10));
  const controlRadius = BorderRadius.all(Radius.circular(8));

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
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLowest,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: cardRadius,
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: scheme.outlineVariant),
      backgroundColor: scheme.surfaceContainer,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      isDense: true,
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      floatingLabelStyle: TextStyle(color: scheme.primary),
      border: OutlineInputBorder(
        borderRadius: controlRadius,
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: controlRadius,
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: controlRadius,
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: controlRadius),
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: controlRadius),
        side: BorderSide(color: scheme.outlineVariant),
        foregroundColor: scheme.onSurface,
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: controlRadius),
        foregroundColor: scheme.primary,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      indicatorColor: scheme.primary.withValues(alpha: 0.14),
      height: 68,
      elevation: 0,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurfaceVariant,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurfaceVariant,
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: cardRadius,
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 2,
    ),
  );
}
