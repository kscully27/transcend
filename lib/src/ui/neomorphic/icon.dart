// import 'package:appcolors/appcolors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:simple_animations/simple_animations.dart';
// import 'package:supercharged/supercharged.dart';

// import 'enums.dart';

// class NeoIcon extends StatelessWidget {
//   final String appColor;
//   final Color color;
//   final String outerColor;
//   final double opacity;
//   final double size;
//   final IconData icon;
//   final double elevation;
//   final double padding;
//   final double intensity;
//   final double margin;
//   final Duration delay;
//   final Duration duration;
//   final bool disabled;
//   final bool isAnimated;

//   NeoIcon({
//     Key key,
//     this.opacity = 1,
//     this.appColor = "blue",
//     this.elevation = 4,
//     this.color,
//     this.delay,
//     this.isAnimated = true,
//     this.outerColor,
//     this.size = 40,
//     this.padding = 12,
//     this.margin = 4,
//     this.icon,
//     this.intensity = .55,
//     this.duration,
//     this.disabled = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String __appColor = appColor ?? "blue";
//     String __outerColor = outerColor ?? __appColor;
//     final Color _outerColor = AppColors.light(outerColor);
//     final Color _appColor = color != null ? color : AppColors.light(appColor);

//     final _tween = MultiTween<AniProps>()
//       ..add(
//           AniProps.depth, 0.0.tweenTo(elevation), duration ?? 500.milliseconds)
//       ..add(AniProps.color, _outerColor.tweenTo(_outerColor),
//           duration ?? 500.milliseconds)
//       ..add(AniProps.color, _outerColor.tweenTo(_appColor),
//           duration ?? 500.milliseconds);

//     return PlayAnimation<MultiTweenValues<AniProps>>(
//         delay: delay == null ? 0.seconds : delay,
//         duration: _tween.duration,
//         tween: _tween,
//         builder: (context, child, value) {
//           return NeumorphicIcon(
//             icon,
//             size: size,
//             style: NeumorphicStyle(
//               intensity: intensity,
//               depth: !isAnimated ? elevation : value.get(AniProps.depth),
//               color: value.get(AniProps.color),
//               shadowDarkColor: AppColors.shadow(__outerColor),
//               shadowLightColor: AppColors.highlight(__outerColor),
//               shadowLightColorEmboss: AppColors.highlight(__appColor),
//               shadowDarkColorEmboss: AppColors.flat(__appColor),
//             ),
//           );
//         });
//   }
// }
