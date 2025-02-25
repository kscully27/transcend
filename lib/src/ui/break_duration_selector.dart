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
    
    // Compact layout with minimal extra space
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
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
          
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
            child: Text(
              'Select how much time to pause between sentences',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.shadow.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Value selector - maintain 120px height as requested
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8.0),
            child: ValueSelector(
              values: _durationOptions,
              unit: 'seconds',
              initialValue: _selectedDuration,
              backgroundColor: Colors.white.withOpacity(0.3),
              textColor: theme.colorScheme.shadow,
              height: 120, // Keep at 120px as requested
              onValueChanged: (value) {
                setState(() {
                  _selectedDuration = value;
                });
              },
            ),
          ),
          
          // Apply button positioned higher with less vertical space
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: ClayButton(
              color: Theme.of(context).colorScheme.primary,
              parentColor: Colors.white,
              borderRadius: 10,
              height: 50,
              text: 'Apply',
              onPressed: () {
                // Important: update state before closing modal
                ref.read(tranceSettingsProvider.notifier).setBreakBetweenSentences(_selectedDuration);
                
                // Close the modal
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
} 