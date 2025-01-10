// library uihelper;

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:badges/badges.dart';
// import 'package:trancend/src/constants/app_colors.dart';

// /// Contains useful functions to reduce boilerplate code
// class UIHelper {
//   // Colors
//   static const darkText = Color(0xff5D658B);
//   static const lightText = Colors.white;
//   static const secondaryDarkText = Colors.blueGrey;

//   static const double headerHeight = 70;
//   static const double footerHeight = 120;
//   static const double topButtonSize = 34;
//   static double height(BuildContext context) =>
//       MediaQuery.of(context).size.height;
//   static double width(BuildContext context) =>
//       MediaQuery.of(context).size.width;

//   static const double horizontalPadding = 20;
//   static double horizontalArea(BuildContext context) =>
//       width(context) - horizontalPadding * 2;

//   // Vertical spacing constants. Adjust to your liking.
//   static const double _VerticalSpaceSmall = 10.0;
//   static const double _VerticalSpaceMedium = 20.0;
//   static const double _VerticalSpaceLarge = 40.0;

//   // Vertical spacing constants. Adjust to your liking.
//   static const double _HorizontalSpaceSmall = 10.0;
//   static const double _HorizontalSpaceMedium = 20.0;
//   static const double HorizontalSpaceLarge = 60.0;

//   static Widget spacer(
//       {String appColor = "light",
//       double padding = 10,
//       EdgeInsets? insetsPadding,
//       double? width,
//       bool isCenter = true,
//       double height = 2,
//       double? percent,
//       double? opacity,
//       bool disabled = true}) {
//     Widget _spacer() {
//       return Padding(
//         padding: insetsPadding ?? EdgeInsets.all(padding),
//         child: Container(
//           width: width,
//           height: height,
//           color: textColor(appColor, disabled: disabled, opacity: opacity),
//         ),
//       );
//     }

//     return isCenter ? Center(child: _spacer()) : _spacer();
//   }

//   static Widget verticalSpacer(
//       {String appColor = "light",
//       double padding = 10,
//       double width = 2,
//       double height = 50,
//       double? percent,
//       bool disabled = true}) {
//     return Padding(
//       padding: EdgeInsets.all(padding),
//       child: Container(
//         width: width,
//         height: height,
//         color: textColor(appColor, disabled: disabled),
//       ),
//     );
//   }

//   /// Returns a vertical space with height set to [_VerticalSpaceSmall]
//   static Widget verticalSpaceSmall() {
//     return verticalSpace(_VerticalSpaceSmall);
//   }

//   /// Returns a vertical space with height set to [_VerticalSpaceMedium]
//   static Widget verticalSpaceMedium() {
//     return verticalSpace(_VerticalSpaceMedium);
//   }

//   /// Returns a vertical space with height set to [_VerticalSpaceLarge]
//   static Widget verticalSpaceLarge() {
//     return verticalSpace(_VerticalSpaceLarge);
//   }

//   /// Returns a vertical space equal to the [height] supplied
//   static Widget verticalSpace(double height) {
//     return Container(height: height);
//   }

//   /// Returns a vertical space with height set to [_HorizontalSpaceSmall]
//   static Widget horizontalSpaceSmall() {
//     return horizontalSpace(_HorizontalSpaceSmall);
//   }

//   /// Returns a vertical space with height set to [_HorizontalSpaceMedium]
//   static Widget horizontalSpaceMedium() {
//     return horizontalSpace(_HorizontalSpaceMedium);
//   }

//   /// Returns a vertical space with height set to [HorizontalSpaceLarge]
//   static Widget horizontalSpaceLarge() {
//     return horizontalSpace(HorizontalSpaceLarge);
//   }

//   /// Returns a vertical space equal to the [width] supplied
//   static Widget horizontalSpace(double width) {
//     return Container(width: width);
//   }

//   static String invertedButtonColorString(String appColor) =>
//       appColor == "light" || appColor == "white" ? "blue" : "white";
//   static String buttonTextColorString(String appColor) =>
//       appColor == "light" || appColor == "white" ? "white" : appColor;

//   // AutoSizeText Helpers
//   static Color textColor(
//     String appColor, {
//     bool disabled = false,
//     bool soft = false,
//     double? opacity,
//   }) =>
//       (appColor == "light" || appColor == "white" ? darkText : lightText)
//           // ignore: deprecated_member_use
//           .withOpacity(opacity ??
//               (soft
//                   ? .7
//                   : disabled
//                       ? .4
//                       : 1));

