import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trancend/src/ui/glass_icon_button.dart';
import 'package:trancend/src/ui/glass_container.dart';

enum AnimationSpeed {
  slow,
  medium,
  fast,
}

class GlassBottomSheet extends StatelessWidget {
  final Widget content;
  final bool hasCloseButton;
  final double heightPercent;
  final Color? backgroundColor;
  final Color? barrierColor;
  final Color? closeButtonColor;
  final double? blur;
  final double? opacity;
  final Gradient? fade;
  final Border? border;
  final AnimationSpeed animationSpeed;

  const GlassBottomSheet({
    super.key,
    required this.content,
    this.hasCloseButton = true,
    this.heightPercent = 0.8,
    this.backgroundColor,
    this.barrierColor,
    this.closeButtonColor,
    this.blur,
    this.opacity,
    this.fade,
    this.border,
    this.animationSpeed = AnimationSpeed.medium,
  });

  Duration get _animationDuration {
    switch (animationSpeed) {
      case AnimationSpeed.slow:
        return const Duration(milliseconds: 800);
      case AnimationSpeed.medium:
        return const Duration(milliseconds: 500);
      case AnimationSpeed.fast:
        return const Duration(milliseconds: 300);
    }
  }

  Duration get _delayDuration {
    switch (animationSpeed) {
      case AnimationSpeed.slow:
        return const Duration(milliseconds: 500);
      case AnimationSpeed.medium:
        return const Duration(milliseconds: 360);
      case AnimationSpeed.fast:
        return const Duration(milliseconds: 200);
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    bool hasCloseButton = true,
    double heightPercent = 0.8,
    Color? backgroundColor,
    Color? barrierColor,
    Color? closeButtonColor,
    double? blur,
    double? opacity,
    Gradient? fade,
    Border? border,
    AnimationSpeed animationSpeed = AnimationSpeed.medium,
  }) {
    return Future.delayed(
      const Duration(milliseconds: 360),
      () => showModalBottomSheet<T>(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
        isDismissible: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * heightPercent,
        ),
        builder: (context) {
          return AnimatedBuilder(
            animation: ModalRoute.of(context)!.animation!,
            builder: (context, child) {
              final delayedAnimation = CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: const Interval(
                  0.0,
                  1.0,
                  curve: Curves.easeOutBack,
                ),
              );
              
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(delayedAnimation),
                child: FadeTransition(
                  opacity: delayedAnimation,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: GlassBottomSheet(
                      content: content,
                      hasCloseButton: hasCloseButton,
                      heightPercent: heightPercent,
                      backgroundColor: backgroundColor,
                      barrierColor: barrierColor,
                      closeButtonColor: closeButtonColor,
                      blur: blur,
                      opacity: opacity,
                      fade: fade,
                      border: border,
                      animationSpeed: animationSpeed,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: GlassContainer(
        backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.3),
        blur: blur ?? 20.0,
        opacity: opacity ?? 0.3,
        fade: fade,
        border: border ?? Border.all(color: Colors.white12, width: 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.25,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            if (hasCloseButton)
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GlassIconButton(
                        icon: Icons.close,
                        iconColor: closeButtonColor ?? Colors.white70,
                        onPressed: () => Navigator.pop(context),
                        borderWidth: 0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: content,
                    ),
                  ],
                ),
              )
            else
              content,
          ],
        ),
      ),
    );
  }
} 