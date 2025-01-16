import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    required Key key,
    this.blur = 10,
    this.color = Colors.black38,
    this.offset = const Offset(10, 10),
    this.topShadow = true,
    this.bottomShadow = true,
    this.leftShadow = true,
    this.rightShadow = true,
    required Widget child,
  }) : super(key: key, child: child);

  final double blur;
  final Color color;
  final Offset offset;
  final bool topShadow;
  final bool bottomShadow;
  final bool leftShadow;
  final bool rightShadow;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final _RenderInnerShadow renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blur = blur
      ..dx = offset.dx
      ..dy = offset.dy
      ..topShadow = topShadow
      ..bottomShadow = bottomShadow
      ..leftShadow = leftShadow
      ..rightShadow = rightShadow;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  late double blur;
  late Color color;
  late double dx;
  late double dy;
  late bool topShadow;
  late bool bottomShadow;
  late bool leftShadow;
  late bool rightShadow;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final Rect rectOuter = offset & size;
    final Rect rectInner = Rect.fromLTWH(
      offset.dx + (leftShadow ? dx.abs() : 0),
      offset.dy + (topShadow ? dy.abs() : 0),
      size.width - (leftShadow ? dx.abs() : 0) - (rightShadow ? dx.abs() : 0),
      size.height - (topShadow ? dy.abs() : 0) - (bottomShadow ? dy.abs() : 0),
    );

    final Canvas canvas = context.canvas..saveLayer(rectOuter, Paint());
    context.paintChild(child!, offset);
    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);

    canvas
      ..saveLayer(rectOuter, shadowPaint)
      ..saveLayer(rectInner, Paint())
      ..translate(dx, dy);
    context.paintChild(child!, offset);
    context.canvas
      ..restore()
      ..restore()
      ..restore();
  }
} 