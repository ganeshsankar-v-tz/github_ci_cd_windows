import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountTextField extends StatefulWidget {
  final TextEditingController controller;
  final String validate;
  final Widget? suffix;
  final TextInputType inputType;
  final String hintText;
  final bool enabled;
  final bool readonly;

  const CountTextField({
    Key? key,
    required this.controller,
    this.inputType = TextInputType.text,
    required this.hintText,
    this.validate = "",
    this.suffix,
    this.enabled = true,
    this.readonly = false,
  }) : super(key: key);

  @override
  State<CountTextField> createState() => _CountTextFieldState();
}

class _CountTextFieldState extends State<CountTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Text(widget.hintText, style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black87),),*/
        Container(
          height: 58,
          width: 165,
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            readOnly: widget.readonly,
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.inputType,
            enabled: widget.enabled,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF5700BC), width: 0.4), // Set border color
              ),
              border: const OutlineInputBorder(),
              suffix: widget.suffix,
              suffixStyle: TextStyle(
                color: Color(0xFF5700BC),
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
              labelText: '${widget.hintText}',
              labelStyle: TextStyle(
                color: Color(0xFF5700BC),
                  fontSize: 14.0,
              ),
            ),
            validator: (value) {
              if (widget.validate == "email") {
                if (GetUtils.isEmail('$value') == false) {
                  return 'This email address looks incorrect';
                }
                return null;
              } else if (widget.validate == 'number') {
                if (GetUtils.isNumericOnly('$value') == false) {
                  return 'Incorrect number';
                }
                return null;
              } else if (widget.validate == 'double') {
                if (GetUtils.isNum('$value') == false) {
                  return 'Incorrect number';
                }
                return null;
              } else if (widget.validate == 'string') {
                if (GetUtils.isNullOrBlank('$value') == true) {
                  return 'Empty';
                }
                return null;
              }
              else if (widget.validate == 'String') {
                if (GetUtils.isNullOrBlank('$value') == true) {
                  return 'Empty';
                }
                return null;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
