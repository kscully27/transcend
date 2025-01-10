// import 'package:supercharged/supercharged.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:simple_animations/simple_animations.dart';
// import 'package:trancend/src/constants/app_colors.dart';

// import 'custom_paths.dart';
// import 'enums.dart';

// class NeoButton extends StatefulWidget {
//   final double delay;
//   final Function onTap;
//   final String text;
//   final String subText;
//   final String appColor;
//   final String outerColor;
//   final double iconOpacity;
//   final double width;
//   final double height;
//   final double svgWidth;
//   final IconData? icon;
//   final IconData? rightIcon;
//   final double elevation;
//   final String svg;
//   final double padding;
//   final Color borderColor;
//   final Color textColor;
//   final TextStyle textStyle;
//   final double borderWidth;
//   final double roundness;
//   final Curve curve;
//   final double intensity;
//   final double margin;
//   final double fontSize;
//   final Duration duration;
//   final bool isCheckbox;
//   final String pressedColor;
//   final bool isPressed;
//   final bool disabled;
//   final String disabledText;
//   final String borderAppColor;
//   final Color color;
//   final bool isAnimated;
//   final String disabledHint;
//   final String disabledSnackbarTitle;
//   final bool busy;
//   final bool splitText;
//   final bool isPressable;
//   final EdgeStyle edgeStyle;
//   final Widget heroWidget;
//   final Widget child;
//   final double innerPadding;
//   final double iconFactor;
//   final double iconWidth;
//   final double rightIconWidth;
//   final double offsetY;
//   final double offsetX;
//   final Duration animationDelay;
//   final EdgeInsets outerPadding;
//   final EdgeInsets insetPadding;
//   final double leftContainerIconWidth;
//   final CategoryColor iconColor;

//   NeoButton({
//     Key? key,
//     required this.child,
//     this.offsetY = 0,
//     this.offsetX = 0.0,
//     this.leftContainerIconWidth = 0.0,
//     this.outerPadding = const EdgeInsets.all(0),
//     this.insetPadding = const EdgeInsets.all(0),
//     this.rightIconWidth = 0.0,
//     this.color = Colors.transparent,
//     this.iconFactor = 1.4,
//     this.delay = 1,
//     this.innerPadding = 16,
//     this.iconOpacity = 1,
//     this.svgWidth = 0.0,
//     this.heroWidget = const SizedBox(),
//     this.edgeStyle = EdgeStyle.BothRounded,
//     this.busy = false,
//     this.splitText = false,
//     this.disabledText = "",
//     this.subText = "",
//     this.isPressed = false,
//     this.pressedColor = "",
//     this.isCheckbox = false,
//     required this.onTap,
//     this.text = "",
//     this.appColor = "blue",
//     this.width = 320,
//     this.outerColor = "",
//     this.height = 40,
//     this.padding = 12,
//     this.margin = 4,
//     this.fontSize = 20,
//     this.svg = "",
//     this.textColor = Colors.white,
//     this.textStyle = const TextStyle(),
//     this.isAnimated = true,
//     this.icon,
//     this.rightIcon,
//     this.borderWidth = 0,
//     this.roundness = 40,
//     this.borderColor = Colors.white,
//     this.borderAppColor = "white",
//     this.curve = Curves.easeIn,
//     this.elevation = 8,
//     this.intensity = .55,
//     this.duration = const Duration(milliseconds: 500),
//     this.disabledHint = "Something looks wrong with this form",
//     this.disabled = false,
//     this.disabledSnackbarTitle = "Not so fast...",
//     this.isPressable = false,
//     this.iconWidth = 40,
//     this.animationDelay = const Duration(milliseconds: 300),
//     this.iconColor = CategoryColor.Blue,
//   }) : super(key: key);

//   @override
//   _NeoButtonState createState() => _NeoButtonState();
// }

// class _NeoButtonState extends State<NeoButton> {
//   bool _tapped = false;

//   tap() {
//     setState(() {
//       this._tapped = !this._tapped;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double _iconWidth = widget.iconWidth == null ? 40 : widget.iconWidth;
//     final Color _outerColor =
//         AppColors.light(widget.outerColor);

