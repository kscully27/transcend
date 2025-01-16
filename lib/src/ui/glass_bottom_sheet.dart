import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trancend/src/ui/glass_icon_button.dart';
import 'package:trancend/src/ui/glass_container.dart';

class GlassBottomSheet extends StatelessWidget {
  final Widget content;
  final bool hasCloseButton;
  final double heightPercent;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;

  const GlassBottomSheet({
    super.key,
    required this.content,
    this.hasCloseButton = true,
    this.heightPercent = 0.8,
    this.backgroundColor = Colors.white38,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.all(8),
      backgroundColor: backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      boxShadow: boxShadow,
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
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  ),
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
                      iconColor: Colors.black,
                      onPressed: () => Navigator.pop(context),
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
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    bool hasCloseButton = true,
    double heightPercent = 0.8,
    Color backgroundColor = Colors.white38,
    List<BoxShadow>? boxShadow,
  }) {
    return Future.delayed(
      const Duration(milliseconds: 200),
      () => showModalBottomSheet<T>(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: const Color.fromARGB(255, 25, 5, 51).withOpacity(.35),
        isDismissible: true,
        isScrollControlled: true,
        transitionAnimationController: AnimationController(
          duration: const Duration(milliseconds: 1800),
          reverseDuration: const Duration(milliseconds: 1500),
          vsync: Navigator.of(context),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * heightPercent,
        ),
        builder: (context) {
          return AnimatedBuilder(
            animation: ModalRoute.of(context)!.animation!,
            builder: (context, child) {
              final slideAnimation = CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: const Interval(
                  0.0,
                  0.7,
                  curve: Curves.elasticOut,
                ),
                reverseCurve: Curves.easeInQuart,
              );

              final fadeAnimation = CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: const Interval(
                  0.3,
                  1.0,
                  curve: Curves.easeOut,
                ),
                reverseCurve: const Interval(
                  0.0,
                  0.3,
                  curve: Curves.easeIn,
                ),
              );
              
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(slideAnimation),
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: GlassBottomSheet(
                      content: content,
                      hasCloseButton: hasCloseButton,
                      heightPercent: heightPercent,
                      backgroundColor: backgroundColor,
                      boxShadow: boxShadow,
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
} 