// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util' as js_util;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ColorPicker {
  static Future<Color?> pickColor() async {
    if (!kIsWeb) return null;
    
    try {
      final eyeDropper = js_util.callConstructor(js_util.getProperty(js_util.globalThis, 'EyeDropper'), []);
      final result = await js_util.promiseToFuture(js_util.callMethod(eyeDropper, 'open', []));
      final hexColor = js_util.getProperty(result, 'sRGBHex') as String;
      return Color(int.parse('0xFF${hexColor.substring(1)}'));
    } catch (e) {
      print('Error picking color: $e');
      return null;
    }
  }
} 