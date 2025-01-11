import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

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

enum ClayButtonAlign {
  left,
  center,
  right
}

class ClayButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color textColor;
  final Color color;
  final Color? parentColor;
  final double spread;
  final int depth;
  final CurveType? curveType;
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
  final ClayButtonVariant variant;
  final ClayButtonSize size;
  final ClayButtonAlign align;
  final bool wrapText;
  final bool emboss;

  const ClayButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.parentColor,
    this.icon,
    this.textColor = Colors.black,
    this.spread = 6,
    this.depth = 40,
    this.curveType,
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
    this.variant = ClayButtonVariant.outlined,
    this.size = ClayButtonSize.medium,
    this.align = ClayButtonAlign.left,
    this.wrapText = true,
    this.emboss = true,
  }) : super(key: key);

  double get _fontSize {
    switch (size) {
      case ClayButtonSize.xsmall:
        return 12;
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

  MainAxisAlignment get _mainAxisAlignment {
    switch (align) {
      case ClayButtonAlign.left:
        return MainAxisAlignment.start;
      case ClayButtonAlign.center:
        return MainAxisAlignment.center;
      case ClayButtonAlign.right:
        return MainAxisAlignment.end;
    }
  }

  TextAlign get _textAlign {
    switch (align) {
      case ClayButtonAlign.left:
        return TextAlign.left;
      case ClayButtonAlign.center:
        return TextAlign.center;
      case ClayButtonAlign.right:
        return TextAlign.right;
    }
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
            curveType: curveType,
            borderRadius: borderRadius,
            emboss: emboss,
            child: Container(
              padding: padding ?? _defaultPadding,
              width: width,
              height: height,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 