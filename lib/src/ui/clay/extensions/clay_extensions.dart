import 'package:flutter/material.dart';
import 'package:trancend/src/ui/clay/theme/clay_theme.dart';
import 'package:trancend/src/ui/clay/theme/clay_theme_data.dart';

extension ContextExt on BuildContext {
  ClayThemeData? get clayTheme => ClayTheme.of(this);
}
