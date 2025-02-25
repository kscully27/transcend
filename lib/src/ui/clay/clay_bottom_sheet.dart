import 'package:flutter/material.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';
import 'package:trancend/src/ui/glass/glass_icon_button.dart';

class ClayBottomSheet extends StatelessWidget {
  final Widget content;
  final bool hasCloseButton;
  final double heightPercent;
  final EdgeInsets contentPadding;

  const ClayBottomSheet({
    super.key,
    required this.content,
    this.hasCloseButton = true,
    this.heightPercent = 0.5,
    this.contentPadding = const EdgeInsets.only(bottom: 20),
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    bool hasCloseButton = true,
    double heightPercent = 0.4,
    EdgeInsets contentPadding = const EdgeInsets.only(bottom: 20),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      builder: (builderContext) {
        final screenHeight = MediaQuery.of(builderContext).size.height;
        final maxHeight = screenHeight * heightPercent;
        
        return Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: SafeArea(
            child: ClayBottomSheet(
              content: content,
              hasCloseButton: hasCloseButton,
              heightPercent: heightPercent,
              contentPadding: contentPadding,
            ),
          ),
        );
      },
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
                  Flexible(
                    child: SizedBox(
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
                            padding: contentPadding,
                            child: SingleChildScrollView(
                              child: content,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: Padding(
                      padding: contentPadding,
                      child: SingleChildScrollView(
                        child: content,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 