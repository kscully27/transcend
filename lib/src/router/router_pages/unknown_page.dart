import 'package:flutter/material.dart';
import 'package:trancend/src/unknown/unknown_screen.dart';

class UnknownPage extends Page<void> {
  const UnknownPage()
      : super(key: const ValueKey('UnknownPage'), name: 'Unknown Screen');

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      settings: this,
      builder: (context) => const UnknownScreen(),
    );
  }
}