//   static Color invertedButtonColor(String appColor) =>
//       appColor == "light" || appColor == "white" ? darkText : lightText;

//   static Color invertedButtonTextColor(String appColor) =>
//       appColor == "light" || appColor == "white" ? lightText : darkText;
//   static String invertedButtonTextColorString(String appColor) =>
//       appColor == "light" || appColor == "white" ? "light" : "dark";

//   static Color highlightColor(String appColor) =>
//       appColor == "light" || appColor == "white"
//           ? secondaryDarkText
//           : AppColors.highlight(appColor);

//   static Color altColor(String appColor) =>
//       appColor == "light" || appColor == "white"
//           ? lightText
//           : AppColors.light(appColor);

//   static Color errorColor(String appColor) =>
//       appColor == "light" || appColor == "white"
//           ? AppColors.dark("red")
//           : lightText;

//   static AutoSizeText title(
//     String text, {
//     double fontSize = 22,
//     String appColor = "blue",
//     bool disabled = false,
//     bool soft = false,
//     int maxLines = 1,
//     TextDecoration decoration = TextDecoration.none,
//     TextAlign textAlign = TextAlign.left,
//     double opacity = 1,
//   }) =>
//       AutoSizeText(text,
//           textAlign: textAlign,
//           maxLines: maxLines,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               fontSize: fontSize,
//               decoration: decoration,
//               color: textColor(
//                 appColor,
//                 disabled: disabled,
//                 soft: soft,
//                 opacity: opacity,
//               )));

//   static AutoSizeText subTitle(
//     String text, {
//     double fontSize = 20,
//     String appColor = "blue",
//     Color? color,
//     bool disabled = false,
//     bool soft = false,
//     int maxLines = 1,
//     TextOverflow? overFlow,
//     TextDecoration decoration = TextDecoration.none,
//     TextAlign textAlign = TextAlign.left,
//     double opacity = .7,
//   }) =>
//       AutoSizeText(text,
//           textAlign: textAlign,
//           maxLines: maxLines,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               fontSize: fontSize,
//               decoration: decoration,
//               color: color ??
//                   textColor(
//                     appColor,
//                     disabled: disabled,
//                     soft: soft,
//                     opacity: opacity,
//                   )));

//   static AutoSizeText buttonText(String text,
//           {String? appColor,
//           int maxLines = 1,
//           double fontSize = 18,
//           TextDecoration decoration = TextDecoration.none,
//           bool disabled = false}) =>
//       AutoSizeText(text,
//           maxLines: maxLines,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               fontSize: fontSize,
//               decoration: decoration,
//               color: textColor(appColor ?? "light", disabled: disabled)));

//   static AutoSizeText badgeText(String text,
//           {String? appColor, int maxLines = 1, double fontSize = 16}) =>
//       AutoSizeText(text,
//           maxLines: maxLines,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               fontSize: fontSize,
//               color: textColor(appColor ?? "light").withOpacity(.7)));

//   static AutoSizeText p(String text,
//           {double fontSize = 15,
//           double opacity = 1,
//           String? appColor,
//           int maxLines = 1,
//           TextAlign textAlign = TextAlign.left,
//           FontWeight fontWeight = FontWeight.normal,
//           TextDecoration decoration = TextDecoration.none,
//           bool disabled = false,
//           FontStyle? fontStyle}) =>
//       AutoSizeText(
//         text,
//         textAlign: textAlign,
//         maxLines: maxLines,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//           fontFamily: 'TitilliumWebLight',
//           fontSize: fontSize,
//           fontWeight: fontWeight,
//           decoration: decoration,
//           fontStyle: fontStyle,
//           color: textColor(appColor ?? "light", disabled: disabled),
//         ),
//       );

//   static AutoSizeText small(String text,
//           {double fontSize = 12,
//           String? appColor,
//           int maxLines = 1,
//           TextAlign textAlign = TextAlign.left}) =>
//       AutoSizeText(text,
//           textAlign: textAlign,
//           maxLines: maxLines,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               fontFamily: 'TitilliumWebLight',
//               fontSize: fontSize,
//               color: textColor(appColor ?? "light")));

