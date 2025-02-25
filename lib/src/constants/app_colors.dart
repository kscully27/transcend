// ignore_for_file: constant_identifier_names

library;

import 'package:flutter/material.dart';
import 'package:trancend/src/constants/enums.dart';
import 'color_scheme.dart';

enum AppColor { Red, Orange, Blue, Green, Purple, Pink, Light, White, Dark }

enum CategoryColor { Red, Orange, Blue, Green, Purple, Pink }

extension CategoryColorX on CategoryColor {
  CategoryColor fromString(String string) =>
      enumFromString(string, CategoryColor.values);
  String get string => enumToString(this);
  String get id => string.toLowerCase();
  Color get color => AppColors.flat(id);
  Color get flat => AppColors.flat(id);
  Color get dark => AppColors.dark(id);
  Color get light => AppColors.light(id);
  Color get highlight => AppColors.highlight(id);
  Color get shadow => AppColors.shadow(id);
}

enum ColorName {
  Blue,
  Green,
  Purple,
  Red,
  Orange,
  Pink,
  Light,
  Dark,
  White,
  Black,
  Facebook,
  Google,
  Transparent,
  Disabled
}

extension PrimaryColorX on AppColor {
  AppColor fromString(String string) => enumFromString(string, AppColor.values);
  String get string => enumToString(this);
  String get id => string.toLowerCase();
  Color get color => AppColors.flat(id);
  Color get flat => AppColors.flat(id);
  Color get dark => AppColors.dark(id);
  Color get light => AppColors.light(id);
  Color get highlight => AppColors.highlight(id);
  Color get shadow => AppColors.shadow(id);
}

extension AllPrimaryColors on ColorName {
  ColorName fromString(String string) =>
      enumFromString(string, ColorName.values);
  String get string => enumToString(this);
  String get id => string.toLowerCase();
  Color get color => AppColors.flat(id);
  Color get flat => AppColors.flat(id);
  Color get dark => AppColors.dark(id);
  Color get light => AppColors.light(id);
  Color get highlight => AppColors.highlight(id);
  Color get shadow => AppColors.shadow(id);
}

enum ColorType {
  Flat,
  Light,
  Dark,
  Shadow,
  Highlight,
}

enum GradientType {
  Flat,
  Light,
  Dark,
  Gentle,
  Bold,
}

class ColorGroup {
  ColorName name;
  int flat;
  int light;
  int dark;
  int shadow;
  int highlight;
  String category;
  
  ColorGroup({
    required this.name,
    required this.flat,
    required this.light,
    required this.dark,
    required this.shadow,
    required this.highlight,
    required this.category,
  });

  factory ColorGroup.fromMap(dynamic data) {
    // Handle the case where data is a Map<String, int>
    if (data is Map<String, int>) {
      return ColorGroup(
        name: ColorName.Blue, // Default color name
        flat: data['flat'] ?? 0,
        light: data['light'] ?? data['flat'] ?? 0,
        dark: data['dark'] ?? data['flat'] ?? 0,
        shadow: data['shadow'] ?? data['flat'] ?? 0,
        highlight: data['highlight'] ?? data['flat'] ?? 0,
        category: 'default', // Default category
      );
    }
    
    // Handle the case where data is a Map with ColorName
    return ColorGroup(
      name: (data['name'] as String?)?.toColorName() ?? ColorName.Blue,
      flat: data['flat'] ?? 0,
      light: data['light'] ?? data['flat'] ?? 0,
      dark: data['dark'] ?? data['flat'] ?? 0,
      shadow: data['shadow'] ?? data['flat'] ?? 0,
      highlight: data['highlight'] ?? data['flat'] ?? 0,
      category: data['category'] ?? 'default',
    );
  }
}

// Add this extension to help convert String to ColorName
extension StringToColorName on String {
  ColorName toColorName() {
    try {
      return ColorName.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == toLowerCase(),
        orElse: () => ColorName.Blue,
      );
    } catch (_) {
      return ColorName.Blue;
    }
  }
}

