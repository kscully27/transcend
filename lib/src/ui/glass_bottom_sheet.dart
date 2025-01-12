import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trancend/src/ui/glass_icon_button.dart';

class GlassBottomSheet extends StatelessWidget {
  final Widget content;
  final bool hasCloseButton;
  final double heightPercent;

  const GlassBottomSheet({
    Key? key,
    required this.content,
    this.hasCloseButton = true,
    this.heightPercent = 0.8,
  }) : super(key: key);

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    bool hasCloseButton = true,
    double heightPercent = 0.8,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * heightPercent,
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GlassBottomSheet(
          content: content,
          hasCloseButton: hasCloseButton,
          heightPercent: heightPercent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20.0,
            sigmaY: 20.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: Colors.black26,
                width: 0.5,
              ),
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
                  Container(
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
                          padding: const EdgeInsets.only(top: 48),
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