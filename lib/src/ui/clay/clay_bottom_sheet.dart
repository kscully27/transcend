import 'package:flutter/material.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';
import 'package:trancend/src/ui/glass/glass_icon_button.dart';

class ClayBottomSheet extends StatelessWidget {
  final Widget content;
  final bool hasCloseButton;
  final double heightPercent;

  const ClayBottomSheet({
    super.key,
    required this.content,
    this.hasCloseButton = true,
    this.heightPercent = 0.5,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    bool hasCloseButton = true,
    double heightPercent = 0.5,
  }) {
    return Future.delayed(
      const Duration(milliseconds: 360),
      () => showModalBottomSheet<T>(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
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
                    child: ClayBottomSheet(
                      content: content,
                      hasCloseButton: hasCloseButton,
                      heightPercent: heightPercent,
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
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: ClayContainer(
          color: Colors.white,
          parentColor: Colors.white,
          borderRadius: 20,
          depth: 50,
          spread: 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
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
          ),
        ),
      ),
    );
  }
} 