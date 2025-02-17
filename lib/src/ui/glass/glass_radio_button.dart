import 'package:flutter/material.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

class GlassRadioButton<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? title;
  final IconData? icon;
  final TextStyle? titleStyle;

  const GlassRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.icon,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: GestureDetector(
        onTap: () => onChanged?.call(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GlassContainer(
            backgroundColor: Colors.white12,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: theme.colorScheme.shadow),
                    const SizedBox(width: 8),
                  ],
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: titleStyle ??
                            TextStyle(
                              color: theme.colorScheme.shadow,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white70: Colors.white12,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: theme.colorScheme.shadow.withOpacity(0.1),
                        width: 0.5,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Icon(
                              Icons.check,
                              size: 25,
                              color: theme.colorScheme.shadow,
                            ),
                          )
                        : Container(),
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
