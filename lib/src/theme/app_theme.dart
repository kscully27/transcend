import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/color_scheme.dart';

class AppTheme {
  static const _isEarthTone = false; // Toggle between themes

  static Color _getRequiredColor(Map<String, dynamic> colors, String key) {
    final value = colors[key];
    if (value == null) throw Exception('Required color $key not found in theme');
    return Color(int.parse(value.toString()));
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
        secondary: _getRequiredColor(themeMap, 'secondary'),
        onSecondary: _getRequiredColor(themeMap, 'onSecondary'),
        error: _getRequiredColor(themeMap, 'error'),
        onError: _getRequiredColor(themeMap, 'onError'),
        background: _getRequiredColor(themeMap, 'background'),
        onBackground: _getRequiredColor(themeMap, 'onBackground'),
        surface: _getRequiredColor(themeMap, 'surface'),
        onSurface: _getRequiredColor(themeMap, 'onSurface'),
        surfaceTint: _getRequiredColor(themeMap, 'surfaceTint'),
        inversePrimary: _getRequiredColor(themeMap, 'inversePrimary'),
        inverseSurface: _getRequiredColor(themeMap, 'inverseSurface'),
        onInverseSurface: _getRequiredColor(themeMap, 'onInverseSurface'),
        outline: _getRequiredColor(themeMap, 'outline'),
        shadow: _getRequiredColor(themeMap, 'shadow'),
        scrim: _getRequiredColor(themeMap, 'scrim'),
        surfaceVariant: _getRequiredColor(themeMap, 'surfaceVariant'),
        onSurfaceVariant: _getRequiredColor(themeMap, 'onSurfaceVariant'),
        primaryContainer: _getRequiredColor(themeMap, 'primaryContainer'),
        onPrimaryContainer: _getRequiredColor(themeMap, 'onPrimaryContainer'),
        secondaryContainer: _getRequiredColor(themeMap, 'secondaryContainer'),
        onSecondaryContainer: _getRequiredColor(themeMap, 'onSecondaryContainer'),
        tertiaryContainer: _getRequiredColor(themeMap, 'tertiaryContainer'),
        onTertiaryContainer: _getRequiredColor(themeMap, 'onTertiaryContainer'),
        errorContainer: _getRequiredColor(themeMap, 'errorContainer'),
        onErrorContainer: _getRequiredColor(themeMap, 'onErrorContainer'),
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
        titleLarge: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
        titleMedium: TextStyle(color: _getRequiredColor(themeMap, 'onSurface')),
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
    final colors = AppColors.currentScheme?.theme?['dark'];
    if (colors == null) throw Exception('Theme colors not loaded');

    return ThemeData(
      useMaterial3: true,
      // Primary colors
      primaryColor: _getRequiredColor(colors, 'primary'),
      primaryColorLight: _getRequiredColor(colors, 'primaryContainer'),
      primaryColorDark: _getRequiredColor(colors, 'onPrimary'),
      
      // Color Scheme
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: _getRequiredColor(colors, 'primary'),
        onPrimary: _getRequiredColor(colors, 'onPrimary'),
        secondary: _getRequiredColor(colors, 'secondary'),
        onSecondary: _getRequiredColor(colors, 'onSecondary'),
        error: _getRequiredColor(colors, 'error'),
        onError: _getRequiredColor(colors, 'onError'),
        background: _getRequiredColor(colors, 'background'),
        onBackground: _getRequiredColor(colors, 'onBackground'),
        surface: _getRequiredColor(colors, 'surface'),
        onSurface: _getRequiredColor(colors, 'onSurface'),
        surfaceTint: _getRequiredColor(colors, 'surfaceTint'),
        inversePrimary: _getRequiredColor(colors, 'inversePrimary'),
        inverseSurface: _getRequiredColor(colors, 'inverseSurface'),
        onInverseSurface: _getRequiredColor(colors, 'onInverseSurface'),
        outline: _getRequiredColor(colors, 'outline'),
        shadow: _getRequiredColor(colors, 'shadow'),
        scrim: _getRequiredColor(colors, 'scrim'),
        surfaceVariant: _getRequiredColor(colors, 'surfaceVariant'),
        onSurfaceVariant: _getRequiredColor(colors, 'onSurfaceVariant'),
        primaryContainer: _getRequiredColor(colors, 'primaryContainer'),
        onPrimaryContainer: _getRequiredColor(colors, 'onPrimaryContainer'),
        secondaryContainer: _getRequiredColor(colors, 'secondaryContainer'),
        onSecondaryContainer: _getRequiredColor(colors, 'onSecondaryContainer'),
        tertiaryContainer: _getRequiredColor(colors, 'tertiaryContainer'),
        onTertiaryContainer: _getRequiredColor(colors, 'onTertiaryContainer'),
        errorContainer: _getRequiredColor(colors, 'errorContainer'),
        onErrorContainer: _getRequiredColor(colors, 'onErrorContainer'),
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