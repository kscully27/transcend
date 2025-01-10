import 'package:flutter/material.dart';
import 'package:trancend/src/constants/app_colors.dart';

class BaseContainer extends StatelessWidget {
  final double padding;
  final Widget child;
  final String group;
  final String appColor;
  final double width;
  final double height;
  final String gradientType;
  BaseContainer(
      { Key? key,
      this.gradientType = 'flat',
      this.width = double.infinity,
      this.height = double.infinity,
      required this.child,
      this.group = "default",
      this.padding = 0,
      this.appColor = 'light'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Gradient gradient;
    if (appColor.isNotEmpty) {
      gradient = AppColors.gradient(appColor);
    } else {
      gradient = AppColors.groupGradient(group);
    }
    switch (gradientType) {
      case 'big':
        gradient = AppColors.bigGradient(appColor);
        break;
      case 'dark':
        gradient = AppColors.darkGradient(appColor);
        break;
      case 'light':
        gradient = AppColors.lightGradient(appColor);
        break;
      default:
        gradient = AppColors.gradient(appColor);
    }
    final _height =
        height == double.infinity ? MediaQuery.of(context).size.height : height;
    // return NeumorphicBackground(child: child);
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: width,
        height: _height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: child);
  }
}
