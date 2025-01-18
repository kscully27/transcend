import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

enum GlassButtonVariant {
  outlined,
  filled,
}

enum GlassButtonSize {
  xsmall,
  small,
  medium,
  large,
  xlarge,
}

enum GlassButtonAlign {
  left,
  center,
  right,
}

enum GlowAmount {
  none,
  light,
  medium,
  heavy,
}

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? iconUrl;
  final Color textColor;
  final Color glassColor;
  final Color? borderColor;
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
  final GlowAmount glowAmount;
  final Color? glowColor;
  final bool hasDivider;
  final double opacity;

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconUrl,
    required this.textColor,
    required this.glassColor,
    this.borderColor,
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
    this.align = GlassButtonAlign.center,
    this.wrapText = true,
    this.glowAmount = GlowAmount.none,
    this.glowColor,
    this.hasDivider = false,
    this.opacity = 0.3,
  });

  double get _fontSize {
    switch (size) {
      case GlassButtonSize.xsmall:
        return 14;
      case GlassButtonSize.small:
        return 16;
      case GlassButtonSize.medium:
        return 18;
      case GlassButtonSize.large:
        return 24;
      case GlassButtonSize.xlarge:
        return 32;
    }
  }

  FontWeight get _fontWeight {
    switch (size) {
      case GlassButtonSize.xsmall:
        return FontWeight.normal;
      case GlassButtonSize.small:
        return FontWeight.normal;
      case GlassButtonSize.medium:
        return FontWeight.w500;
      case GlassButtonSize.large:
        return FontWeight.w600;
      case GlassButtonSize.xlarge:
        return FontWeight.w700;
    }
  }

  EdgeInsets get _defaultPadding {
    switch (size) {
      case GlassButtonSize.xsmall:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case GlassButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case GlassButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      case GlassButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case GlassButtonSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
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
        return 10;
      case GlassButtonSize.large:
        return 12;
      case GlassButtonSize.xlarge:
        return 16;
    }
  }

  double get _glowOpacity {
    switch (glowAmount) {
      case GlowAmount.none:
        return 0;
      case GlowAmount.light:
        return 0.3;
      case GlowAmount.medium:
        return 0.5;
      case GlowAmount.heavy:
        return 1;
    }
  }

  Offset get _glowOffset {
    switch (glowAmount) {
      case GlowAmount.none:
        return Offset.zero;
      case GlowAmount.light:
        return const Offset(0, 1);
      case GlowAmount.medium:
        return const Offset(0, 2);
      case GlowAmount.heavy:
        return const Offset(1, 1);
    }
  }

  double get _glowSigma {
    switch (glowAmount) {
      case GlowAmount.none:
        return 0;
      case GlowAmount.light:
        return 2;
      case GlowAmount.medium:
        return 4;
      case GlowAmount.heavy:
        return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: GlassContainer(
            width: width,
            height: height,
            backgroundColor: glassColor,
            opacity: opacity,
            borderRadius: BorderRadius.circular(borderRadius),
            border: variant == GlassButtonVariant.outlined
                ? Border.all(
                    color: borderColor ?? textColor,
                    width: borderWidth,
                  )
                : null,
            padding: padding ?? _defaultPadding,
            isFrosted: true,
            child: Row(
              mainAxisSize: mainAxisSize,
              mainAxisAlignment: _mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: [
                if (icon != null) ...[
                  if (glowAmount != GlowAmount.none)
                    SimpleShadow(
                      opacity: _glowOpacity,
                      color: glowColor ?? textColor,
                      offset: _glowOffset,
                      sigma: _glowSigma,
                      child: Icon(
                        icon,
                        color: textColor,
                        size: _fontSize * 1.2,
                      ),
                    )
                  else
                    Icon(
                      icon,
                      color: textColor,
                      size: _fontSize * 1.2,
                    ),
                  SizedBox(width: _iconSpacing),
                ],
                Flexible(
                  fit: FlexFit.loose,
                  child: glowAmount != GlowAmount.none
                      ? Container(
                          child: SimpleShadow(
                            opacity: _glowOpacity,
                            color: glowColor ?? textColor,
                            offset: _glowOffset,
                            sigma: _glowSigma,
                            child: _buildText(),
                          ),
                        )
                      : _buildText(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return AutoSizeText(
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
    );
  }
}
