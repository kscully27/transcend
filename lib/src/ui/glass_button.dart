import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

enum GlassButtonVariant {
  outlined,
  text
}

enum GlassButtonSize {
  xsmall,
  small,
  medium,
  large,
  xlarge
}

enum GlassButtonAlign {
  left,
  center,
  right
}

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets? padding;
  final EdgeInsets margin;
  final double borderRadius;
  final double? width;
  final double? height;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final int maxLines;
  final double minFontSize;
  final TextOverflow overflow;
  final GlassButtonVariant variant;
  final GlassButtonSize size;
  final GlassButtonAlign align;
  final bool wrapText;

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    this.borderWidth = 0.8,
    this.padding,
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 30,
    this.width,
    this.height,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.maxLines = 1,
    this.minFontSize = 12,
    this.overflow = TextOverflow.ellipsis,
    this.variant = GlassButtonVariant.outlined,
    this.size = GlassButtonSize.medium,
    this.align = GlassButtonAlign.left,
    this.wrapText = true,
  });

  double get _fontSize {
    switch (size) {
      case GlassButtonSize.xsmall:
        return 16;
      case GlassButtonSize.small:
        return 24;
      case GlassButtonSize.medium:
        return 32;
      case GlassButtonSize.large:
        return 40;
      case GlassButtonSize.xlarge:
        return 48;
    }
  }

  double get _iconSize {
    switch (size) {
      case GlassButtonSize.xsmall:
        return 20;
      case GlassButtonSize.small:
        return 32;
      case GlassButtonSize.medium:
        return 40;
      case GlassButtonSize.large:
        return 48;
      case GlassButtonSize.xlarge:
        return 56;
    }
  }

  EdgeInsets get _defaultPadding {
    switch (size) {
      case GlassButtonSize.xsmall:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
      case GlassButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 6);
      case GlassButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 8);
      case GlassButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 10);
      case GlassButtonSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 12);
    }
  }

  FontWeight get _fontWeight {
    return size == GlassButtonSize.xsmall 
        ? FontWeight.w500 
        : FontWeight.w200;
  }

  MainAxisAlignment get _mainAxisAlignment {
    switch (align) {
      case GlassButtonAlign.left:
        return MainAxisAlignment.start;
      case GlassButtonAlign.center:
        return MainAxisAlignment.center;
      case GlassButtonAlign.right:
        return MainAxisAlignment.end;
    }
  }

  TextAlign get _textAlign {
    switch (align) {
      case GlassButtonAlign.left:
        return TextAlign.left;
      case GlassButtonAlign.center:
        return TextAlign.center;
      case GlassButtonAlign.right:
        return TextAlign.right;
    }
  }

  double get _iconSpacing {
    switch (size) {
      case GlassButtonSize.xsmall:
        return 6;
      case GlassButtonSize.small:
        return 8;
      case GlassButtonSize.medium:
        return 12;
      case GlassButtonSize.large:
        return 14;
      case GlassButtonSize.xlarge:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: width,
            height: height,
            padding: padding ?? _defaultPadding,
            decoration: BoxDecoration(
              border: variant == GlassButtonVariant.outlined 
                ? Border.all(
                    color: borderColor,
                    width: borderWidth,
                  )
                : null,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: _mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: textColor,
                    size: _iconSize,
                  ),
                  SizedBox(width: _iconSpacing),
                ],
                Flexible(
                  fit: FlexFit.loose,
                  child: AutoSizeText(
                    text,
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: _fontWeight,
                      color: textColor,
                      height: 1.2,
                    ),
                    maxLines: wrapText ? 2 : maxLines,
                    minFontSize: minFontSize,
                    overflow: overflow,
                    textAlign: _textAlign,
                    stepGranularity: 0.5,
                    wrapWords: true,
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