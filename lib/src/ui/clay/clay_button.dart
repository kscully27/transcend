import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';

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
    this.borderWidth = 0.0,
    this.padding,
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 30,
    this.width,
    this.height,
    this.spread = 2,
    this.depth = 40.0,
    this.curveType = CurveType.none,
    this.emboss = false,
    this.variant = ClayButtonVariant.outlined,
    this.size = ClayButtonSize.medium,
  });

  double get _fontSize {
    switch (size) {
      case ClayButtonSize.xsmall:
        return 12;
      case ClayButtonSize.small:
        return 14;
      case ClayButtonSize.medium:
        return 16;
      case ClayButtonSize.large:
        return 18;
      case ClayButtonSize.xlarge:
        return 20;
    }
  }

  double get _iconSize {
    switch (size) {
      case ClayButtonSize.xsmall:
        return 14;
      case ClayButtonSize.small:
        return 16;
      case ClayButtonSize.medium:
        return 18;
      case ClayButtonSize.large:
        return 20;
      case ClayButtonSize.xlarge:
        return 24;
    }
  }

  EdgeInsets get _defaultPadding {
    switch (size) {
      case ClayButtonSize.xsmall:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ClayButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ClayButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      case ClayButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ClayButtonSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  FontWeight get _fontWeight {
    return FontWeight.w700;
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

  double get _minWidth {
    switch (size) {
      case ClayButtonSize.xsmall:
        return 80;
      case ClayButtonSize.small:
        return 100;
      case ClayButtonSize.medium:
        return 120;
      case ClayButtonSize.large:
        return 140;
      case ClayButtonSize.xlarge:
        return 160;
    }
  }

  double get _defaultHeight {
    switch (size) {
      case ClayButtonSize.xsmall:
        return 32;
      case ClayButtonSize.small:
        return 40;
      case ClayButtonSize.medium:
        return 48;
      case ClayButtonSize.large:
        return 56;
      case ClayButtonSize.xlarge:
        return 64;
    }
  }

  double get _defaultWidth {
    switch (size) {
      case ClayButtonSize.xsmall:
        return 120;
      case ClayButtonSize.small:
        return 160;
      case ClayButtonSize.medium:
        return 200;
      case ClayButtonSize.large:
        return 240;
      case ClayButtonSize.xlarge:
        return 280;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;
    final effectiveBorderColor = borderColor ?? theme.colorScheme.outline;
    
    return Container(
      margin: margin,
      width: width ?? _defaultWidth,
      height: height ?? _defaultHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: ClayContainer(
            color: color,
            parentColor: parentColor,
            spread: spread,
            depth: depth,
            curveType: curveType ?? CurveType.concave,
            borderRadius: borderRadius,
            emboss: emboss,
            child: Container(
              padding: padding ?? _defaultPadding,
              decoration: variant == ClayButtonVariant.outlined
                  ? BoxDecoration(
                      border: Border.all(
                        color: effectiveBorderColor,
                        width: borderWidth,
                      ),
                      borderRadius: BorderRadius.circular(borderRadius),
                    )
                  : null,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: effectiveTextColor,
                        size: _iconSize,
                      ),
                      SizedBox(width: _iconSpacing),
                    ],
                    AutoSizeText(
                      text,
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: _fontWeight,
                        color: effectiveTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 