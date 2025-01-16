import 'package:flutter/material.dart';
import 'package:trancend/src/ui/clay_container.dart';

enum ClayButtonVariant {
  outlined,
  text
}

enum ClayButtonSize {
  xsmall,
  small,
  medium,
  large,
  xlarge
}

class ClayButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final Color parentColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsets? padding;
  final EdgeInsets margin;
  final double borderRadius;
  final double? width;
  final double? height;
  final double spread;
  final double depth;
  final CurveType? curveType;
  final bool emboss;
  final ClayButtonVariant variant;
  final ClayButtonSize size;

  const ClayButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    required this.color,
    required this.parentColor,
    this.textColor = Colors.white,
    this.borderColor,
    this.borderWidth = 0.8,
    this.padding,
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 30,
    this.width,
    this.height,
    this.spread = 2,
    this.depth = 40.0,
    this.curveType,
    this.emboss = false,
    this.variant = ClayButtonVariant.outlined,
    this.size = ClayButtonSize.medium,
  });

  double get _fontSize {
    switch (size) {
      case ClayButtonSize.xsmall:
        return 16;
      case ClayButtonSize.small:
        return 24;
      case ClayButtonSize.medium:
        return 32;
      case ClayButtonSize.large:
        return 40;
      case ClayButtonSize.xlarge:
        return 48;
    }
  }

  double get _iconSize {
    switch (size) {
      case ClayButtonSize.xsmall:
        return 20;
      case ClayButtonSize.small:
        return 32;
      case ClayButtonSize.medium:
        return 40;
      case ClayButtonSize.large:
        return 48;
      case ClayButtonSize.xlarge:
        return 56;
    }
  }

  EdgeInsets get _defaultPadding {
    switch (size) {
      case ClayButtonSize.xsmall:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
      case ClayButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 6);
      case ClayButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 8);
      case ClayButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 10);
      case ClayButtonSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 12);
    }
  }

  FontWeight get _fontWeight {
    return size == ClayButtonSize.xsmall 
        ? FontWeight.w500 
        : FontWeight.w200;
  }

  double get _iconSpacing {
    switch (size) {
      case ClayButtonSize.xsmall:
        return 6;
      case ClayButtonSize.small:
        return 8;
      case ClayButtonSize.medium:
        return 12;
      case ClayButtonSize.large:
        return 14;
      case ClayButtonSize.xlarge:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;
    final effectiveBorderColor = borderColor ?? theme.colorScheme.outline;
    
    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: ClayContainer(
            width: width,
            height: height,
            color: color,
            parentColor: parentColor ?? color,
            spread: spread,
            depth: depth,
            curveType: curveType ?? CurveType.concave,
            borderRadius: borderRadius,
            emboss: emboss,
            child: Container(
              padding: padding ?? _defaultPadding,
              width: width,
              height: height,
              alignment: Alignment.center,
              decoration: variant == ClayButtonVariant.outlined
                  ? BoxDecoration(
                      border: Border.all(
                        color: effectiveBorderColor,
                        width: borderWidth,
                      ),
                      borderRadius: BorderRadius.circular(borderRadius),
                    )
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: effectiveTextColor,
                      size: _iconSize,
                    ),
                    SizedBox(width: _iconSpacing),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: _fontWeight,
                      color: effectiveTextColor,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 