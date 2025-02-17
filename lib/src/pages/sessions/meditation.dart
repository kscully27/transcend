import 'package:flutter/material.dart';

class Meditation extends StatelessWidget {
  final VoidCallback onBack;
  final void Function(Duration) onStart;

  const Meditation({
    Key? key,
    required this.onBack,
    required this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Meditation Page - Coming Soon'),
    );
  }
} 