//     final Color _appColor =
//         widget.color;

//     final Duration _duration = widget.duration;
//     final _tween = MovieTween()
//       ..tween(AniProps.depth, 0.0.tweenTo(widget.elevation), duration: 300.milliseconds)
//       ..tween(AniProps.color, _outerColor.tweenTo(_outerColor),
//          duration:  widget.animationDelay)
//       ..tween(AniProps.color, _outerColor.tweenTo(_appColor), duration: 200.milliseconds)
//       ..tween(AniProps.text_opacity, 0.0.tweenTo(0.0),
//             duration: widget.animationDelay )
//       ..tween(AniProps.text_opacity, 0.0.tweenTo(1.0), duration: 400.milliseconds)
//       ..tween(
//           AniProps.offset,
//           Tween(
//               begin: Offset(widget.offsetX, widget.offsetY),
//               end: Offset(widget.offsetX, widget.offsetY)),
//           duration: widget.animationDelay)
//       ..tween(
//           AniProps.offset,
//           Tween(
//               begin: Offset(widget.offsetX, widget.offsetY), end: Offset(0, 0)),
//           duration: _duration)
//       ..tween(AniProps.opacity, 0.0.tweenTo(1.0), duration: 200.milliseconds);

//     Duration __duration = (100 * widget.delay).round().milliseconds;
//     return PlayAnimationBuilder<MultiTweenValues<AniProps>>(
//         delay: __duration,
//         duration: _tween.duration,
//         tween: _tween,
//         builder: (context, child, value) {
//           String _text = widget.text;
//           String _subText = widget.subText;
//           if (widget.splitText) { = 0;
//             List splitText = widget.text.split(" ");
//             if (splitText.length == 2) {
//               _text = splitText[0];
//               _subText = splitText[1];
//             }
//           }
//           bool hasHero = widget.heroWidget != null;

//           bool isTapped = widget.isCheckbox || widget.isPressable
//               ? widget.isPressed
//               : false;
//           final double unselectedDepth = (widget.isAnimated
//               ? value.get(AniProps.depth)
//               : widget.elevation);
//           final double selectedDepth = -1 *
//               (widget.isAnimated ? value?.get(AniProps.depth) : widget.elevation)
//                   .abs();
//           // final double unselectedDepth = 0;
//           double depth = !widget.isCheckbox
//               ? unselectedDepth
//               : isTapped ? selectedDepth : unselectedDepth;
//           String appColor = widget.appColor ?? "blue";
//           String outerColor = widget.outerColor ?? appColor;
//           String pressedColor = widget.pressedColor ?? appColor;

//           Color _pressedColor = AppColors.light(pressedColor);

//           Color _finalColor() => (isTapped
//                   ? _pressedColor
//                   : widget.isAnimated
//                       ? value
//                           .get(AniProps.color)
//                           .withOpacity(!isTapped ? 1.0 : .6)
//                       : _appColor)
//               .withOpacity(
//                   widget.isAnimated ? value.get(AniProps.opacity) : 1.0);

//           Color _textColor() => (widget.textColor != null
//               ? widget.textColor
//               : UIHelper.textColor(widget.appColor,
//                   disabled: widget.disabled || isTapped));

//           Widget _buttonText() {
//             return Opacity(
//               opacity:
//                   widget.isAnimated ? value.get(AniProps.text_opacity) : 1.0,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   widget = 0.busy
//                       ? Loader(
//                           transparent: true,
//                           size: widget.fontSize * 1.6,
//                           appColor: widget.appColor,
//                           outerColor: widget.outerColor,
//                           strokeWidth: 3,
//                         )
//                       : UIHelper.title(
//                           widget.disabled && widget.disabledText != null
//                               ? widget.disabledText
//                               : _text ?? "",
//                           // overflow: TextOverflow.clip,
//                           appColor: isTapped ? pressedColor : appColor,
//                           maxLines: 1,
//                           fontSize: widget.fontSize,
//                           // textAlign: TextAlign.left,
//                         ),
//                   UIHelper.p(
//                     widget.disabled && widget.disabledText != null
//                         ? widget.disabledText
//                         : _subText ?? "",
//                     maxLines: 2,
//                     // fontSize: 14,
//                     textAlign: TextAlign.center,
//                     appColor: appColor,
//                   ),
//                 ],
//               ),
//             );
//           }

