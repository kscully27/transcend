// import 'package:appcolors/appcolors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:neomorphic/enums.dart';
// import 'package:simple_animations/simple_animations.dart';
// import 'package:supercharged/supercharged.dart';

// typedef void NeumorphicRadioListener<T>(T value);

// class NeoRadio<T> extends StatefulWidget {
//   final double width;
//   final double height;
//   final T value;
//   final T groupValue;
//   final double padding;
//   final double roundness;
//   final String text;
//   final String appColor;
//   final String pressedColor;
//   final String outerColor;
//   final bool isCheckBox;
//   final Color textColor;
//   final Curve curve;
//   final double intensity;
//   final double margin;
//   final double elevation;
//   final Duration duration;
//   final bool isEnabled;
//   final bool disableDepth;
//   final double selectedDepth;
//   final double unselectedDepth;
//   final double fontSize;
//   final NeumorphicRadioListener<T> onChanged;
//   final T allValue;

//   NeoRadio({
//     Key key,
//     this.allValue,
//     this.text,
//     this.value,
//     this.fontSize = 22,
//     this.isEnabled = true,
//     this.elevation = 10,
//     this.appColor,
//     this.outerColor,
//     this.pressedColor,
//     this.isCheckBox = false,
//     this.groupValue,
//     this.disableDepth,
//     this.selectedDepth,
//     this.unselectedDepth,
//     this.width,
//     this.height,
//     this.padding = 4,
//     this.margin = 2,
//     this.textColor,
//     this.roundness = 40,
//     this.curve = Curves.easeIn,
//     this.intensity = .55,
//     this.duration,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   _NeoButtonState createState() => _NeoButtonState();
// }

// class _NeoButtonState extends State<NeoRadio>
//     with SingleTickerProviderStateMixin {
//   void _onClick() {
//     if (widget.onChanged != null) {
//       if (widget.value == widget.groupValue) {
//         //unselect
//         widget.onChanged(widget.allValue ?? null);
//       } else {
//         widget.onChanged(widget.value);
//       }
//     }
//   }

//   bool get isSelected =>
//       widget.value != null && widget.value == widget.groupValue;

//   @override
//   Widget build(BuildContext context) {
//     final NeumorphicThemeData theme = NeumorphicTheme.currentTheme(context);

//     final _tween = MultiTween<AniProps>()
//       ..add(AniProps.depth, 0.0.tweenTo(0.0), 700.milliseconds)
//       ..add(AniProps.depth, 0.0.tweenTo(widget.elevation), 700.milliseconds);
//     double animatedLabelOpacity = 1.0;
//     return PlayAnimation<MultiTweenValues<AniProps>>(
//         duration: _tween.duration,
//         tween: _tween,
//         builder: (context, child, value) {
//           final double selectedDepth =
//               -1 * (widget.selectedDepth ?? theme.depth).abs();
//           final double unselectedDepth = (theme.depth ?? theme.depth).abs();

//           double depth = isSelected ? selectedDepth : unselectedDepth;
//           if (!widget.isEnabled) {
//             depth = 0;
//           }

//           String appColor = widget.appColor ?? "blue";
//           String outerColor = widget.outerColor ?? appColor;
//           String pressedColor = widget.pressedColor ?? appColor;

//           Color _textColor() => (widget.appColor == 'light'
//                   ? Theme.of(context).primaryColorDark
//                   : widget.textColor == null
//                       ? (widget.appColor != "light" &&
//                               widget.appColor != "white"
//                           ? AppColors.highlight(widget.appColor)
//                           : NeumorphicTheme.defaultTextColor(context))
//                       : widget.textColor)
//               .withOpacity(animatedLabelOpacity);

//           Widget _buttonText() {
//             return Text(
//               widget.text ?? "",
//               overflow: TextOverflow.clip,
//               maxLines: 1,
//               softWrap: false,
//               style: TextStyle(
//                 fontSize: widget.fontSize,
//                 color: _textColor(),
//               ),
//             );
//           }

//           Widget _childWidget() => Container(
//                 width: widget.width,
//                 height: widget.height,
//                 child: _buttonText(),
//               );

//           double animatedColorOpacity = 1.0;

//           return NeumorphicButton(
//             onPressed: _onClick,
//             curve: widget.curve,
//             child: _childWidget(),
//             padding: EdgeInsets.all(widget.padding),
//             pressed: isSelected,
//             minDistance: selectedDepth,
//             style: NeumorphicStyle(
//               boxShape: NeumorphicBoxShape.roundRect(
//                   BorderRadius.circular(widget.roundness)),
//               color: AppColors.light(isSelected ? pressedColor : appColor)
//                   .withOpacity(animatedColorOpacity),
//               shadowDarkColor: AppColors.shadow(outerColor),
//               shadowLightColor: AppColors.highlight(outerColor),
//               shadowLightColorEmboss:
//                   AppColors.shadow(isSelected ? pressedColor : appColor)
//                       .withOpacity(animatedColorOpacity),
//               shadowDarkColorEmboss:
//                   AppColors.highlight(isSelected ? pressedColor : appColor)
//                       .withOpacity(animatedColorOpacity),
//               disableDepth: widget.disableDepth,
//               intensity: widget.intensity,
//               depth: depth,
//               shape: NeumorphicShape.flat,
//             ),
//           );
//         });
//   }
// }
