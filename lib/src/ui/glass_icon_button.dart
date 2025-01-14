import 'package:flutter/material.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final AlignmentGeometry alignment;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.iconSize = 32,
    this.iconColor = Colors.black,
    required this.onPressed,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      alignment: alignment,
      child: IconButton(
        icon: Icon(icon, color: iconColor),
        iconSize: iconSize,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
} 