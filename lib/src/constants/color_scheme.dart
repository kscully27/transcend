// ignore_for_file: unnecessary_type_check

import 'dart:convert';
import 'package:flutter/services.dart';

class ColorSchemeData {
  final String name;
  final String title;
  final Map<String, Map<String, String>> colors;
  final Map<String, Map<String, String>> theme;

  ColorSchemeData({
    required this.name,
    required this.title,
    required this.colors,
    required this.theme,
  });

  factory ColorSchemeData.fromJson(Map<String, dynamic> json) {
    print('Parsing ColorSchemeData from JSON: ${json.keys}');
    
    // Parse theme data with better error handling
    final themeData = json['theme'] as Map<String, dynamic>;
    final parsedTheme = themeData.map((key, value) {
      final themeColors = (value as Map<String, dynamic>).map((k, v) {
        print('Processing theme color: $k = $v');
        return MapEntry(k, v.toString());
      });
      return MapEntry(key, themeColors);
    });

    // Parse colors data
    final colorsData = json['colors'];
    final parsedColors = colorsData != null
        ? (colorsData as Map<String, dynamic>).map((key, value) {
            final colorVariants = (value as Map<String, dynamic>).map((k, v) {
              return MapEntry(k, v.toString());
            });
            return MapEntry(key, colorVariants);
          })
        : <String, Map<String, String>>{};

    return ColorSchemeData(
      name: json['name'] as String? ?? 'candy',
      title: json['title'] as String? ?? 'Default Theme',
      colors: parsedColors,
      theme: parsedTheme,
    );
  }

  int getColor(String name, String mode) {
    final colorData = colors[name];
    if (colorData == null) {
      throw ArgumentError("Invalid color name: $name");
    }
    final colorValue = colorData[mode];
    if (colorValue == null) {
      throw ArgumentError("Invalid color mode: $mode");
    }
    // Handle both string and int color values
    if (colorValue is String) {
      return int.parse(colorValue.replaceFirst('0x', ''), radix: 16);
    }
    return colorValue as int;
  }

  String? getThemeColor(String mode, String colorName) {
    final modeData = theme[mode];
    if (modeData == null) {
      print('Theme mode not found: $mode');
      return null;
    }
    final color = modeData[colorName];
    if (color == null) {
      print('Theme color not found: $colorName in mode $mode');
    }
    return color;
  }

  static Future<ColorSchemeData> load(String name) async {
    print('Loading color scheme: $name');
    final jsonString = await rootBundle.loadString('assets/color_schemes/${name}_colors.json');
    print('Loaded JSON string length: ${jsonString.length}');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    print('Decoded JSON keys: ${jsonData.keys}');
    return ColorSchemeData.fromJson(jsonData);
  }
} 