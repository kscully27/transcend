import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trancend/src/ui/time_slider.dart';

class HypnotherapyBottomSheet extends StatefulWidget {
  final VoidCallback onBack;

  const HypnotherapyBottomSheet({
    super.key,
    required this.onBack,
  });

  @override
  State<HypnotherapyBottomSheet> createState() => _HypnotherapyBottomSheetState();
}

class _HypnotherapyBottomSheetState extends State<HypnotherapyBottomSheet> {
  bool isAnimatingOut = false;
  int _selectedDuration = 20;

  void _handleBack() {
    setState(() {
      isAnimatingOut = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.onBack();
    });
  }

  void _showHypnotherapySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white24,
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20.0,
              sigmaY: 20.0,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                      Text(
                        'Hypnotherapy Settings',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 64), // Balance the cancel button
                    ],
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text('Settings content will go here'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      tween: Tween(
        begin: 0.6,
        end: 0.9,
      ),
      onEnd: () {
        if (isAnimatingOut) {
          widget.onBack();
        }
      },
      builder: (context, value, child) {
        return DraggableScrollableSheet(
          minChildSize: 0.6,
          initialChildSize: value,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(
                  color: Colors.white24,
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0,
                    sigmaY: 20.0,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.25,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: Colors.black12,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                              onPressed: _handleBack,
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
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.shadow,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 8,
                            bottom: 8,
                            child: IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: theme.colorScheme.shadow.withOpacity(0.7),
                                size: 20,
                              ),
                              onPressed: () => _showHypnotherapySettings(context),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 40),
                              Text(
                                'Session Duration',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.shadow,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              TimeSlider(
                                color: theme.colorScheme.shadow,
                                onValueChanged: (value) {
                                  setState(() {
                                    _selectedDuration = value;
                                  });
                                },
                                height: 100,
                              ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isAnimatingOut = true;
                                    });
                                    Future.delayed(const Duration(milliseconds: 300), () {
                                      Navigator.pop(context);
                                      // TODO: Implement start functionality with _selectedDuration
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.onPrimary,
                                    foregroundColor: theme.colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    minimumSize: const Size(double.infinity, 0),
                                  ),
                                  child: const Text(
                                    'Start',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
} 