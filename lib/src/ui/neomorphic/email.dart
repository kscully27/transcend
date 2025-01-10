// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';
// import 'package:neomorphic/text_field.dart';

// class EmailAddress extends StatefulWidget {
//   final String appColor;
//   final String initialValue;
//   final bool isDirty;
//   final bool isAnimated;
//   final Function onChanged;
//   final double height;
//   final TextEditingController textController;
//   EmailAddress(
//       {Key key,
//       this.appColor = "light",
//       this.height = 70,
//       this.onChanged,
//       this.isAnimated,
//       this.isDirty,
//       this.initialValue,
//       this.textController})
//       : assert(textController != null || onChanged != null),
//         super(key: key);

//   bool get isValid => true;
//   @override
//   _EmailAddressState createState() => _EmailAddressState();
// }

// class _EmailAddressState extends State<EmailAddress> {
//   bool _isDirty;
//   bool _isValid;
//   String _email;
//   @override
//   void initState() {
//     _isDirty = widget.initialValue != null ? true : false;
//     _isValid = false;
//     _email = widget.initialValue ?? "";
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     void _onChanged(String data) {
//       setState(() {
//         _isValid = EmailValidator.validate(_email);
//         _isDirty = true;
//         _email = data;
//       });
//       EmailValidator.validate(_email);
//       if (widget.onChanged != null) widget.onChanged(data);
//     }

//     return NeoTextField(
//       isDirty: widget.isDirty != null ? widget.isDirty : _isDirty,
//       isValid: _isValid,
//       isAnimated: widget.isAnimated,
//       controller: widget.textController,
//       margin: 4,
//       value: _email,
//       height: widget.height,
//       outerColor: widget.appColor,
//       onChanged: _onChanged,
//       label: "Email",
//       appColor: widget.appColor,
//     );
//   }
// }
