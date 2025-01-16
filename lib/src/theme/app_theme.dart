import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // Primary colors
      primaryColor: AppColors.flat('khaki'),
      primaryColorLight: AppColors.light('khaki'),
      primaryColorDark: AppColors.dark('khaki'),
      
      // Color Scheme
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.flat('khaki'),
        onPrimary: AppColors.dark('khaki'),
        secondary: AppColors.flat('orange'),
        onSecondary: AppColors.dark('orange'),
        error: AppColors.flat('red'),
        onError: AppColors.dark('red'),
        background: AppColors.flat('khaki'),
        onBackground: AppColors.dark('light'),
        surface: AppColors.flat('khaki'),
        onSurface: AppColors.highlight('khaki'),
        surfaceTint: AppColors.light('khaki'),
      ),

      // Scaffold background color
      scaffoldBackgroundColor: AppColors.flat('light'),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.flat('light'),
        foregroundColor: AppColors.dark('light'),
        elevation: 0,
      ),

      // Bottom Navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.flat('light'),
        selectedItemColor: AppColors.flat('khaki'),
        unselectedItemColor: AppColors.dark('light').withOpacity(0.6),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: AppColors.light('light'),
        elevation: 0,
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.flat('khaki'),
          foregroundColor: AppColors.dark('khaki'),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.flat('khaki'),
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(color: AppColors.dark('light')),
        displayMedium: TextStyle(color: AppColors.dark('light')),
        displaySmall: TextStyle(color: AppColors.dark('light')),
        headlineLarge: TextStyle(color: AppColors.dark('light')),
        headlineMedium: TextStyle(color: AppColors.dark('light')),
        headlineSmall: TextStyle(color: AppColors.dark('light')),
        titleLarge: TextStyle(color: AppColors.dark('light')),
        titleMedium: TextStyle(color: AppColors.dark('light')),
        titleSmall: TextStyle(color: AppColors.dark('light')),
        bodyLarge: TextStyle(color: AppColors.dark('light')),
        bodyMedium: TextStyle(color: AppColors.dark('light')),
        bodySmall: TextStyle(color: AppColors.dark('light')),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      // Primary colors
      primaryColor: AppColors.flat('dark'),
      primaryColorLight: AppColors.light('dark'),
      primaryColorDark: AppColors.dark('dark'),
      
      // Color Scheme
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.flat('khaki'),
        onPrimary: AppColors.dark('khaki'),
        secondary: AppColors.flat('orange'),
        onSecondary: AppColors.dark('orange'),
        error: AppColors.flat('red'),
        onError: AppColors.dark('red'),
        background: AppColors.flat('dark'),
        onBackground: AppColors.light('dark'),
        surface: AppColors.dark('dark'),
        onSurface: AppColors.light('dark'),
        surfaceTint: AppColors.dark('khaki'),
      ),

      // Scaffold background color
      scaffoldBackgroundColor: AppColors.flat('dark'),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.flat('dark'),
        foregroundColor: AppColors.light('dark'),
        elevation: 0,
      ),

      // Bottom Navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.flat('dark'),
        selectedItemColor: AppColors.flat('khaki'),
        unselectedItemColor: AppColors.light('dark').withOpacity(0.6),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: AppColors.dark('dark'),
        elevation: 0,
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.flat('khaki'),
          foregroundColor: AppColors.dark('khaki'),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.flat('khaki'),
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(color: AppColors.light('dark')),
        displayMedium: TextStyle(color: AppColors.light('dark')),
        displaySmall: TextStyle(color: AppColors.light('dark')),
        headlineLarge: TextStyle(color: AppColors.light('dark')),
        headlineMedium: TextStyle(color: AppColors.light('dark')),
        headlineSmall: TextStyle(color: AppColors.light('dark')),
        titleLarge: TextStyle(color: AppColors.light('dark')),
        titleMedium: TextStyle(color: AppColors.light('dark')),
        titleSmall: TextStyle(color: AppColors.light('dark')),
        bodyLarge: TextStyle(color: AppColors.light('dark')),
        bodyMedium: TextStyle(color: AppColors.light('dark')),
        bodySmall: TextStyle(color: AppColors.light('dark')),
      ),
    );
  }
} 