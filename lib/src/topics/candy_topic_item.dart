import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:trancend/src/trance/trance_player.dart';
import 'package:trancend/src/ui/glass_bottom_sheet.dart';
import 'package:trancend/src/ui/glass_button.dart';
import 'package:trancend/src/models/session.model.dart' as session;

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

class CandyTopicItem extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const CandyTopicItem({
    super.key,
    required this.topic,
    this.onTap,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = AppColors.flat(topic.appColor).withOpacity(0.5);
    final highlightColor =
        Color.lerp(baseColor.withOpacity(0.1), theme.colorScheme.surfaceTint, 0.9)!;
    // final midColor = Color.lerp(baseColor, highlightColor, 0.6)!;
    final midColor = baseColor.withOpacity(0.2);
    // final shadowColor = theme.colorScheme.shadow.withOpacity(0.8);
    final shadowColor = const Color(0xFFDF5843);

    void _handleButtonPressed() {
      GlassBottomSheet.show(
        context: context,
        heightPercent: 0.6,
        backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.55  ),
        // backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.4),
        barrierColor: const Color.fromARGB(255, 37, 24, 60).withOpacity(0.45),
        closeButtonColor: Colors.white70,
        blur: 10,
        opacity: .5,
        fade: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            highlightColor.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 1.0],
        ),
        border: Border.all(color: Colors.white24, width: 0.5),
        animationSpeed: AnimationSpeed.medium,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    topic.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassButton(
                    text: isFavorite
                        ? "Remove from Favorites"
                        : "Add to Favorites",
                    icon: isFavorite ? Remix.heart_fill : Remix.heart_line,
                    // width: double.infinity,
                    variant: GlassButtonVariant.text,
                    size: GlassButtonSize.small,
                    align: GlassButtonAlign.center,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    glassColor:
                        Theme.of(context).colorScheme.surface.withOpacity(0.1),
                    borderColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
                    onPressed: () {
                      onFavoritePressed();
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    height: 32,
                    thickness: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
                  ),
                  GlassButton(
                    text: "Start Session",
                    height: 80,
                    icon: Remix.play_fill,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    textColor: Theme.of(context).colorScheme.onSurface,
                    glassColor:
                        Theme.of(context).colorScheme.surface.withOpacity(0.1),
                    borderColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet first
                      Future.microtask(() {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    TrancePlayer(
                              topic: topic,
                              tranceMethod: session.TranceMethod.Hypnotherapy,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeOutCubic;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 500),
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _handleButtonPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
              child: Container(
                padding: const EdgeInsets.all(120),
                height: 120,
                // width: double.infinity - 140,
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
            ),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ShaderMask(
                  blendMode: BlendMode.lighten,
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
                    key: GlobalKey(),
                    blur: 20,
                    color: shadowColor.withOpacity(0.4),
                    offset: const Offset(0, 35),
                    topShadow: false,
                    leftShadow: false,
                    rightShadow: false,
                    child: InnerShadow(
                      key: GlobalKey(),
                      blur: 30,
                      // color: theme.colorScheme.surfaceTint.withOpacity(0.3),
                      color: theme.colorScheme.surfaceTint.withOpacity(0.1),
                      offset: const Offset(-24, 12),
                      bottomShadow: false,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [highlightColor, midColor, shadowColor],
                            stops: const [0.1, 0.6, 1.0],
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
                                      BlendMode.srcATop,
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
                                          color: highlightColor.withOpacity(0.5),
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
          ],
        ),
      ),
    );
  }
}
