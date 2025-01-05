// ignore_for_file: constant_identifier_names

library appcolors;

import 'package:flutter/material.dart';

String enumToString(Object o) => o.toString().split('.').last;

T enumFromString<T>(String key, List<T> values) =>
    values.where((v) => key == enumToString(v as Object)).firstOrNull as T;

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
  ColorGroup(
      {required this.name,
      required this.flat,
      required this.light,
      required this.dark,
      required this.shadow,
      required this.highlight,
      required this.category});

  factory ColorGroup.fromMap(dynamic _data) {
    return ColorGroup(
      name: _data['name'],
      flat: _data['flat'],
      light: _data['light'] ?? _data['flat'],
      dark: _data['dark'] ?? _data['flat'],
      shadow: _data['shadow'] ?? _data['flat'],
      highlight: _data['highlight'] ?? _data['flat'],
      category: _data['category'],
    );
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
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;
  AppGradient({
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

const Map<String, Map<String, int>> colors = {
  "blue": {
    "flat": 0xFF5A9BFF,
    "light": 0xFF64B6FF,
    "dark": 0xFF4E7CFF,
    "shadow": 0xFF275BAC,
    "highlight": 0xFFBEDFFF,
  },
  "green": {
    "flat": 0xFF77B534,
    "light": 0xFF9AD051,
    "dark": 0xFF4F9904,
    "shadow": 0xFF4F9904,
    "highlight": 0xFFEDFFC6,
  },
  "purple": {
    "flat": 0xFF8652FF,
    "light": 0xFFE16AFF,
    "dark": 0xFFA835DE,
    "shadow": 0xFF820ABA,
    "highlight": 0xFFECA3FF,
  },
  "red": {
    "flat": 0xFFFB6A7A,
    "light": 0xFFFF8290,
    "dark": 0xFFD33447,
    "shadow": 0xFFC5031B,
    "highlight": 0xFFFFA7B1,
  },
  "orange": {
    "flat": 0xFFF59850,
    "light": 0xFFFFB160,
    "dark": 0xFFEA7C3F,
    "shadow": 0xFFE35D10,
    "highlight": 0xFFFFD5AA,
  },
  "pink": {
    "flat": 0xFFEF519E,
    "light": 0xFFFF6A97,
    "dark": 0xFFDE35A5,
    "shadow": 0xFFBA057C,
    "highlight": 0xFFFF99B9,
  },
  "dark": {
    "flat": 0xFF3B4261,
    "light": 0xFF4C5479,
    "dark": 0xFF2A304A,
    "shadow": 0xFF111111,
    "highlight": 0xFF989FC0,
  },
  "light": {
    "flat": 0xFFE3EAF4,
    "light": 0xFFECF3FE,
    "dark": 0xFFC4D6E9,
    "shadow": 0xFF779FD3,
    "highlight": 0xFFFFFFFF,
  },
  "white": {
    "flat": 0xFFFFFFFF,
    "dark": 0xFFC4D6E9,
    "shadow": 0xFFC4D6E9,
  },
  "black": {
    "flat": 0xFF000000,
  },
  "google": {
    "flat": 0xFFde5246,
  },
  "facebook": {
    "flat": 0xFF3b5998,
  },
  "transparent": {"flat": 0x00000000},
  "primaryDark": {"flat": 0xff5D658B}
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
  static Color flat(String _color) {
    return Color(ColorGroup.fromMap(colors[_color]).flat);
  }

  static Color light(String _color) {
    return Color(ColorGroup.fromMap(colors[_color]).light);
  }

  static Color disabled(String _color) {
    return Color(ColorGroup.fromMap(colors[_color]).light).withOpacity(.2);
  }

  static Color dark(String _color) {
    return Color(ColorGroup.fromMap(colors[_color]).dark);
  }

  static Color shadow(String _color) {
    return Color(ColorGroup.fromMap(colors[_color]).shadow);
  }

  static Color highlight(String _color) {
    return Color(ColorGroup.fromMap(colors[_color]).highlight);
  }

  static Gradient gradient(String _color) {
    return AppGradient.linear(
      colors: [light(_color), flat(_color)],
    );
  }

  static Gradient bigGradient(String _color) {
    return AppGradient.linear(
      colors: [light(_color), dark(_color)],
    );
  }

  static Gradient darkGradient(String _color) {
    return AppGradient.linear(
      colors: [flat(_color), shadow(_color)],
    );
  }

  static Gradient extremeGradient(String _color) {
    return AppGradient.linear(
      stops: [.1, .9],
      colors: [highlight(_color), shadow(_color)],
    );
  }

  static Gradient lightGradient(String _color) {
    return AppGradient.linear(
      colors: [highlight(_color), light(_color)],
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
    String _colorName = "blue";
    Color mainColor = flat("blue");
    _colorName = getColorName(group);

    if (type == 'flat') {
      mainColor = flat(_colorName);
    }
    if (type == "light") {
      mainColor = light(_colorName);
    }
    if (type == "dark") {
      mainColor = dark(_colorName);
    }
    if (type == "shadow") {
      mainColor = shadow(_colorName);
    }
    if (type == "highlight") {
      mainColor = highlight(_colorName);
    }
    return mainColor;
  }
}
