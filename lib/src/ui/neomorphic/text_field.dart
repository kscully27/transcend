// import 'package:appcolors/appcolors.dart';
// import 'package:uihelper/uihelper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// import 'package:simple_animations/simple_animations.dart';
// import 'package:supercharged/supercharged.dart';

// import 'container.dart';
// import 'enums.dart';
// import 'icon.dart';

// class NeoTextField extends StatefulWidget {
//   final String label;
//   final String appColor;
//   final int limitCharacters;
//   final String outerColor;
//   final int maxLength;
//   final ValueChanged<String> onSubmitted;
//   final String hint;
//   final String value;
//   final double roundness;
//   final List<TextInputFormatter> formatters;
//   final double padding;
//   final double margin;
//   final double elevation;
//   final double intensity;
//   final Duration duration;
//   final double height;
//   final int maxLines;
//   final double width;
//   final IconData icon;
//   final double fontSize;
//   final ValueChanged<String> onChanged;
//   final TextEditingController controller;
//   final TextInputType textInputType;
//   final bool isAnimated;
//   final TextInputAction textInputAction;
//   final String additionalNote;
//   final String errorText;
//   final bool isValid;
//   final bool isDirty;
//   final bool isPassword;
//   final bool canHaveErrorText;
//   final bool autoFocus;
//   final TextAlign textAlign;
//   final EdgeInsets paddingEdgeInsets;
//   final EdgeInsets outerPadding;

//   NeoTextField({
//     this.additionalNote,
//     this.maxLength,
//     this.onChanged,
//     this.limitCharacters,
//     this.onSubmitted,
//     this.maxLines = 1,
//     this.formatters,
//     this.textAlign = TextAlign.left,
//     this.textInputAction = TextInputAction.next,
//     this.textInputType = TextInputType.text,
//     this.canHaveErrorText = false,
//     this.isPassword = false,
//     this.isValid,
//     this.isAnimated = false,
//     this.isDirty = false,
//     this.errorText,
//     this.autoFocus = false,
//     this.label,
//     this.hint = "",
//     this.icon,
//     this.height = 70,
//     this.elevation = -2,
//     this.intensity = .8,
//     this.width,
//     this.value,
//     this.padding = 0,
//     this.paddingEdgeInsets = const EdgeInsets.all(20),
//     this.outerPadding,
//     this.margin = 10,
//     this.roundness = 40,
//     this.fontSize = 18,
//     this.appColor = "blue",
//     this.duration,
//     this.outerColor,
//     this.controller,
//   });

//   @override
//   _NeoTextFieldState createState() => _NeoTextFieldState();
// }

// class _NeoTextFieldState extends State<NeoTextField> {
//   TextEditingController _controller;
//   static bool _showPassword = false;
//   static bool _isDirty = false;
//   FocusNode myFocusNode;

// // List<TextInputFormatter> _formatters;
//   @override
//   void initState() {
//     // _formatters = widget.formatters ?? [];
//     // if(widget.maxLength!=null){
//     //   _formatters.push
//     // }
//     _controller = TextEditingController();
//     _controller.addListener(() {
//       print("CHANGED TEXT");
//     });
//     myFocusNode = FocusNode();
//     myFocusNode.addListener(() {
//       if (!myFocusNode.hasFocus) {
//         setState(() {
//           _isDirty = true;
//         });
//       }
//     });
//     _isDirty = false;
//     _controller =
//         widget.controller ?? TextEditingController(text: widget.value);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     myFocusNode.dispose();
//     _controller?.clear();
//     _controller?.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _tween = MultiTween<AniProps>()
//       ..add(AniProps.depth, 0.0.tweenTo(0.0), 10.milliseconds)
//       ..add(AniProps.depth, 0.0.tweenTo(widget.elevation), 300.milliseconds,
//           Curves.easeIn)
//       ..add(AniProps.opacity, 0.0.tweenTo(0.0), 300.milliseconds)
//       ..add(AniProps.opacity, 0.0.tweenTo(1.0), 500.milliseconds)
//       ..add(AniProps.intensity, 0.0.tweenTo(0.0), 300.milliseconds)
//       ..add(AniProps.intensity, 0.0.tweenTo(1.0), 500.milliseconds)
//       ..add(AniProps.text_opacity, 0.0.tweenTo(0.0), 500.milliseconds)
//       ..add(AniProps.text_opacity, 0.0.tweenTo(1.0), 600.milliseconds);
//     bool isAnimated = widget.isAnimated ?? false;

