// import 'package:flutter/material.dart';
// import 'package:trancend/src/constants/app_colors.dart';
// class Slide {
//   final String title;
//   final String title2;
//   final String subtitle;
//   final String subtitle2;
//   final String image;
//   final Widget widget;
//   final double imageHeight;
//   final double hOffset;
//   final double vOffset;
//   final bool special;
//   Slide({
//     required this.title,
//     required this.title2,
//     required this.widget,
//     required this.subtitle,
//     required this.subtitle2,
//     required this.image,
//     this.imageHeight = 330,
//     this.hOffset = 0,
//     this.vOffset = 0,
//     this.special = false,
//   });
//   // toSlide(
//   //   BuildContext context,
//   //   String folder,
//   //   int count, {
//   //   ColorName colorName = ColorName.Light,
//   //   double height = 420,
//   // }) {
//   //   TextStyle titleStyle = Theme.of(context).textTheme.headlineMedium ?? TextStyle();
//   //   TextStyle subheadStyle = Theme.of(context).textTheme.headlineSmall ?? TextStyle();
//   //   if (colorName != ColorName.Light) {
//   //     titleStyle = titleStyle.apply(
//   //       color: Colors.white,
//   //     );
//   //     subheadStyle = subheadStyle.apply(
//   //       color: Colors.white,
//   //     );
//   //   }
//   //   // String imageUrl =
//   //   //     "./assets/images/onboarding/$folder/${special ? 0 : count}.png";

//   //   String imageUrl = "./assets/images/slider/$folder/$count.png";

//   //   return Container(
//   //     height: height,
//   //     // color: Colors.red,
//   //     child: Center(
//   //       child: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         mainAxisAlignment: MainAxisAlignment.end,
//   //         children: AnimationConfiguration.toStaggeredList(
//   //           duration: Duration(milliseconds: 1200),
//   //           childAnimationBuilder: (widget) => SlideAnimation(
//   //             verticalOffset: vOffset,
//   //             horizontalOffset: hOffset,
//   //             child: FadeInAnimation(
//   //               child: widget,
//   //             ),
//   //           ),
//   //           children: widget != null
//   //               ? [
//   //                   // UIHelper.verticalSpace(0),
//   //                   widget,
//   //                   Text(
//   //                     subtitle ?? "",
//   //                     style: subheadStyle,
//   //                   ),
//   //                 ]
//   //               : [
//   //                   Text(
//   //                     title,
//   //                     textAlign: TextAlign.center,
//   //                     style: titleStyle,
//   //                   ),
//   //                   Text(
//   //                     title2,
//   //                     textAlign: TextAlign.center,
//   //                     style: titleStyle,
//   //                   ),
//   //                   // if (widget != null)
//   //                   Image.asset(
//   //                     imageUrl,
//   //                     height: imageHeight,
//   //                   ),
//   //                   Text(
//   //                     subtitle,
//   //                     textAlign: TextAlign.center,
//   //                     style: subheadStyle,
//   //                   ),
//   //                   Text(
//   //                     subtitle2,
//   //                     textAlign: TextAlign.center,
//   //                     style: subheadStyle,
//   //                   ),
//   //                 ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// class SliderGroup {
//   final List<Slide> slides;
//   final String folder;
//   SliderGroup({required this.slides, required this.folder});

//   toSlides(BuildContext context,
//       {bool isSpecial = false,
//       ColorName colorName = ColorName.Light,
//       double innerHeight = 440}) {
//     int count = 0;
//     // int totalWidgets = slides.where((s)=>s.widget!=null).length;
//     return slides
//         .where((slide) => isSpecial ? true : slide.special == false)
//         .map((slide) {
//       if (slide.widget == null) count = count + 1;
//       return PageViewModel(
//         // bodyWidget: slide.toSlide(context, folder, count, colorName: colorName),
//         titleWidget: Container(height: 0),
//       );
//     }).toList();
//   }
// }