class GradientGroup {
  late GradientType name;
  late List<double> stops;
  late List<Color> colors;
}

const List<GradientGroup> gradientGroups = [];

const defaultStops = [0.3, 0.7];

class AppGradient extends LinearGradient {
  final String colorName;
  final GradientType type;
  @override
  final AlignmentGeometry begin;
  @override
  final AlignmentGeometry end;
  @override
  final List<double> stops;
  @override
  final List<Color> colors;
  const AppGradient({
    this.colorName = "blue",
    this.type = GradientType.Flat,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.stops = defaultStops,
    required this.colors,
  }) : super(
          colors: colors,
          stops: stops,
        );
  static linear({
    colorName = "blue",
    type = GradientType.Flat,
    begin = Alignment.topCenter,
    end = Alignment.bottomCenter,
    stops = defaultStops,
    colors,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      stops: stops,
      colors: colors,
    );
  }

  get value {
    return LinearGradient(
      begin: begin,
      end: end,
      stops: stops,
      colors: colors,
    );
  }
}

class GradientColors {
  GradientType type;
  List<double> stops;
  GradientColors(
      {this.type = GradientType.Flat, this.stops = const [0.0, 1.0]});
}

const Map<String, Map<String, int>> earthToneColors = {
  "khaki": {
    "flat": 0xFFD59074,
    "light": 0xFFE2BFAF,
    "dark": 0xFF883912,
    "shadow": 0xFF8B5E3C,
    "highlight": 0xFFFFFFFF,
  },
  "blue": {
    "flat": 0xFFD59074,
    "light": 0xFFE6B695,
    "dark": 0xFFB67857,
    "shadow": 0xFF8B5E3C,
    "highlight": 0xFFF2D9C7,
  },
  "green": {
    "flat": 0xFF8B7355,
    "light": 0xFFAA9177,
    "dark": 0xFF6D5A43,
    "shadow": 0xFF4D3F2D,
    "highlight": 0xFFCCBDAA,
  },
  "purple": {
    "flat": 0xFF9C7A63,
    "light": 0xFFBE9B84,
    "dark": 0xFF7E5F48,
    "shadow": 0xFF5E4636,
    "highlight": 0xFFDEC3AD,
  },
  "red": {
    "flat": 0xFFA65D57,
    "light": 0xFFC88078,
    "dark": 0xFF884540,
    "shadow": 0xFF663330,
    "highlight": 0xFFE6B3B0,
  },
  "orange": {
    "flat": 0xFFD6924A,
    "light": 0xFFE5B37C,
    "dark": 0xFFB37339,
    "shadow": 0xFF8C592D,
    "highlight": 0xFFF2D4B3,
  },
  "pink": {
    "flat": 0xFFCB8A72,
    "light": 0xFFDBAB93,
    "dark": 0xFFAD6B53,
    "shadow": 0xFF8B503A,
    "highlight": 0xFFEBCCB4,
  },
  "dark": {
    "flat": 0xFF4A3B2F,
    "light": 0xFF695647,
    "dark": 0xFF362B22,
    "shadow": 0xFF231C16,
    "highlight": 0xFF8C7A6B,
  },
  "light": {
    "flat": 0xFFF5E6D3,
    "light": 0xFFFFF4E6,
    "dark": 0xFFE6D0B3,
    "shadow": 0xFFBFA88C,
    "highlight": 0xFFFFFAF0,
  },
  "white": {
    "flat": 0xFFFAF6F0,
    "dark": 0xFFE6D0B3,
    "shadow": 0xFFD4C4A8,
  },
  "black": {
    "flat": 0xFF2B1810,
  },
  "google": {
    "flat": 0xFF8B5E3C,
  },
  "facebook": {
    "flat": 0xFF6B4423,
  },
  "transparent": {
    "flat": 0x00000000
  },
  "primaryDark": {
    "flat": 0xFF4A3B2F
  }
};

