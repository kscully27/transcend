import 'package:flutter/material.dart';

class Breathwork extends StatelessWidget {
  final VoidCallback onBack;
  final void Function(Duration) onStart;

  const Breathwork({
    Key? key,
    required this.onBack,
    required this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Breathwork Page - Coming Soon'),
    );
  }
} 