//   static AutoSizeText errorText(String text,
//           {String? appColor,
//           int maxLines = 1,
//           TextAlign textAlign = TextAlign.left,
//           double fontSize = 14}) =>
//       AutoSizeText(text,
//           textAlign: textAlign,
//           maxLines: maxLines,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               fontFamily: 'TitilliumWebLight',
//               fontSize: fontSize,
//               color: errorColor(appColor ?? "light")));

//   static Widget titleBadge(String count, String text,
//       {String? appColor, double fontSize = 26}) {
//     return Badge(
//       badgeContent: badgeText(count, appColor: appColor),
//       animationDuration: Duration(milliseconds: 600),
//       badgeColor: altColor(appColor ?? "light"),
//       position: BadgePosition.topEnd(top: -8),
//       animationType: BadgeAnimationType.slide,
//       child: p(
//         text,
//         appColor: appColor,
//         textAlign: TextAlign.center,
//         fontSize: fontSize,
//       ),
//     );
//   }

//   // Button Helpers

//   static Color confirmColor({String? appColor}) =>
//       appColor == "light"
//           ? AppColors.flat("green")
//           : Colors.white;
//   static Color cancelColor({String? appColor}) =>
//       appColor == "light"
//           ? AppColors.flat("red")
//           : Colors.white;


//   static Icon icon(
//     IconData iconData, {
//     String appColor = "blue",
//     double size = 26,
//     bool disabled = false,
//   }) =>
//       Icon(
//         iconData,
//         size: size,
//         color: textColor(appColor).withOpacity(disabled ? .5 : 1),
//       );

//   static Icon closeIcon({
//     String? appColor,
//   }) =>
//       Icon(
//         Icons.close,
//         color: textColor(appColor ?? "light"),
//       );
//   static Icon searchIcon({String? appColor}) => Icon(
//         Icons.search,
//         color: textColor(appColor ?? "light"),
//       );

//   static Icon infoIcon({String? appColor}) => Icon(
//         Icons.info_outline,
//         size: 36,
//         color: textColor(appColor ?? "light"),
//       );
//   static Icon okIcon({String? appColor}) => Icon(
//         Icons.check,
//         size: 36,
//         color: confirmColor(appColor: appColor),
//       );
//   static Icon backIcon({String? appColor}) => Icon(
//         Icons.arrow_back,
//         size: 32,
//         color: textColor(appColor ?? "light"),
//       );
//   static Icon cancelIcon({String? appColor}) => Icon(
//         Icons.close,
//         color: cancelColor(appColor: appColor),
//       );
//   static Icon lockIcon({String? appColor}) => Icon(
//         Icons.lock,
//         color: textColor(appColor ?? "light").withOpacity(.6),
//       );
//   static Widget basicButton(String text,
//       {required Function onPressed,
//       double fontSize = 16,
//       double? opacity,
//       String? appColor,
//       int maxLines = 1,
//       TextAlign textAlign = TextAlign.left,
//       TextDecoration? decoration,
//       FontWeight fontWeight = FontWeight.normal,
//       bool disabled = false,
//       FontStyle? fontStyle}) {
//     return GestureDetector(
//       onTap: () => onPressed(),
//       child: p(text,
//           textAlign: textAlign,
//           maxLines: maxLines,
//           fontSize: fontSize,
//           decoration: decoration ?? TextDecoration.none,
//           fontStyle: fontStyle,
//           appColor: appColor ?? "light",
//           fontWeight: fontWeight),
//     );
//   }

//   static Widget boldButton(
//     String text, {
//     required Function onPressed,
//     double fontSize = 16,
//     double? opacity,
//     String? appColor,
//     int maxLines = 1,
//     TextAlign textAlign = TextAlign.left,
//     TextDecoration? decoration,
//     bool disabled = false,
//   }) {
//     return GestureDetector(
//       onTap: () => onPressed(),
//       child: subTitle(
//         text,
//         textAlign: textAlign,
//         maxLines: maxLines,
//         fontSize: fontSize,
//         decoration: decoration ?? TextDecoration.none,
//         appColor: appColor ?? "light",
//       ),
//     );
//   }

//   static String textColorString(String? appColor,
//           {bool disabled = false, bool soft = false}) =>
//       (appColor == "light" || appColor == "white" ? "dark" : "light");
// }
