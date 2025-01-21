import 'package:flutter/material.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';

class ClayBottomSheet2 {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    Color color = const Color(0xFF883912),
    Color parentColor = const Color(0xFFD59074),
    int depth = 15,
    double spread = 2,
    CurveType curveType = CurveType.concave,
    double borderRadius = 30,
    bool emboss = false,
    bool hasCloseButton = true,
    double heightPercent = 0.8,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black26,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * heightPercent,
        ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: parentColor,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: spread),
                child: ClayContainer(
                  color: color,
                  parentColor: parentColor,
                  depth: (emboss ? -depth : depth).toDouble(),
                  spread: spread,
                  curveType: curveType,
                  borderRadius: 0,
                  customBorderRadius: BorderRadius.vertical(
                    top: Radius.circular(borderRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 20),
                        content,
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 