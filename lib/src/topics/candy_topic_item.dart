import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:simple_shadow/simple_shadow.dart';

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    required Key key,
    this.blur = 10,
    this.color = Colors.black38,
    this.offset = const Offset(10, 10),
    required Widget child,
  }) : super(key: key, child: child);

  final double blur;
  final Color color;
  final Offset offset;

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
      ..dy = offset.dy;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  late double blur;
  late Color color;
  late double dx;
  late double dy;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final Rect rectOuter = offset & size;
    final Rect rectInner = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width - dx,
      size.height - dy,
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

class CandyTopicItem extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const CandyTopicItem({
    super.key,
    required this.topic,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = AppColors.flat(topic.appColor);
    final highlightColor = Color.lerp(
        baseColor,
        topic.appColor.contains('pink')
            ? const Color(0xFFFFAE45)
            : const Color.fromARGB(255, 219, 106, 88),
        0.9)!;
    final midColor = Color.lerp(baseColor, highlightColor, 0.6)!;
    final shadowColor = const Color(0xFFDF5843);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
                // BoxShadow(
                //   color: shadowColor,
                //   offset: const Offset(-5, 0),
                // ),
                // BoxShadow(
                //   color: shadowColor,
                //   offset: const Offset(5, 0),
                // )
              ],
            ),
            child: ShaderMask(
              blendMode: BlendMode.hardLight,
              shaderCallback: (Rect bounds) {
                return RadialGradient(
                  center: Alignment.center,
                  radius: 150,
                  colors: [
                    highlightColor.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ).createShader(bounds);
              },
              child: InnerShadow(
                key: GlobalKey(),
                blur: 25,
                color: Color.fromARGB(255, 250, 175, 143),
                offset: const Offset(-24, 12),
                child: Container(
                  decoration: BoxDecoration(
                    
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [highlightColor, midColor, shadowColor],
                      stops: const [0.3, 0.6, 1.0],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 20,
                        top: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 60,
                          height: 60,
                          child: SimpleShadow(
                            opacity: .7, // Default: 0.5
                            color: Colors.white, // Default: Black
                            offset: Offset(2, 2), // Default: Offset(2, 2)
                            sigma: 2,
                            child: SvgPicture.network(
                              topic.svg,
                              width: 60,
                              height: 60,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              topic.group,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'TitilliumWeb',
                                fontWeight: FontWeight.w300,
                                color: Colors.white.withOpacity(0.6),
                                letterSpacing: 1,
                                shadows: [
                                  Shadow(
                                    color: shadowColor.withOpacity(0.9),
                                    offset: const Offset(0, 3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              topic.title,
                              style: GoogleFonts.titilliumWeb(
                                fontSize: 32,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.1,
                                shadows: [
                                  Shadow(
                                    color: highlightColor,
                                    offset: const Offset(2, 3),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              // style: TextStyle(
                              //   fontSize: 28,
                              //   fontFamily: 'Nunito',
                              //   fontWeight: FontWeight.w900,
                              //   letterSpacing: -0.5,
                              //   color: Colors.white,
                              //   height: 1.1,
                              //   shadows: [
                              //     Shadow(
                              //       color: shadowColor.withOpacity(0.6),
                              //       offset: const Offset(0, 1),
                              //       blurRadius: 3,
                              //     ),
                              //   ],
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
