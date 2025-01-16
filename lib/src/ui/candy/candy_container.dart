import 'package:flutter/material.dart';
import 'package:trancend/src/ui/candy/inner_shadow.dart';

class CandyContainer extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Color shadowColor;
  final double height;
  final double? width;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final double topInnerShadowBlur;
  final double bottomInnerShadowBlur;
  final Color topInnerShadowColor;
  final Color bottomInnerShadowColor;
  final Offset topInnerShadowOffset;
  final Offset bottomInnerShadowOffset;
  final BlendMode shaderBlendMode;
  final double shaderRadius;
  final double shaderOpacity;

  const CandyContainer({
    super.key,
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    required this.shadowColor,
    this.height = 120,
    this.width,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
    this.boxShadow,
    this.gradient,
    this.topInnerShadowBlur = 30,
    this.bottomInnerShadowBlur = 20,
    this.topInnerShadowColor = const Color.fromARGB(253, 250, 175, 143),
    this.bottomInnerShadowColor = const Color(0xFFDF5843),
    this.topInnerShadowOffset = const Offset(-24, 12),
    this.bottomInnerShadowOffset = const Offset(0, 35),
    this.shaderBlendMode = BlendMode.hardLight,
    this.shaderRadius = 40,
    this.shaderOpacity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    final midColor = Color.lerp(baseColor, highlightColor, 0.6)!;

    return Padding(
      padding: margin,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: boxShadow ?? [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: height,
            width: width ?? double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: ShaderMask(
                blendMode: shaderBlendMode,
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.center,
                    radius: shaderRadius,
                    colors: [
                      highlightColor.withOpacity(shaderOpacity),
                      highlightColor.withOpacity(0.1),
                    ],
                    stops: const [1.0, 1.0],
                  ).createShader(bounds);
                },
                child: InnerShadow(
                  key: GlobalKey(),
                  blur: bottomInnerShadowBlur,
                  color: bottomInnerShadowColor.withOpacity(0.5),
                  offset: bottomInnerShadowOffset,
                  topShadow: false,
                  leftShadow: false,
                  rightShadow: false,
                  child: InnerShadow(
                    key: GlobalKey(),
                    blur: topInnerShadowBlur,
                    color: topInnerShadowColor,
                    offset: topInnerShadowOffset,
                    bottomShadow: false,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        gradient: gradient ?? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [highlightColor, midColor, shadowColor],
                          stops: const [0.3, 0.6, 1.0],
                        ),
                      ),
                      padding: padding,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 