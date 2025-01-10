// library neomorphic;

// import 'package:animations/animations.dart';
// import 'package:appcolors/appcolors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:neomorphic/custom_paths.dart';
// import 'package:neomorphic/enums.dart';
// import 'package:simple_animations/simple_animations.dart';
// import 'package:supercharged/supercharged.dart';

// enum ContainerType { Basic, Striped }
// enum ColorType { Flat, Light, Highlight, Dark, Shadow }
// enum GradientType {
//   Basic,
//   Light,
//   Dark,
//   Low_Contrast,
//   High_Contrast,
// }

// class NeoDecoration {
//   final GradientType gradientType;
//   final String appColor;
//   Color _firstColor;
//   Color _secondColor;

//   NeoDecoration(
//       {this.gradientType = GradientType.Basic, this.appColor = "green"}) {
//     switch (gradientType) {
//       case GradientType.Basic:
//         _firstColor = Colors.white.withOpacity(.04);
//         _secondColor = AppColors.light(appColor);
//         break;
//       case GradientType.Dark:
//         _firstColor = AppColors.flat(appColor);
//         _secondColor = AppColors.light(appColor);
//         break;
//       case GradientType.High_Contrast:
//         _firstColor = AppColors.flat(appColor);
//         _secondColor = AppColors.light(appColor);
//         break;
//       case GradientType.Low_Contrast:
//         _firstColor = AppColors.flat(appColor);
//         _secondColor = AppColors.light(appColor);
//         break;
//       case GradientType.Light:
//         _firstColor = AppColors.flat(appColor);
//         _secondColor = AppColors.light(appColor);
//         break;
//     }
//   }
//   BoxDecoration stripe() {
//     return BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment(-0.4, -0.8),
//         stops: [0.0, 0.25, 0.25, .5, .5, .75, .75, 1],
//         colors: [
//           _firstColor,
//           _firstColor,
//           _secondColor,
//           _secondColor,
//           _firstColor,
//           _firstColor,
//           _secondColor,
//           _secondColor,
//         ],
//         tileMode: TileMode.repeated,
//       ),
//     );
//   }
// }

// enum ImagePosition {
//   Left,
//   Right,
// }

// class NeoContainer extends StatefulWidget {
//   final double delay;
//   final Widget child;
//   final double height;
//   final double width;
//   final double padding;
//   final ImagePosition imagePosition;
//   final double roundness;
//   final Function onTap;
//   final String buttonText;
//   final String gradientType;
//   final String floated;
//   final Color color;
//   final Color borderColor;
//   final double borderWidth;
//   final String appColor;
//   final String outerColor;
//   final Color iconColor;
//   final double elevation;
//   final double intensity;
//   final IconData icon;
//   final double fontSize;
//   final String group;
//   final bool isIcon;
//   final String outerGroup;
//   final bool isInner;
//   final bool isGradient;
//   final bool noShadow;
//   final bool expanded;
//   final Curve curve;
//   final Duration duration;
//   final bool isAnimated;
//   final double opacity;
//   final EdgeStyle edgeStyle;
//   final Widget heroWidget;
//   final String imagePath;
//   final double imageWidth;
//   final double imageHeight;
//   final double offsetY;
//   final double offsetX;
//   final Duration animationDelay;
//   final EdgeInsets outerPadding;
//   final EdgeInsets innerPadding;
//   final ContainerType type;

//   const NeoContainer(
//       {Key key,
//       this.delay = 1,
//       this.outerPadding,
//       this.innerPadding,
//       this.type = ContainerType.Basic,
//       this.imagePath,
//       this.imageWidth,
//       this.imageHeight,
//       this.offsetY = 0,
//       this.offsetX = 0,
//       this.animationDelay,
//       this.imagePosition = ImagePosition.Right,
//       this.edgeStyle = EdgeStyle.BothRounded,
//       this.child,
//       this.isAnimated = true,
//       this.duration,
//       this.width,
//       this.height,
//       this.padding = 8,
//       this.roundness = 30,
//       this.buttonText,
//       this.elevation = 4,
//       this.intensity = .35,
//       this.fontSize = 22,
//       this.appColor,
//       this.expanded = false,
//       this.outerColor,
//       this.isIcon = false,
//       this.isInner = false,
//       this.noShadow = false,
//       this.isGradient = false,
//       this.gradientType = "light",
//       this.borderWidth,
//       this.outerGroup,
//       this.color,
//       this.borderColor,
//       this.iconColor,
//       this.icon,
//       this.opacity = 1,
//       this.group = "default",
//       this.floated = "none",
//       this.curve = Curves.easeIn,
//       this.heroWidget,
//       this.onTap})
//       : super(key: key);

//   @override
//   _NeoContainerState createState() => _NeoContainerState();
// }

// class _NeoContainerState extends State<NeoContainer> {
//   @override
//   Widget build(BuildContext context) {
//     String appColor = widget.appColor ?? "blue";
//     String outerColor = widget.outerColor ?? appColor;
//     final double _depth = widget.elevation;
//     final Color _outerColor = AppColors.light(outerColor);
//     final Color _appColor =
//         widget.color != null ? widget.color : AppColors.light(appColor);
//     final double _textOpacity = 1.0;
//     final Duration _animationDelay = widget.animationDelay ?? 500.milliseconds;
//     final Duration _duration = widget.duration ?? 500.milliseconds;

