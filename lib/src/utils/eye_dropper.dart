import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ColorPicker {
  static Future<Color?> pickColor() async {
    if (!kIsWeb) return null;
    
    // This will be replaced by the web implementation
    return null;
  }
} 