import 'package:flutter/material.dart';

class Active extends StatelessWidget {
  final VoidCallback onBack;
  final void Function(Duration) onStart;

  const Active({
    Key? key,
    required this.onBack,
    required this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Active Hypnotherapy Page - Coming Soon'),
    );
  }
} 