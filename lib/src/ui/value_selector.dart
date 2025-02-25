import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom widget that allows selecting a value from a vertical list
/// with haptic feedback when values are selected.
class ValueSelector extends StatefulWidget {
  /// The list of values to select from
  final List<int> values;
  
  /// The unit label to display next to the value (e.g., "seconds")
  final String unit;
  
  /// The initial value to select
  final int initialValue;
  
  /// Called when a value is selected
  final Function(int) onValueChanged;
  
  /// The height of the selector
  final double height;
  
  /// The background color of the selector
  final Color backgroundColor;
  
  /// The text color for the values
  final Color textColor;
  
  const ValueSelector({
    super.key,
    required this.values,
    required this.unit,
    required this.initialValue,
    required this.onValueChanged,
    this.height = 150,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  State<ValueSelector> createState() => _ValueSelectorState();
}

class _ValueSelectorState extends State<ValueSelector> {
  late FixedExtentScrollController _scrollController;
  late int _selectedIndex;
  
  @override
  void initState() {
    super.initState();
    // Find the index of the initial value
    _selectedIndex = widget.values.indexOf(widget.initialValue);
    if (_selectedIndex < 0) _selectedIndex = 0;
    
    // Initialize the scroll controller with the initial value
    _scrollController = FixedExtentScrollController(initialItem: _selectedIndex);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Center indicator
          Center(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // The wheel list with just the numbers
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // The scrollable value portion
              SizedBox(
                width: 60, // Fixed width for the number
                child: ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  itemExtent: 40, // Height of each item
                  perspective: 0.005, // Creates a subtle 3D effect
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    // Provide haptic feedback when selection changes
                    HapticFeedback.selectionClick();
                    
                    setState(() {
                      _selectedIndex = index;
                    });
                    
                    // Notify parent of the change
                    widget.onValueChanged(widget.values[index]);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: widget.values.length,
                    builder: (context, index) {
                      final isSelected = index == _selectedIndex;
                      
                      return Center(
                        child: Text(
                          '${widget.values[index]}',
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: isSelected ? 22 : 18,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Fixed unit label
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  widget.unit,
                  style: TextStyle(
                    color: widget.textColor.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 