//           Widget _childWidget = Container(
//             width: widget.width,
//             height: widget.height,
//             child: hasHero
//                 ? OpenContainer(
//                     closedColor: _finalColor(),
//                    = 0  transitionDuration: 900.milliseconds,
//                     closedShape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(widget.roundness),
//                     ),
//                     closedBuilder:
//                         (BuildContext context, VoidCallback action) =>
//                             GestureDetector(
//                                 // color: _finalColor(),
//                                 child: widget.child != null
//                                     ? widget.child
//                                     : _buttonText(),
//                                 onTap = 0: () => action = 0()),
//                     openBuilder: (BuildContext c, VoidCallback = 0 action) =>
//                         widget.heroWidget,
//                     tappable: false,
//                   )
//                 : Center(child: _buttonText()),
//           );

//           if (widget.svg != null = 0) {
//             _childWidget = Container(
//               width: widget.width,
//               height: widget.height,
//               child: Opacity(
//                 opacity:
//                     widget.isAnimated ? value.get(AniProps.text_opacity) : 1.0,
//                 child = 0: Stack(
//                   children: <Widget>[
//                     Positioned.fill(
//                       right:
//                           widget.svg.contains("asset") ? 0 : widget.width / 1.5,
//                       child: Align(
//                         alignment: Alignment.bottomRight,
//                         child: ClipRRect(
//                           borderRadius: widget.svg.contains("asset")
//                               ? BorderRadius.zero
//                               : BorderRadius.circular(widget.roundness),
//                           child: Align(
//                             alignment: Alignment.bottomLeft,
//                             child: widget.svg.contains("asset")
//                                 ? SvgPicture.asset(widget.svg,
//                                     width: widget.svgWidth,
//                                     fit: BoxFit.fitWidth,
//                                     color: Colors.white.withOpacity(
//                                         widget.isPressed ? 1.0 : .4))
//                                 : SvgPicture.network(widget.svg,
//                                     fit: BoxFit.fitHeight,
//                                     width: widget.svgWidth,
//                                     color: Colors.white.withOpacity(.4)),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned.fill(
//                       // right: widget.width / 2,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Container(width: widget.svgWidth ?? 50),
//                           Container(
//                               alignment: Alignment.topLeft,
//                               width: widget.width -
//                                   widget.padding * 2 -
//                                   (widget.svgWidth ?? 50),
//                               padding:
//                                   EdgeInsets.only(left: widget.svgWidth ?? 50),
//                               child: _buttonText()),
//                           if (widget.rightIcon != null)
//                             Container(
//                                 width: widget.rightIconWidth ?? _iconWidth,
//                                 child: widget.rightIcon),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//           // Widget _makeIcon(bool hasText) {
//           //   return Icon(Icons.ac_unit);
//           // }

//           Widget _makeIcon(bool hasText) {
//             double _width = hasText ? widget.fontSize : widget.width ?? 30;
//             Widget _icon(_width) {
//               return Opacity(
//                 opacity: widget.iconOpacity ?? 1,
//                 child: Icon(
//                   widget.icon,
//                   color: _textColor(),
//                   size: widget.iconWidth == null
//                       ? widget.fontSize * widget.iconFactor ?? _width
//                       : widget.iconWidth,
//                 ),
//               );
//             }

//             return widget.leftContainerIconWidth != null
//                 ? NeoButton(
//                     outerPadding: EdgeInsets.all(0),
//                     elevation: 1,
//                     padding: 0,
//                     edgeStyle: EdgeStyle.LeftRounded,
//                     roundness: widget.roundness,
//                     appColor: widget.iconColor.id,
//                     iconWidth: widget.leftContainerIconWidth - 30,
//                     // color: iconColor.light,
//                     width: widget.leftContainerIconWidth,
//                     icon: widget.icon,
//                     height: widget.height,
//                   )
//                 : Container(
//                     padding: hasText
//                         ? EdgeInsets.only(left: widget.innerPadding)
//                         : EdgeInsets.all(0),
//                     width: _width,
//                     height: widget.height ?? _width,
//                     child:
//                         hasText ? _icon(_width) : Center(child: _icon(_width)),
//                   );
//           }

