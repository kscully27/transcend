import 'package:flutter/material.dart';
import 'package:trancend/src/ui/clay/theme/clay_theme_data.dart';

class ClayTheme extends InheritedWidget {
  const ClayTheme({required this.themeData, required super.child, super.key});

  final ClayThemeData themeData;

  static ClayThemeData? of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<ClayTheme>()?.themeData;
  }

  @override
  bool updateShouldNotify(covariant ClayTheme oldWidget) => true;
}