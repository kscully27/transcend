import 'package:flutter/material.dart';
import 'package:trancend/src/ui/time_slider.dart';

class Hypnotherapy extends StatefulWidget {
  final VoidCallback onBack;
  final Function(int duration) onStart;

  const Hypnotherapy({
    super.key,
    required this.onBack,
    required this.onStart,
  });

  @override
  State<Hypnotherapy> createState() => _HypnotherapyState();
}

class _HypnotherapyState extends State<Hypnotherapy> {
  int _selectedDuration = 20;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Positioned(
              left: 4,
              top: 8,
              bottom: 8,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: theme.colorScheme.shadow.withOpacity(0.7),
                  size: 20,
                ),
                onPressed: widget.onBack,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48.0,
                  vertical: 16.0,
                ),
                child: Text(
                  'Hypnotherapy',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.shadow,
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Session Duration',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.shadow,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 100,
          child: TimeSlider(
            values: const [3, 5, 8, 10, 15, 20, 25, 30],
            onValueChanged: (value) {
              setState(() {
                _selectedDuration = value;
              });
            },
            color: theme.colorScheme.shadow,
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ElevatedButton(
            onPressed: () => widget.onStart(_selectedDuration),
            child: const Text('Start Session'),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
} 