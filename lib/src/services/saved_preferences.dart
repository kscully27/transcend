import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPreferences {
  static const _themeColorsKey = 'theme_colors_';

  static Future<Map<String, dynamic>?> getThemeColors(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_themeColorsKey$themeName');
    if (jsonString == null) return null;
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  static Future<void> setThemeColors(String themeName, Map<String, dynamic> colors) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(colors);
    await prefs.setString('$_themeColorsKey$themeName', jsonString);
  }

  static Future<void> clearThemeColors(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_themeColorsKey$themeName');
  }
} 