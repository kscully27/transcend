// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:neomorphic/enums.dart';

// NeumorphicBoxShape boxShape(
//     {EdgeStyle edgeStyle = EdgeStyle.BothRounded, double roundness}) {
//   switch (edgeStyle) {
//     case EdgeStyle.LeftRounded:
//       return NeumorphicBoxShape.path(RoundLeftRectangle(roundness: roundness));
//       break;
//     case EdgeStyle.RightRounded:
//       return NeumorphicBoxShape.path(RoundRightRectangle(roundness: roundness));
//       break;
//     case EdgeStyle.BothRounded:
//       return NeumorphicBoxShape.roundRect(
//         BorderRadius.all(
//           Radius.circular(roundness),
//         ),
//       );
//     case EdgeStyle.BottomRounded:
//       return NeumorphicBoxShape.path(
//           RoundBottomRectangle(roundness: roundness));
//       break;
//     case EdgeStyle.TopRounded:
//       return NeumorphicBoxShape.path(RoundTopRectangle(roundness: roundness));
//       break;

//     case EdgeStyle.HalfCircle:
//       return NeumorphicBoxShape.path(NeoHalfCircle());
//       break;
//     default:
//       return NeumorphicBoxShape.roundRect(
//         BorderRadius.all(
//           Radius.circular(roundness),
//         ),
//       );
//   }
// }

// class HalfCircle extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     int roundness = 40;
//     var path = Path();
//     path.lineTo(0.0, size.height - roundness);
//     path.quadraticBezierTo(
//         size.width / 4, size.height, size.width / 2, size.height);
//     path.quadraticBezierTo(size.width - (size.width / 4), size.height,
//         size.width, size.height - roundness);
//     path.lineTo(size.width, 0.0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// class RoundBottomRectangle extends NeumorphicPathProvider {
//   double roundness;
//   RoundBottomRectangle({this.roundness = 20});

//   @override
//   bool get oneGradientPerPath => false;

//   @override
//   Path getPath(Size size) {
//     var path = Path();
//     double smallVal = (size.width < size.height ? size.width : size.height) / 2;
//     double _roundness = this.roundness > smallVal ? smallVal : this.roundness;
//     path.lineTo(0, size.height - _roundness);
//     path.quadraticBezierTo(0, size.height, _roundness, size.height);
//     path.lineTo(size.width - _roundness, size.height);
//     path.quadraticBezierTo(
//         size.width, size.height, size.width, size.height - _roundness);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(NeumorphicPathProvider oldClipper) => false;
// }

// class RoundTopRectangle extends NeumorphicPathProvider {
//   double roundness;
//   RoundTopRectangle({this.roundness = 20});

//   @override
//   bool get oneGradientPerPath => false;

//   @override
//   Path getPath(Size size) {
//     var path = Path();
//     double smallVal = (size.width < size.height ? size.width : size.height) / 2;
//     double _roundness = this.roundness > smallVal ? smallVal : this.roundness;
//     path.moveTo(0, size.height);
//     path.lineTo(0, size.height - (size.height - _roundness));
//     path.quadraticBezierTo(0, 0, _roundness, 0);
//     path.lineTo(size.width - _roundness, 0);
//     path.quadraticBezierTo(size.width, 0, size.width, roundness);
//     path.lineTo(size.width, size.height);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(NeumorphicPathProvider oldClipper) => false;
// }

// class RoundLeftRectangle extends NeumorphicPathProvider {
//   double roundness;
//   RoundLeftRectangle({this.roundness = 20});

//   @override
//   bool get oneGradientPerPath => false;

//   @override
//   Path getPath(Size size) {
//     var path = Path();
//     double smallVal = (size.width < size.height ? size.width : size.height) / 2;
//     double _roundness = this.roundness > smallVal ? smallVal : this.roundness;

//     path.moveTo(size.width, 0);
//     path.lineTo(_roundness, 0);
//     path.quadraticBezierTo(0, 0, 0, _roundness);
//     path.lineTo(0, size.height - _roundness);
//     path.quadraticBezierTo(0, size.height, _roundness, size.height);
//     path.lineTo(size.width, size.height);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(NeumorphicPathProvider oldClipper) => false;
// }

// class RoundRightRectangle extends NeumorphicPathProvider {
//   double roundness;
//   RoundRightRectangle({this.roundness = 20});

//   @override
//   bool get oneGradientPerPath => false;

//   @override
//   Path getPath(Size size) {
//     var path = Path();
//     double smallVal = (size.width < size.height ? size.width : size.height) / 2;
//     double _roundness = this.roundness > smallVal ? smallVal : this.roundness;

//     path.lineTo(size.width - _roundness, 0);
//     path.quadraticBezierTo(size.width, 0, size.width, _roundness);
//     path.lineTo(size.width, size.height - _roundness);
//     path.quadraticBezierTo(
//         size.width, size.height, size.width - _roundness, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(NeumorphicPathProvider oldClipper) => false;
// }

// class NeoHalfCircle extends NeumorphicPathProvider {
//   @override
//   bool get oneGradientPerPath => false;

//   @override
//   Path getPath(Size size) {
//     var path = Path();
//     path.lineTo(0.0, size.height - 40);
//     path.quadraticBezierTo(
//         size.width / 4, size.height, size.width / 2, size.height);
//     path.quadraticBezierTo(size.width - (size.width / 4), size.height,
//         size.width, size.height - 40);
//     path.lineTo(size.width, 0.0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(NeumorphicPathProvider oldClipper) {
//     return true;
//   }
// }