//     final _tween = MultiTween<AniProps>()
//       ..add(AniProps.depth, 0.0.tweenTo(_depth), 300.milliseconds)
//       ..add(AniProps.color, _outerColor.tweenTo(_outerColor), 500.milliseconds)
//       ..add(AniProps.color, _outerColor.tweenTo(_appColor), 200.milliseconds)
//       ..add(AniProps.text_opacity, 0.0.tweenTo(0.0), 400.milliseconds)
//       ..add(
//           AniProps.text_opacity,
//           0.0.tweenTo(
//               _textOpacity < 0 ? 0 : _textOpacity > 1 ? 1 : _textOpacity),
//           400.milliseconds)
//       ..add(
//           AniProps.opacity,
//           0.0.tweenTo(
//               widget.opacity < 0 ? 0 : widget.opacity > 1 ? 1 : widget.opacity),
//           200.milliseconds)
//       ..add(
//           AniProps.offset,
//           Tween(
//               begin: Offset(widget.offsetX, widget.offsetY),
//               end: Offset(widget.offsetX, widget.offsetY)),
//           _animationDelay)
//       ..add(
//           AniProps.offset,
//           Tween(
//               begin: Offset(widget.offsetX, widget.offsetY), end: Offset(0, 0)),
//           _duration)
//       ..add(AniProps.opacity, 0.0.tweenTo(1.0), 200.milliseconds);

//     double _imageHeight = widget.imageHeight ?? widget.height;
//     double _imageWidth = widget.imageWidth ?? null;
//     Widget _container() {
//       return AnimatedContainer(
//         duration: 300.milliseconds,
//         width: widget.width,
//         height: widget.height,
//         decoration: widget.type == ContainerType.Basic
//             ? null
//             : NeoDecoration(appColor: appColor).stripe(),
//         child: widget.imagePath == null
//             ? widget.child
//             : Stack(
//                 children: [
//                   Positioned(
//                     top: 0,
//                     right:
//                         widget.imagePosition == ImagePosition.Right ? 0 : null,
//                     left: widget.imagePosition == ImagePosition.Left ? 0 : null,
//                     child: Image.asset(
//                       widget.imagePath,
//                       height: _imageHeight,
//                       width: _imageWidth,
//                       // width: 240,
//                     ),
//                   ),
//                   widget.child,
//                 ],
//               ),
//       );
//     }

//     Widget _content() {
//       return widget.heroWidget == null
//           ? _container()
//           : OpenContainer(
//               transitionType: ContainerTransitionType.fadeThrough,
//               closedColor: _appColor,
//               openColor: _appColor,
//               transitionDuration: 900.milliseconds,
//               closedShape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(widget.roundness),
//               ),
//               closedBuilder: (BuildContext context, VoidCallback action) {
//                 bool _isVisible = true;
//                 return GestureDetector(
//                   child: !_isVisible ? Container() : _container(),
//                   onTap: () {
//                     _isVisible = false;
//                     action();
//                   },
//                 );
//               },
//               openBuilder: (BuildContext c, VoidCallback action) =>
//                   widget.heroWidget,
//             );
//     }

//     widget.edgeStyle == EdgeStyle.LeftRounded
//         ? RoundLeftRectangle(roundness: widget.roundness)
//         : RoundRightRectangle(roundness: widget.roundness);

//     return PlayAnimation<MultiTweenValues<AniProps>>(
//         delay: (60 * widget.delay).round().milliseconds,
//         duration: _tween.duration,
//         tween: _tween,
//         builder: (context, child, value) {
//           double __textOpacity = value.get(AniProps.text_opacity);
//           double _textOpacity =
//               __textOpacity < 0 ? 0 : __textOpacity > 1 ? 1 : __textOpacity;

//           double __opacity = value.get(AniProps.opacity);
//           double _opacity = __opacity < 0 ? 0 : __opacity > 1 ? 1 : __opacity;

//           Widget _container() {
//             return Transform.translate(
//               offset: value.get(AniProps.offset), // Get animated offset
//               child: Padding(
//                 padding: widget.outerPadding == null
//                     ? const EdgeInsets.all(0)
//                     : widget.outerPadding,
//                 child: Neumorphic(
//                   curve: widget.curve,
//                   padding: widget.innerPadding != null
//                       ? widget.innerPadding
//                       : EdgeInsets.all(widget.padding),
//                   style: NeumorphicStyle(
//                     boxShape: boxShape(
//                         edgeStyle: widget.edgeStyle,
//                         roundness: widget.roundness),
//                     // depth: _depth,
//                     depth:
//                         !widget.isAnimated ? _depth : value.get(AniProps.depth),
//                     intensity: widget.intensity,
//                     color: !widget.isAnimated
//                         ? _appColor
//                         : value.get(AniProps.color).withOpacity(_opacity),
//                     shadowDarkColor: AppColors.shadow(outerColor),
//                     shadowLightColor: AppColors.highlight(outerColor),
//                     shadowLightColorEmboss: AppColors.highlight(appColor),
//                     shadowDarkColorEmboss: AppColors.flat(appColor),
//                     border: NeumorphicBorder(
//                       color: widget.borderColor?.withOpacity(_textOpacity) ??
//                           Colors.transparent,
//                       width: widget.borderWidth ?? 0,
//                     ),
//                   ),
//                   child: Opacity(
//                     opacity: _textOpacity,
//                     child: _content(),
//                   ),
//                 ),
//               ),
//             );
//           }

//           return widget.onTap == null
//               ? _container()
//               : GestureDetector(
//                   onTap: widget.onTap,
//                   child: _container(),
//                 );
//         });
//   }
// }
