import 'package:flutter/material.dart';

// Brand palette. Keep the historical deepTeal name to avoid changing every
// existing feature at once; the value is now the app's electric-blue accent.
const Color ink = Color(0xFF0B1830);
const Color deepTeal = Color(0xFF4C8DFF);
const Color mint = Color(0xFFEAF2FF);
const Color canvas = Color(0xFFF4F7FC);
const Color warm = Color(0xFFC8DCFF);
const Color brandNavy = Color(0xFF081326);
const Color brandBlue = Color(0xFF2868E8);
const Color brandCyan = Color(0xFF64D6F4);

const Color _darkCanvas = Color(0xFF07101F);
const Color _darkSurface = Color(0xFF0E1A2E);
const Color _darkSurfaceRaised = Color(0xFF142541);
const Color _darkMint = Color(0xFF172D4C);
const Color _lightMuted = Color(0xFF5B6B84);
const Color _darkMuted = Color(0xFFA8B9D4);

Color surfaceFor(BuildContext context) => Theme.of(context).colorScheme.surface;
Color surfaceRaisedFor(BuildContext context) =>
    Theme.of(context).colorScheme.surfaceContainerHigh;
Color inkFor(BuildContext context) => Theme.of(context).colorScheme.onSurface;
Color mutedFor(BuildContext context) =>
    Theme.of(context).colorScheme.onSurfaceVariant;
Color mintFor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? _darkMint : mint;

ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final foreground = isDark ? const Color(0xFFEAF1FF) : ink;
  final muted = isDark ? _darkMuted : _lightMuted;
  final surface = isDark ? _darkSurface : Colors.white;
  final outline = isDark ? const Color(0xFF263B5A) : const Color(0xFFDCE5F2);
  final accent = isDark ? const Color(0xFF80ADFF) : brandBlue;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: brandBlue,
        brightness: brightness,
        surface: surface,
      ).copyWith(
        primary: accent,
        onPrimary: Colors.white,
        secondary: isDark ? brandCyan : const Color(0xFF167EAA),
        onSecondary: isDark ? brandNavy : Colors.white,
        tertiary: isDark ? const Color(0xFFB6A4FF) : const Color(0xFF6551C8),
        onSurface: foreground,
        onSurfaceVariant: muted,
        surfaceContainerLowest: isDark ? _darkCanvas : Colors.white,
        surfaceContainerLow: isDark ? _darkSurface : const Color(0xFFF9FBFF),
        surfaceContainer: isDark ? _darkSurfaceRaised : const Color(0xFFF0F5FC),
        surfaceContainerHigh: isDark
            ? _darkSurfaceRaised
            : const Color(0xFFEAF0F8),
        surfaceContainerHighest: isDark
            ? const Color(0xFF1B3151)
            : const Color(0xFFE2EAF5),
        secondaryContainer: isDark ? _darkMint : mint,
        onSecondaryContainer: isDark ? const Color(0xFFD8E8FF) : ink,
        outline: outline,
        outlineVariant: outline.withValues(alpha: .65),
      );

  final roundedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(22),
    side: BorderSide(color: outline.withValues(alpha: isDark ? .68 : .8)),
  );

  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: isDark ? _darkCanvas : canvas,
    dividerColor: outline,
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? _darkCanvas : canvas,
      foregroundColor: foreground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: foreground,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -.35,
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: isDark ? 0 : 1,
      shadowColor: isDark
          ? Colors.black.withValues(alpha: .18)
          : brandNavy.withValues(alpha: .06),
      margin: EdgeInsets.zero,
      shape: roundedShape,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? _darkSurfaceRaised : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: accent, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: isDark ? brandNavy : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: .1,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: isDark ? brandNavy : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foreground,
        side: BorderSide(color: outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      indicatorColor: accent.withValues(alpha: isDark ? .24 : .12),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          color: selected ? accent : muted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(color: selected ? accent : muted, size: 22);
      }),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: isDark ? _darkSurfaceRaised : const Color(0xFFEAF0F8),
      selectedColor: accent.withValues(alpha: isDark ? .24 : .14),
      side: BorderSide(color: outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      labelStyle: TextStyle(color: foreground, fontWeight: FontWeight.w600),
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        color: foreground,
        fontWeight: FontWeight.w900,
        letterSpacing: -.8,
      ),
      headlineSmall: TextStyle(
        color: foreground,
        fontWeight: FontWeight.w800,
        letterSpacing: -.45,
      ),
      titleLarge: TextStyle(color: foreground, fontWeight: FontWeight.w800),
      titleMedium: TextStyle(color: foreground, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(color: foreground, height: 1.52),
      bodyMedium: TextStyle(color: muted, height: 1.5),
      bodySmall: TextStyle(color: muted, height: 1.42),
      labelLarge: TextStyle(color: foreground, fontWeight: FontWeight.w700),
    ),
  );
}
