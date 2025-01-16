import 'package:flutter/material.dart';

enum CurveType { none, concave, convex }

class ClayContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color parentColor;
  final double depth;
  final double spread;
  final CurveType curveType;
  final double borderRadius;
  final bool emboss;
  final BorderRadius? customBorderRadius;
  final double? width;
  final double? height;

  const ClayContainer({
    super.key,
    required this.child,
    required this.color,
    required this.parentColor,
    this.depth = 20,
    this.spread = 2,
    this.curveType = CurveType.convex,
    this.borderRadius = 0,
    this.emboss = false,
    this.customBorderRadius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color;
    final highlightColor = Color.lerp(baseColor, Colors.white, 0.1)!;
    final shadowColor = Color.lerp(baseColor, Colors.black, 0.1)!;
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: curveType == CurveType.none
              ? [baseColor, baseColor]
              : curveType == CurveType.concave
                  ? [shadowColor, highlightColor]
                  : [highlightColor, shadowColor],
        ),
        boxShadow: [
          // Highlight
          BoxShadow(
            color: emboss ? shadowColor : highlightColor,
            offset: Offset(-spread, -spread),
            blurRadius: depth,
          ),
          // Shadow
          BoxShadow(
            color: emboss ? highlightColor : shadowColor,
            offset: Offset(spread, spread),
            blurRadius: depth,
          ),
        ],
      ),
      child: child,
    );
  }
} 