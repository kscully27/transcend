import 'package:flutter/material.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onPressed;
  final double? borderWidth;
  final double size;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.iconColor,
    required this.onPressed,
    this.borderWidth = 0.5,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        border: borderWidth == 0 ? null : Border.all(
          color: Colors.white24,
          width: borderWidth!,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
} 