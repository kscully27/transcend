import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';

class ClaySlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final Color parentColor;
  final Color activeSliderColor;
  final Color? inactiveSliderColor;
  final bool hasKnob;
  
  const ClaySlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.parentColor,
    required this.activeSliderColor,
    this.inactiveSliderColor,
    this.hasKnob = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbPosition = width * value;
        
        return SizedBox(
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Track
              ClayContainer(
                color: parentColor,
                height: 8,
                width: double.infinity,
                borderRadius: 4,
                depth: -20,
                spread: 2,
                curveType: CurveType.concave,
                child: Row(
                  children: [
                    // Active part
                    Container(
                      width: hasKnob ? thumbPosition : width * value,
                      decoration: BoxDecoration(
                        color: activeSliderColor,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasKnob) ...[
                // Thumb
                Positioned(
                  left: thumbPosition - 12,
                  child: ClayContainer(
                    color: parentColor,
                    height: 24,
                    width: 24,
                    borderRadius: 12,
                    depth: 10,
                    spread: 2,
                    child: Center(
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: activeSliderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              // Gesture detector
              Positioned.fill(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final double localDx = details.localPosition.dx;
                    final double normalizedValue = localDx / box.size.width;
                    final double clampedValue = normalizedValue.clamp(0.0, 1.0);
                    onChanged(clampedValue);
                  },
                  onTapDown: (details) {
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final double localDx = details.localPosition.dx;
                    final double normalizedValue = localDx / box.size.width;
                    final double clampedValue = normalizedValue.clamp(0.0, 1.0);
                    onChanged(clampedValue);
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
} 