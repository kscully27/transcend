import 'package:flutter/material.dart';
import 'package:trancend/src/ui/clay_container.dart';

class ClayText extends StatelessWidget {
  final String text;
  final Color color;
  final Color parentColor;
  final Color? textColor;
  final double size;
  final bool emboss;
  final double depth;
  final double spread;
  final TextStyle? style;

  const ClayText(
    this.text, {
    super.key,
    required this.color,
    required this.parentColor,
    this.textColor,
    this.size = 16,
    this.emboss = false,
    this.depth = 20,
    this.spread = 2,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = (style ?? const TextStyle()).copyWith(
      fontSize: size,
      color: textColor ?? (emboss ? Colors.black54 : Colors.white),
    );

    return ClayContainer(
      color: color,
      parentColor: parentColor,
      depth: depth,
      spread: spread,
      curveType: emboss ? CurveType.concave : CurveType.convex,
      emboss: emboss,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style: effectiveStyle,
        ),
      ),
    );
  }
} 