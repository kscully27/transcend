import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class CandyButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final Color? color;
  final Color? textColor;
  final bool isSmall;

  const CandyButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.width,
    this.height = 80,
    this.color,
    this.textColor,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.surface.withOpacity(0.2);
    final buttonTextColor = textColor ?? theme.colorScheme.onSurface;
    
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            buttonColor.withOpacity(0.4),
            buttonColor.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: buttonColor.withOpacity(0.05),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 24,
              vertical: isSmall ? 8 : 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: buttonTextColor,
                          size: isSmall ? 18 : 24,
                        ),
                        SizedBox(width: isSmall ? 8 : 12),
                      ],
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: buttonTextColor,
                            fontSize: isSmall ? 14 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Remix.arrow_right_s_line,
                  color: buttonTextColor.withOpacity(0.5),
                  size: isSmall ? 18 : 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 