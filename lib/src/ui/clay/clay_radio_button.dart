import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';

class ClayRadioButton<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Color color;
  final Color parentColor;
  final double depth;
  final double spread;
  final double borderRadius;
  final double size;
  final String? title;
  final IconData? icon;
  final TextStyle? titleStyle;

  const ClayRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.color,
    required this.parentColor,
    this.depth = 20.0,
    this.spread = 2.0,
    this.borderRadius = 10.0,
    this.size = 24.0,
    this.title,
    this.icon,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: GestureDetector(
        onTap: () => onChanged?.call(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ClayContainer(
            color: color,
            parentColor: parentColor,
            depth: depth.toInt(),
            spread: spread,
            borderRadius: borderRadius,
            emboss: isSelected,
            width: double.infinity,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Theme.of(context).colorScheme.onSurface),
                    const SizedBox(width: 8),
                  ],
                  if (title != null) 
                    Expanded(
                      child: Text(
                        title!,
                        style: titleStyle ?? TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ClayContainer(
                    color: color,
                    parentColor: parentColor,
                    depth: (depth / 2).toInt(),
                    spread: spread / 2,
                    borderRadius: 15,
                    height: 30,
                    width: 30,
                    emboss: !isSelected,
                    child: isSelected
                      ? Center(
                          child: Icon(
                            Icons.check,
                            size: 25,
                            color: Colors.white,
                          ),
                        )
                      : null,
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 