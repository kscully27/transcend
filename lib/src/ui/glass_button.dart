import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum GlassButtonVariant { outlined, text }
enum GlassButtonSize { xsmall, small, medium, large, xlarge }
enum GlassButtonAlign { left, center, right }
enum GlowAmount { none, light, medium, strong, heavy }

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

  double get _iconSize {
    switch (size) {
      case GlassButtonSize.xsmall:
        return 16;
      case GlassButtonSize.small:
        return 20;
      case GlassButtonSize.medium:
        return 24;
      case GlassButtonSize.large:
        return 32;
      case GlassButtonSize.xlarge:
        return 40;
    }
  }

  EdgeInsets get _defaultPadding {
    switch (size) {
      case GlassButtonSize.xsmall:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case GlassButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case GlassButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case GlassButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case GlassButtonSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
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
      case GlowAmount.strong:
        return 0.7;
      case GlowAmount.heavy:
        return 1.0;
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
      case GlowAmount.strong:
        return 6;
      case GlowAmount.heavy:
        return 8;
    }
  }

  Offset get _glowOffset {
    double base = size == GlassButtonSize.xsmall ? 1 : 2;
    double multiplier;
    switch (glowAmount) {
      case GlowAmount.none:
        multiplier = 0;
        break;
      case GlowAmount.light:
        multiplier = 0.5;
        break;
      case GlowAmount.medium:
        multiplier = 1.0;
        break;
      case GlowAmount.strong:
        multiplier = 1.5;
        break;
      case GlowAmount.heavy:
        multiplier = 2.0;
        break;
    }
    return Offset(base * multiplier, base * multiplier);
  }

  FontWeight get _fontWeight {
    return size == GlassButtonSize.xsmall ? FontWeight.w500 : FontWeight.w200;
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
      child: GestureDetector(
        onTap: onPressed,
        child: GlassContainer(
          width: width,
          height: height,
          backgroundColor: glassColor,
          opacity: opacity,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              border: variant == GlassButtonVariant.outlined
                  ? Border.all(
                      color: borderColor ?? textColor,
                      width: borderWidth,
                    )
                  : null,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: padding ?? _defaultPadding,
              child: Row(
                mainAxisSize: mainAxisSize,
                mainAxisAlignment: _mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  if (icon != null) ...[
                    if (glowAmount != GlowAmount.none)
                      Container(
                        child: SimpleShadow(
                          opacity: _glowOpacity,
                          color: glowColor ?? textColor,
                          offset: _glowOffset,
                          sigma: _glowSigma,
                          child: Icon(
                            icon,
                            color: textColor,
                            size: _iconSize,
                          ),
                        ),
                      )
                    else
                      Icon(
                        icon,
                        color: textColor,
                        size: _iconSize,
                      ),
                    if (hasDivider) ...[
                      SizedBox(width: _iconSpacing),
                      Container(
                        width: 1,
                        height: _iconSize * 0.8,
                        color: (borderColor ?? textColor).withOpacity(0.5),
                      ),
                    ],
                    SizedBox(width: _iconSpacing),
                  ] else if (iconUrl != null) ...[
                    if (glowAmount != GlowAmount.none)
                      SizedBox(
                        width: _iconSize,
                        height: _iconSize,
                        child: SimpleShadow(
                          opacity: _glowOpacity,
                          color: glowColor ?? textColor,
                          offset: _glowOffset,
                          sigma: _glowSigma,
                          child: SvgPicture.network(
                            iconUrl!,
                            colorFilter: ColorFilter.mode(
                              textColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      )
                    else
                      SvgPicture.network(
                        iconUrl!,
                        width: _iconSize,
                        height: _iconSize,
                        colorFilter: ColorFilter.mode(
                          textColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    if (hasDivider) ...[
                      SizedBox(width: _iconSpacing),
                      Container(
                        width: 1,
                        height: _iconSize * 0.8,
                        color: (borderColor ?? textColor).withOpacity(0.5),
                      ),
                    ],
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