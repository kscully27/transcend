import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trancend/src/providers/trance_settings_provider.dart';
import 'package:trancend/src/ui/clay/clay_button.dart';
import 'package:trancend/src/ui/value_selector.dart';

/// A modal component for selecting the break duration between sentences
class BreakDurationSelector extends ConsumerStatefulWidget {
  /// The callback when the modal is closed
  final VoidCallback? onClose;
  
  /// The title of the modal
  final String title;
  
  /// The initial break duration in seconds
  final int initialDuration;
  
  const BreakDurationSelector({
    super.key,
    this.onClose,
    required this.title,
    required this.initialDuration,
  });

  @override
  ConsumerState<BreakDurationSelector> createState() => _BreakDurationSelectorState();
}

class _BreakDurationSelectorState extends ConsumerState<BreakDurationSelector> {
  late int _selectedDuration;
  final List<int> _durationOptions = [1, 2, 3, 4, 5, 6, 7, 8]; // Options in seconds
  
  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialDuration;
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.shadow,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Select how much time to pause between sentences during your session',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.shadow.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 30),
        
        // Value selector for break duration
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ValueSelector(
            values: _durationOptions,
            unit: 'seconds',
            initialValue: _selectedDuration,
            backgroundColor: Colors.white.withOpacity(0.3),
            textColor: theme.colorScheme.shadow,
            onValueChanged: (value) {
              setState(() {
                _selectedDuration = value;
              });
            },
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Apply button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ClayButton(
            color: Colors.white,
            parentColor: Colors.white.withOpacity(0.5),
            borderRadius: 10,
            height: 50,
            text: 'Apply',
            textColor: theme.colorScheme.shadow,
            onPressed: () {
              // Update the break duration setting
              ref.read(tranceSettingsProvider.notifier).setBreakBetweenSentences(_selectedDuration);
              
              // Close the modal
              Navigator.of(context).pop();
              
              // Call the onClose callback if provided
              if (widget.onClose != null) {
                Future.delayed(const Duration(milliseconds: 300), widget.onClose!);
              }
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
} 