import 'dart:ui';
import 'package:flutter/material.dart';

class OriginalGlassContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets margin;
  final double blurX;
  final double blurY;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Decoration? decoration;
  final Gradient? fade;

  const OriginalGlassContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white38,
    this.borderRadius,
    this.margin = EdgeInsets.zero,
    this.blurX = 20.0,
    this.blurY = 20.0,
    this.border,
    this.boxShadow,
    this.width,
    this.height,
    this.padding,
    this.decoration,
    this.fade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      padding: padding,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurX,
            sigmaY: blurY,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              border: border ?? Border.all(
                color: Colors.black26,
                width: 0.5,
              ),
              boxShadow: boxShadow,
              gradient: fade,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
} 