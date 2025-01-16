import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double blur;
  final double opacity;
  final Gradient? fade;
  final Border? border;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.blur = 20.0,
    this.opacity = 0.3,
    this.fade,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(opacity),
            borderRadius: borderRadius,
            border: border,
            gradient: fade,
          ),
          child: child,
        ),
      ),
    );
  }
} 