//     return PlayAnimation<MultiTweenValues<AniProps>>(
//         duration: isAnimated ? _tween.duration : Duration(milliseconds: 0),
//         tween: _tween,
//         builder: (context, child, value) {
//           String appColor = widget.appColor ?? "blue";
//           String outerColor = widget.outerColor ?? appColor;
//           Widget _showPasswordButton() {
//             return Opacity(
//               opacity: value.get(AniProps.text_opacity),
//               child: Container(
//                 height: 20,
//                 child: FlatButton(
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   child: NeoIcon(
//                       size: 20,
//                       color: UIHelper.invertedButtonColor(appColor),
//                       outerColor: appColor,
//                       icon: _showPassword
//                           ? Icons.visibility
//                           : Icons.visibility_off),

//                   //  UIHelper.small(
//                   //     _showPassword ? "Hide password" : "Show Password",
//                   //     textAlign: TextAlign.right,
//                   //     appColor: appColor),
//                   onPressed: () => setState(() {
//                     _showPassword = !_showPassword;
//                   }),
//                 ),
//               ),
//             );
//           }

//           bool _isValidator = widget.isValid != null && _isDirty == true;

//           return Container(
//             padding: widget.outerPadding,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 if (widget.label != null)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       // if (_isValidator)
//                       //   widget.isValid == true
//                       //       ? Icon(Icons.check, color: Colors.greenAccent)
//                       //       : Icon(Icons.close, color: Colors.redAccent),
//                       GestureDetector(
//                         // Hack to make sure the text editing widget is dismissable
//                         onTap: () {
//                           FocusScopeNode currentFocus = FocusScope.of(context);
//                           if (!currentFocus.hasPrimaryFocus) {
//                             if (_controller != null) _controller.clear();
//                             currentFocus.unfocus();
//                           }
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.only(left: _isValidator ? 4 : 30),
//                           child: Text(
//                             widget.label,
//                             style: TextStyle(
//                               fontSize: widget.fontSize,
//                               color: UIHelper.highlightColor(appColor)
//                                   .withOpacity(
//                                       value.get(AniProps.text_opacity)),
//                             ),
//                           ),
//                         ),
//                       ),
//                       widget.isPassword
//                           ? _showPasswordButton()
//                           : Container(width: 10),
//                     ],
//                   ),
//                 Stack(
//                   children: [
//                     Container(
//                       width: widget.width,
//                       height: widget.height,
//                       decoration: BoxDecoration(
//                           border: Border.all(
//                             width: 2,
//                             color: _isValidator
//                                 // ? Colors.transparent
//                                 ? widget.isValid == true
//                                     ? Colors.transparent
//                                     : Colors.redAccent.withOpacity(
//                                         value.get(AniProps.text_opacity))
//                                 : Colors.transparent,
//                           ),
//                           borderRadius: BorderRadius.all(
//                               Radius.circular(widget.roundness))),
//                       child: Neumorphic(
//                         padding: EdgeInsets.only(left: 10),
//                         // margin: EdgeInsets.all(widget.margin),
//                         style: NeumorphicStyle(
//                           boxShape: NeumorphicBoxShape.roundRect(
//                             BorderRadius.all(
//                               Radius.circular(widget.roundness),
//                             ),
//                           ),
//                           oppositeShadowLightSource: true,
//                           depth: value.get(AniProps.depth),
//                           intensity: value.get(AniProps.intensity),
//                           color: AppColors.shadow(appColor)
//                               .withOpacity(value.get(AniProps.opacity) * .2),
//                           shadowDarkColor: AppColors.shadow(outerColor)
//                               .withOpacity(value.get(AniProps.opacity)),
//                           shadowLightColor: AppColors.highlight(outerColor)
//                               .withOpacity(value.get(AniProps.opacity)),
//                           shadowLightColorEmboss: AppColors.shadow(appColor)
//                               .withOpacity(value.get(AniProps.opacity)),
//                           shadowDarkColorEmboss: AppColors.highlight(appColor)
//                               .withOpacity(value.get(AniProps.opacity)),
//                         ),
//                         child:
//                             // HashTagTextField(
//                             TextFormField(
//                           focusNode: myFocusNode,
//                           autofocus: widget.autoFocus,
//                           maxLength: widget.maxLength,

//                           // initialValue: _controller.text ??,
//                           cursorColor: UIHelper.textColor(appColor)
//                               .withOpacity(value.get(AniProps.text_opacity)),
//                           keyboardType: widget.textInputType,
//                           onChanged: (String text) {
//                             setState(() {});
//                             widget.onChanged(text);
//                           },
//                           onFieldSubmitted: (data) {
//                             setState(() {
//                               _isDirty = true;
//                             });
//                             widget.onSubmitted(data);
//                           },
//                           inputFormatters: widget.formatters != null
//                               ? widget.formatters
//                               : null,
//                           obscureText: widget.isPassword && !_showPassword,
//                           textAlignVertical: TextAlignVertical.bottom,
//                           textAlign: widget.textAlign,
//                           style: TextStyle(
//                               fontSize: widget.fontSize,
//                               color: UIHelper.textColor(appColor).withOpacity(
//                                   value.get(AniProps.text_opacity))),
//                           maxLines: widget.maxLines,
//                           controller: _controller,
//                           decoration: widget.icon != null
//                               ? InputDecoration(
//                                   counterText: "",
//                                   contentPadding: EdgeInsets.fromLTRB(
//                                       20.0, 15.0, 20.0, 15.0),
//                                   prefixIcon: Icon(
//                                       _isValidator
//                                           ? widget.isValid == true
//                                               ? Icons.check
//                                               : Icons.warning
//                                           : widget.icon,
//                                       color: _isValidator
//                                           ? widget.isValid == true
//                                               ? Colors.greenAccent
//                                               : Colors.redAccent
//                                           : UIHelper.textColor(appColor)
//                                               .withOpacity(value
//                                                   .get(AniProps.text_opacity))),
//                                   hintText: widget.hint,
//                                   hintStyle: TextStyle(
//                                     fontFamily: 'TitilliumWebLight',
//                                     color: UIHelper.textColor(appColor)
//                                         .withOpacity(
//                                             value.get(AniProps.text_opacity)),
//                                   ),
//                                   border: InputBorder.none,
//                                   focusedBorder: InputBorder.none,
//                                   enabledBorder: InputBorder.none,
//                                   errorBorder: InputBorder.none,
//                                   disabledBorder: InputBorder.none,
//                                 )
//                               : InputDecoration(
//                                   hintText: widget.hint,
//                                   counterText: "",
//                                   hintStyle: TextStyle(
//                                     fontFamily: 'TitilliumWebLight',
//                                     color: UIHelper.textColor(appColor)
//                                         .withOpacity(
//                                             value.get(AniProps.text_opacity) *
//                                                 .3),
//                                   ),
//                                   border: InputBorder.none,
//                                   focusedBorder: InputBorder.none,
//                                   enabledBorder: InputBorder.none,
//                                   errorBorder: InputBorder.none,
//                                   disabledBorder: InputBorder.none,
//                                   contentPadding: widget.paddingEdgeInsets,
//                                 ),
//                         ),
//                       ),
//                     ),
//                     if (widget.maxLength != null &&
//                         _controller != null &&
//                         _controller.text != null &&
//                         _controller.text.isNotEmpty)
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: NeoContainer(
//                           width: 50,
//                           roundness: 12,
//                           padding: 5,
//                           outerColor: widget.appColor,
//                           appColor: UIHelper.invertedButtonColorString(
//                               widget.appColor),
//                           child: Center(
//                             child: UIHelper.buttonText(
//                               "${_controller.text.length}/${widget.maxLength}",
//                               appColor: UIHelper.invertedButtonColorString(
//                                   widget.appColor),
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       )
//                   ],
//                 ),
//                 // Error text or empty container where error text should be
//                 if (widget.canHaveErrorText)
//                   !widget.isValid && widget.errorText != null
//                       ? Center(
//                           child: UIHelper.errorText(widget.errorText,
//                               appColor: appColor, textAlign: TextAlign.center),
//                         )
//                       : Container(height: 18),
//               ],
//             ),
//           );
//         });
//   }
// }
