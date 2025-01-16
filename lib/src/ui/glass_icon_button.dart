import 'package:flutter/material.dart';
import 'package:trancend/src/ui/glass_container.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color iconColor;
  final Color backgroundColor;
  final double size;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.white10,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(size / 2),
      margin: const EdgeInsets.all(8),
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
              color: iconColor,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
} 