import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: theme.colorScheme.shadow.withOpacity(0.7),
                size: 20,
              ),
              onPressed: widget.onBack,
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
                        IconButton(
              icon: Icon(
                Remix.equalizer_3_fill,
                color: theme.colorScheme.shadow.withOpacity(0.7),
                size: 20,
              ),
              onPressed: widget.onBack,
            ),
          ],
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
        // const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GlassButton(
            onPressed: () => widget.onStart(_selectedDuration),
            text: "Start Session",
            textColor: theme.colorScheme.shadow,
            glassColor: Colors.white10,
            height: 60,
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
} 