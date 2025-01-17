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
    return ColorSchemeData(
      name: json['name'] as String,
      title: json['title'] as String,
      colors: (json['colors'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, v.toString()),
          ),
        ),
      ),
      theme: (json['theme'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, v.toString()),
          ),
        ),
      ),
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
    return int.parse(colorValue);
  }

  static Future<ColorSchemeData> load(String name) async {
    final jsonString = await rootBundle.loadString('assets/color_schemes/${name}_colors.json');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    return ColorSchemeData.fromJson(jsonData);
  }
} 