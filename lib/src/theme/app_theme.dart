import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {

  static Color _getRequiredColor(Map<String, dynamic> colors, String key) {
    final value = colors[key];
    if (value == null) {
      // Default to a safe color if missing
      switch (key) {
        case 'scrim':
          return const Color(0xFF000000);
        case 'surfaceTint':
          return Color(int.parse(colors['primary'].toString()));
        case 'onSurfaceVariant':
          return Color(int.parse(colors['onSurface'].toString())).withOpacity(0.7);
        case 'outlineVariant':
          return Color(int.parse(colors['outline'].toString())).withOpacity(0.5);
        case 'tertiary':
          return Color(int.parse(colors['secondary'].toString()));
        case 'tertiaryContainer':
          return Color(int.parse(colors['secondaryContainer'].toString()));
        case 'onTertiaryContainer':
          return Color(int.parse(colors['onSecondaryContainer'].toString()));
        case 'onSecondaryContainer':
          return Color(int.parse(colors['onSecondary'].toString()));
        case 'onPrimaryContainer':
          return Color(int.parse(colors['onPrimary'].toString()));
        case 'onErrorContainer':
          return Color(int.parse(colors['onError'].toString()));
        default:
          throw Exception('Required color $key not found in theme');
      }
    }
    try {
      return Color(int.parse(value.toString()));
    } catch (e) {
      print('Error parsing color value for $key: $value');
      print('Error details: $e');
      rethrow;
    }
  }

  static ThemeData get lightTheme {
    if (AppColors.currentScheme == null) throw Exception('Theme colors not loaded');
    final themeMap = AppColors.currentScheme!.theme['light'];
    if (themeMap == null) throw Exception('Light theme colors not loaded');

    return ThemeData(
      useMaterial3: true,
      // Primary colors
      primaryColor: _getRequiredColor(themeMap, 'primary'),
      primaryColorLight: _getRequiredColor(themeMap, 'primaryContainer'),
      primaryColorDark: _getRequiredColor(themeMap, 'onPrimary'),
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: _getRequiredColor(themeMap, 'primary'),
        onPrimary: _getRequiredColor(themeMap, 'onPrimary'),
        primaryContainer: _getRequiredColor(themeMap, 'primaryContainer'),
        onPrimaryContainer: _getRequiredColor(themeMap, 'onPrimaryContainer'),
        secondary: _getRequiredColor(themeMap, 'secondary'),
        onSecondary: _getRequiredColor(themeMap, 'onSecondary'),
        secondaryContainer: _getRequiredColor(themeMap, 'secondaryContainer'),
        onSecondaryContainer: _getRequiredColor(themeMap, 'onSecondaryContainer'),
        tertiary: _getRequiredColor(themeMap, 'secondary'),
        onTertiary: _getRequiredColor(themeMap, 'onSecondary'),
        tertiaryContainer: _getRequiredColor(themeMap, 'secondaryContainer'),
        onTertiaryContainer: _getRequiredColor(themeMap, 'onSecondaryContainer'),
        error: _getRequiredColor(themeMap, 'error'),
        onError: _getRequiredColor(themeMap, 'onError'),
        errorContainer: _getRequiredColor(themeMap, 'errorContainer'),
        onErrorContainer: _getRequiredColor(themeMap, 'onErrorContainer'),
        surface: _getRequiredColor(themeMap, 'surface'),
        onSurface: _getRequiredColor(themeMap, 'onSurface'),
        surfaceContainerHighest: _getRequiredColor(themeMap, 'surfaceVariant'),
        onSurfaceVariant: _getRequiredColor(themeMap, 'onSurfaceVariant'),
        outline: _getRequiredColor(themeMap, 'outline'),
        outlineVariant: _getRequiredColor(themeMap, 'outlineVariant'),
        shadow: _getRequiredColor(themeMap, 'shadow'),
        scrim: _getRequiredColor(themeMap, 'scrim'),
        inverseSurface: _getRequiredColor(themeMap, 'inverseSurface'),
        onInverseSurface: _getRequiredColor(themeMap, 'onInverseSurface'),
        inversePrimary: _getRequiredColor(themeMap, 'inversePrimary'),
        surfaceTint: _getRequiredColor(themeMap, 'surfaceTint'),
      ),

      // Scaffold background color
      scaffoldBackgroundColor: _getRequiredColor(themeMap, 'background'),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: _getRequiredColor(themeMap, 'surface'),
        foregroundColor: _getRequiredColor(themeMap, 'onSurface'),
        elevation: 0,
      ),

      // Bottom Navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _getRequiredColor(themeMap, 'surface'),
        selectedItemColor: _getRequiredColor(themeMap, 'primary'),
        unselectedItemColor: _getRequiredColor(themeMap, 'onSurface').withOpacity(0.6),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: _getRequiredColor(themeMap, 'surfaceVariant'),
        elevation: 0,
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getRequiredColor(themeMap, 'primary'),
          foregroundColor: _getRequiredColor(themeMap, 'onPrimary'),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _getRequiredColor(themeMap, 'primary'),
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        displayMedium: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        displaySmall: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        headlineLarge: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        headlineMedium: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        headlineSmall: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        // titleLarge: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        titleLarge: TextStyle(color: _getRequiredColor(themeMap, 'onSurface'), fontFamily: 'TitilliumWebLight', fontWeight: FontWeight.w900, fontSize: 32, letterSpacing: 0.2, height: 1.2,),
        titleMedium: TextStyle(color: _getRequiredColor(themeMap, 'onSurface'), fontFamily: 'TitilliumWebLight', fontWeight: FontWeight.w700, fontSize: 24, letterSpacing: 0.2, height: 1.2,),
        titleSmall: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        bodyLarge: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        bodyMedium: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        bodySmall: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: _getRequiredColor(themeMap, 'onSurface'),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: _getRequiredColor(themeMap, 'onSurface').withOpacity(0.2),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: _getRequiredColor(themeMap, 'surface'),
        surfaceTintColor: _getRequiredColor(themeMap, 'surfaceTint'),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _getRequiredColor(themeMap, 'inverseSurface'),
        contentTextStyle: TextStyle(color: _getRequiredColor(themeMap, 'onInverseSurface')),
      ),
    );
  }

  static ThemeData get darkTheme {
    if (AppColors.currentScheme == null) throw Exception('Theme colors not loaded');
    final colors = AppColors.currentScheme!.theme['dark'];
    if (colors == null) throw Exception('Dark theme colors not loaded');

    return ThemeData(
      useMaterial3: true,
      // Primary colors
      primaryColor: _getRequiredColor(colors, 'primary'),
      primaryColorLight: _getRequiredColor(colors, 'primaryContainer'),
      primaryColorDark: _getRequiredColor(colors, 'onPrimary'),
      fontFamily: 'TitilliumWeb',

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: _getRequiredColor(colors, 'primary'),
        onPrimary: _getRequiredColor(colors, 'onPrimary'),
        primaryContainer: _getRequiredColor(colors, 'primaryContainer'),
        onPrimaryContainer: _getRequiredColor(colors, 'onPrimaryContainer'),
        secondary: _getRequiredColor(colors, 'secondary'),
        onSecondary: _getRequiredColor(colors, 'onSecondary'),
        secondaryContainer: _getRequiredColor(colors, 'secondaryContainer'),
        onSecondaryContainer: _getRequiredColor(colors, 'onSecondaryContainer'),
        tertiary: _getRequiredColor(colors, 'secondary'),
        onTertiary: _getRequiredColor(colors, 'onSecondary'),
        tertiaryContainer: _getRequiredColor(colors, 'secondaryContainer'),
        onTertiaryContainer: _getRequiredColor(colors, 'onSecondaryContainer'),
        error: _getRequiredColor(colors, 'error'),
        onError: _getRequiredColor(colors, 'onError'),
        errorContainer: _getRequiredColor(colors, 'errorContainer'),
        onErrorContainer: _getRequiredColor(colors, 'onErrorContainer'),
        surface: _getRequiredColor(colors, 'surface'),
        onSurface: _getRequiredColor(colors, 'onSurface'),
        surfaceContainerHighest: _getRequiredColor(colors, 'surfaceVariant'),
        onSurfaceVariant: _getRequiredColor(colors, 'onSurfaceVariant'),
        outline: _getRequiredColor(colors, 'outline'),
        outlineVariant: _getRequiredColor(colors, 'outlineVariant'),
        shadow: _getRequiredColor(colors, 'shadow'),
        scrim: _getRequiredColor(colors, 'scrim'),
        inverseSurface: _getRequiredColor(colors, 'inverseSurface'),
        onInverseSurface: _getRequiredColor(colors, 'onInverseSurface'),
        inversePrimary: _getRequiredColor(colors, 'inversePrimary'),
        surfaceTint: _getRequiredColor(colors, 'surfaceTint'),
      ),

      // Scaffold background color
      scaffoldBackgroundColor: _getRequiredColor(colors, 'background'),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: _getRequiredColor(colors, 'surface'),
        foregroundColor: _getRequiredColor(colors, 'onSurface'),
        elevation: 0,
      ),

      // Bottom Navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _getRequiredColor(colors, 'surface'),
        selectedItemColor: _getRequiredColor(colors, 'primary'),
        unselectedItemColor: _getRequiredColor(colors, 'onSurface').withOpacity(0.6),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: _getRequiredColor(colors, 'surfaceVariant'),
        elevation: 0,
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getRequiredColor(colors, 'primary'),
          foregroundColor: _getRequiredColor(colors, 'onPrimary'),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _getRequiredColor(colors, 'primary'),
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        displayMedium: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        displaySmall: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        headlineLarge: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        headlineMedium: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        headlineSmall: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        titleLarge: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        titleMedium: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        titleSmall: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        bodyLarge: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        bodyMedium: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
        bodySmall: TextStyle(color: _getRequiredColor(colors, 'onSurface')),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: _getRequiredColor(colors, 'onSurface'),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: _getRequiredColor(colors, 'onSurface').withOpacity(0.2),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: _getRequiredColor(colors, 'surface'),
        surfaceTintColor: _getRequiredColor(colors, 'surfaceTint'),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _getRequiredColor(colors, 'inverseSurface'),
        contentTextStyle: TextStyle(color: _getRequiredColor(colors, 'onInverseSurface')),
      ),
    );
  }
} 