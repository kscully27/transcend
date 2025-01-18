import 'dart:ui';
import 'package:flutter/material.dart';

enum GlassContainerShape {
  square,
  circle,
  roundedRect,
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets margin;
  final double blur;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Decoration? decoration;
  final Gradient? fade;
  final double opacity;
  final GlassContainerShape shape;
  final bool isFrosted;
  final LinearGradient? linearGradient;
  final RadialGradient? radialGradient;
  final SweepGradient? sweepGradient;
  final AlignmentGeometry? alignment;
  final Color? borderGradientStart;
  final Color? borderGradientEnd;

  const GlassContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white38,
    this.borderRadius,
    this.margin = EdgeInsets.zero,
    this.blur = 20.0,
    this.border,
    this.boxShadow,
    this.width,
    this.height,
    this.padding,
    this.decoration,
    this.fade,
    this.opacity = 0.1,
    this.shape = GlassContainerShape.roundedRect,
    this.isFrosted = true,
    this.linearGradient,
    this.radialGradient,
    this.sweepGradient,
    this.alignment,
    this.borderGradientStart,
    this.borderGradientEnd,
  }) : assert(
          linearGradient == null || radialGradient == null && sweepGradient == null,
          'Cannot provide both linear and radial/sweep gradients',
        );

  @override
  Widget build(BuildContext context) {
    BorderRadius? effectiveBorderRadius = borderRadius;
    if (shape == GlassContainerShape.circle) {
      effectiveBorderRadius = BorderRadius.circular(width != null ? width! / 2 : 1000);
    } else if (shape == GlassContainerShape.square) {
      effectiveBorderRadius = BorderRadius.zero;
    }

    Widget glassChild = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor.withOpacity(opacity),
            borderRadius: effectiveBorderRadius,
            border: border ?? Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: boxShadow,
            gradient: linearGradient ?? radialGradient ?? sweepGradient ?? fade,
          ),
      child: child,
    );

    if (isFrosted) {
      glassChild = ClipRRect(
        borderRadius: effectiveBorderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
          ),
          child: glassChild,
        ),
      );
    }

    if (borderGradientStart != null && borderGradientEnd != null) {
      glassChild = Container(
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [borderGradientStart!, borderGradientEnd!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: glassChild,
        ),
      );
    }

    return Container(
      margin: margin,
      alignment: alignment,
      child: glassChild,
    );
  }
} 