const Map<String, Map<String, int>> colors = {
  "khaki": {
    "flat": 0xFFFF8E7E,    // Mars Pink (Primary)
    "light": 0xFFFFB5A7,   // Light Mars Pink
    "dark": 0xFFE56F5D,    // Dark Mars Pink
    "shadow": 0xFFCC4F3D,  // Deep Mars Pink
    "highlight": 0xFFFFD6CF, // Pale Mars Pink
  },
  "blue": {
    "flat": 0xFFD59074,    // Warm Terracotta
    "light": 0xFFE6B695,   // Light Clay
    "dark": 0xFFB67857,    // Deep Clay
    "shadow": 0xFF8B5E3C,  // Dark Brown
    "highlight": 0xFFF2D9C7, // Pale Clay
  },
  "green": {
    "flat": 0xFF8B7355,    // Umber
    "light": 0xFFAA9177,   // Light Umber
    "dark": 0xFF6D5A43,    // Dark Umber
    "shadow": 0xFF4D3F2D,  // Deep Brown
    "highlight": 0xFFCCBDAA, // Pale Umber
  },
  "purple": {
    "flat": 0xFF9C7A63,    // Taupe
    "light": 0xFFBE9B84,   // Light Taupe
    "dark": 0xFF7E5F48,    // Dark Taupe
    "shadow": 0xFF5E4636,  // Deep Taupe
    "highlight": 0xFFDEC3AD, // Pale Taupe
  },
  "red": {
    "flat": 0xFFA65D57,    // Terra Cotta
    "light": 0xFFC88078,   // Light Terra Cotta
    "dark": 0xFF884540,    // Dark Terra Cotta
    "shadow": 0xFF663330,  // Deep Terra Cotta
    "highlight": 0xFFE6B3B0, // Pale Terra Cotta
  },
  "orange": {
    "flat": 0xFFFF7F50,    // Coral Orange
    "light": 0xFFFFAB90,   // Light Coral
    "dark": 0xFFE65B32,    // Dark Coral
    "shadow": 0xFFCC4019,  // Deep Coral
    "highlight": 0xFFFFCFBF, // Pale Coral
  },
  "pink": {
    "flat": 0xFFCB8A72,    // Rose Clay
    "light": 0xFFDBAB93,   // Light Rose Clay
    "dark": 0xFFAD6B53,    // Dark Rose Clay
    "shadow": 0xFF8B503A,  // Deep Rose Clay
    "highlight": 0xFFEBCCB4, // Pale Rose Clay
  },
  "dark": {
    "flat": 0xFF2D1810,    // Mars Dark
    "light": 0xFF4A2920,   // Light Mars Dark
    "dark": 0xFF1A0E09,    // Deep Mars Dark
    "shadow": 0xFF0D0704,  // Shadow Mars Dark
    "highlight": 0xFF6B3F30, // Highlight Mars Dark
  },
  "light": {
    "flat": 0xFFFFF0EB,    // Mars White
    "light": 0xFFFFF8F6,   // Light Mars White
    "dark": 0xFFFFE6E0,    // Dark Mars White
    "shadow": 0xFFFFD6CF,  // Shadow Mars White
    "highlight": 0xFFFFFFFF, // Pure White
  },
  "white": {
    "flat": 0xFFFAF6F0,    // Off White
    "dark": 0xFFE6D0B3,    // Antique White
    "shadow": 0xFFD4C4A8,  // Shadow White
  },
  "black": {
    "flat": 0xFF2B1810,    // Deep Brown Black
  },
  "google": {
    "flat": 0xFF8B5E3C,    // Earth Brown
  },
  "facebook": {
    "flat": 0xFF6B4423,    // Deep Earth Brown
  },
  "transparent": {
    "flat": 0x00000000
  },
  "primaryDark": {
    "flat": 0xFF4A3B2F     // Dark Earth
  }
};

class AppColorMaker {
  String name;
  late ColorType type;
  late List<ColorGroup> defaultColors;
  AppColorMaker({
    this.name = 'blue',
    this.type = ColorType.Flat,
    required this.defaultColors,
  });

  ColorGroup get group =>
      defaultColors.where((cg) => cg.category == name).firstOrNull!;

