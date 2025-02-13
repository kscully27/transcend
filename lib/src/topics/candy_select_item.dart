import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/models/topic.model.dart';

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
  bool get alwaysNeedsCompositing => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    // Create a picture recorder
    final recorder = PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // Calculate the extended bounds to account for shadow blur
    final Rect bounds = offset & size;
    final Rect extended = bounds.inflate(blur);

    // Paint child
    context.paintChild(child!, offset);

    // Create shadow paint
    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);

    // Apply the shadow using a single layer
    context.canvas.saveLayer(extended, shadowPaint);
    context.canvas.translate(dx, dy);
    context.paintChild(child!, offset);
    context.canvas.restore();
  }
}

class CandySelectItem extends StatefulWidget {
  final Topic topic;
  final bool isSelected;
  final VoidCallback onSelectPressed;
  final VoidCallback? onTap;

  const CandySelectItem({
    super.key,
    required this.topic,
    required this.isSelected,
    required this.onSelectPressed,
    this.onTap,
  });

  @override
  State<CandySelectItem> createState() => _CandySelectItemState();
}

class _CandySelectItemState extends State<CandySelectItem> {
  final _innerShadowKey1 = GlobalKey();
  final _innerShadowKey2 = GlobalKey();

  void _handleButtonPressed() {
    widget.onSelectPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = AppColors.flat(widget.topic.appColor).withOpacity(0.5);
    final highlightColor = Color.lerp(
        baseColor.withOpacity(0.1), theme.colorScheme.surfaceTint, 0.9)!;
    final midColor = baseColor.withOpacity(0.2);
    final shadowColor = const Color(0xFFDF5843);

    return GestureDetector(
      onTap: widget.onTap ?? _handleButtonPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            !widget.isSelected
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 4),
                    child: Container(
                      padding: const EdgeInsets.all(80),
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ShaderMask(
                  blendMode: widget.isSelected
                      ? BlendMode.difference
                      : BlendMode.lighten,
                  shaderCallback: (Rect bounds) {
                    return RadialGradient(
                      center: Alignment.center,
                      radius: 10,
                      colors: [
                        highlightColor.withOpacity(0.1),
                        highlightColor.withOpacity(0.05),
                      ],
                      stops: const [.3, 1.0],
                    ).createShader(bounds);
                  },
                  child: InnerShadow(
                    key: _innerShadowKey1,
                    blur: 20,
                    color: shadowColor.withOpacity(0.4),
                    offset: const Offset(0, 35),
                    topShadow: false,
                    leftShadow: false,
                    rightShadow: false,
                    child: InnerShadow(
                      key: _innerShadowKey2,
                      blur: 30,
                      color: theme.colorScheme.surfaceTint.withOpacity(0.1),
                      offset: const Offset(-24, 12),
                      bottomShadow: false,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [widget.isSelected ? shadowColor : highlightColor, widget.isSelected ? shadowColor : midColor, shadowColor],
                            stops: const [0.1, 0.6, 1.0],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 30,
                            right: 30,
                            top: 20,
                            bottom: 20,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                widget.topic.title,
                                style: GoogleFonts.titilliumWeb(
                                  fontSize: 22,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.1,
                                  shadows: [
                                    Shadow(
                                      color: highlightColor.withOpacity(0.5),
                                      offset: const Offset(2, 3),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                widget.isSelected
                                    ? Icons.check_circle
                                    : Icons.add,
                                color: Colors.white,
                                size: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