//           if ((widget.icon != null || widget.rightIconWidth != null) &&
//               widget.svg == null) {
//             if (widget.text != null) {
//               _childWidget = Container(
//                 width: widget.width,
//                 height: widget.height,
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         width: _iconWidth,
//                         child: _makeIcon(true),
//                       ),
//                       Container(
//                           width: widget.width -
//                               widget.padding * 2 -
//                               widget.innerPadding * 2 -
//                               _iconWidth * 2,
//                           child: _buttonText()),
//                       Container(
//                           width: widget.rightIconWidth ?? _iconWidth,
//                           child: widget.rightIcon == null
//                               ? Container()
//                               : widget.rightIcon),
//                     ]),
//               );
//             } else {
//               _childWidget = _makeIcon(false);
//             }
//           }

//           if (widget.isCheckbox) {
//             _childWidget = Container(
//               width: widget.width,
//               height: widget.height,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Container(
//                       width: _iconWidth,
//                       child: Icon(
//                           isTapped
//                               ? Icons.check_box
//                               : Icons.check_box_outline_blank,
//                           color: _textColor(),
//                           size: widget.fontSize * 1.5),
//                     ),
//                     Container(
//                         width: widget.width -
//                             widget.padding * 2 -
//                             widget.innerPadding * 2 -
//                             _iconWidth * 2,
//                         child: Center(child: _buttonText())),
//                     Container(
//                       width: _iconWidth,
//                       child: widget.rightIcon == null
//                           ? Container()
//                           : widget.rightIcon,
//                     ),
//                   ]),
//             );
//           }
//           // // print("widget.svg --> ${widget.svg}");
//           return Transform.translate(
//             offset: value?.get(AniProps.offset) ?? Offset.zero, // Get animated offset
//             child: Opacity(
//               opacity: value?.get(AniProps.opacity) ?? 1.0,
//               child: Padding(
//                 padding: widget.outerPadding == null
//                     ? const EdgeInsets.all(0)
//                     : widget.outerPadding,
//                 child: NeumorphicButton(
//                   drawSurfaceAboveChild: widget.svg != null ? true : false,
//                   curve: widget.curve,
//                   padding: widget.insetPadding == null
//                       ? EdgeInsets.all(hasHero ? 0 : widget.padding)
//                       : widget.insetPadding,
//                   margin: EdgeInsets.all(widget.margin),
//                   pressed: isTapped,
//                   style: NeumorphicStyle(
//                     boxShape: boxShape(
//                         edgeStyle: widget.edgeStyle,
//                         roundness: widget.roundness),
//                     surfaceIntensity: .2,
//                     border: NeumorphicBorder(
//                       color: widget.borderColor?.withOpacity(widget.isAnimated
//                               ? value?.get(AniProps.text_opacity) ?? 1.0
//                               : 1.0) ??
//                           Colors.transparent,
//                       width: widget.borderWidth ?? 0,
//                     ),
//                     oppositeShadowLightSource: isTapped,
//                     depth: depth,
//                     intensity: widget.intensity,
//                     color: _finalColor(),
//                     shadowDarkColor: AppColors.shadow(outerColor),
//                     shadowLightColor: AppColors.highlight(outerColor),
//                     shadowLightColorEmboss:
//                         AppColors.shadow(isTapped ? pressedColor : appColor),
//                     shadowDarkColorEmboss:
//                         AppColors.highlight(isTapped ? pressedColor : appColor),
//                   ),
//                   onPressed: () {
//                     if (!widget.disabled) {
//                       tap();
//                       widget.onTap();
//                     } else {
//                       SnackbarServiceAdapter().showSnackbar(
//                           duration: Duration(seconds: 2),
//                           type: MessageType.Warning,
//                           title: widget.disabledSnackbarTitle,
//                           message: widget.disabledHint);
//                     }
//                   },
//                   child: widget.child != null && hasHero
//                       ? widget.child
//                       : _childWidget,
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