  Color get value => Color(group.flat);
  Color get flat => Color(group.flat);
  Color get light => Color(group.light);
  Color get dark => Color(group.dark);
  Color get shadow => Color(group.shadow);
  Color get highlight => Color(group.highlight);

  Gradient gradient() {
    return AppGradient.linear(type: GradientType.Flat);
  }
}

class AppColors {
  static ColorSchemeData? _currentScheme;
  static String _currentSchemeName = 'candy';
  static bool enableGradients = true;

  static ColorSchemeData? get currentScheme => _currentScheme;

  static Future<void> initialize() async {
    await loadColorScheme(_currentSchemeName);
  }

  static Future<void> loadColorScheme(String name) async {
    _currentScheme = await ColorSchemeData.load(name);
    _currentSchemeName = name;
  }

  static Color flat(String name) => _getColor(name, 'flat');
  static Color light(String name) => _getColor(name, 'light');
  static Color dark(String name) => _getColor(name, 'dark');
  static Color highlight(String name) => _getColor(name, 'highlight');
  static Color shadow(String name) => _getColor(name, 'shadow');

  static Color _getColor(String name, String mode) {
    if (_currentScheme == null) {
      throw StateError('Color scheme not initialized. Call AppColors.initialize() first.');
    }
    return Color(_currentScheme!.getColor(name, mode));
  }

  static Color themedWithContext(BuildContext context, String name, String lightMode, [String? darkMode]) {
    final brightness = Theme.of(context).brightness;
    final mode = brightness == Brightness.light ? lightMode : (darkMode ?? lightMode);
    return _getColor(name, mode);
  }

  static Color disabled(String color) {
    return light(color).withOpacity(.2);
  }

  static Gradient gradient(String color) {
    return AppGradient.linear(
      colors: [light(color), flat(color)],
    );
  }

  static Gradient bigGradient(String color) {
    return AppGradient.linear(
      colors: [light(color), dark(color)],
    );
  }

  static Gradient darkGradient(String color) {
    return AppGradient.linear(
      colors: [flat(color), shadow(color)],
    );
  }

  static Gradient extremeGradient(String color) {
    return AppGradient.linear(
      stops: [.1, .9],
      colors: [highlight(color), shadow(color)],
    );
  }

  static Gradient lightGradient(String color) {
    return AppGradient.linear(
      colors: [highlight(color), light(color)],
    );
  }

  static String getColorName(String groupName) {
    String colorName = "light";
    if (groupName == 'default') {
      colorName = "light";
    } else if (groupName == 'dark') {
      colorName = "dark";
    } else if (groupName == 'mental') {
      colorName = "blue";
    } else if (groupName == 'physical') {
      colorName = "red";
    } else if (groupName == 'emotional') {
      colorName = "pink";
    } else if (groupName == 'lifestyle') {
      colorName = "orange";
    } else if (groupName == 'spiritual') {
      colorName = "purple";
    } else if (groupName == 'success') {
      colorName = "green";
    }
    return colorName;
  }

  static Gradient groupGradient(String group) {
    String _colorName = getColorName(group);
    return AppGradient.linear(
      colors: [highlight(_colorName), light(_colorName)],
    );
  }

  static Gradient gentleGradient(String group) {
    String _colorName = getColorName(group);
    return AppGradient.linear(
      colors: [light(_colorName), flat(_colorName)],
    );
  }

  static Gradient gentleColorGradient(String group) {
    String _colorName = getColorName(group);
    return AppGradient.linear(
      stops: [0.1, 0.9],
      colors: [dark(_colorName), flat(_colorName)],
    );
  }

  static Color groupColor(String group, {String type = 'flat'}) {
    String _colorName = getColorName(group);
    switch (type) {
      case 'flat':
        return flat(_colorName);
      case 'light':
        return light(_colorName);
      case 'dark':
        return dark(_colorName);
      case 'shadow':
        return shadow(_colorName);
      case 'highlight':
        return highlight(_colorName);
      default:
        return flat(_colorName);
    }
  }

  static Gradient marsBackgroundGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        dark('dark'),
        flat('dark'),
      ],
    );
  }
}
