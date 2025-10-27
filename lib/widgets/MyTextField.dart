import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String validate;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType inputType;
  final FocusNode? focusNode;
  final String hintText;
  final bool enabled;
  final bool readonly;
  final int? maxLength;
  final bool autofocus;
  final Function? onChanged;
  final Function? onFieldSubmitted;
  final double width;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    this.inputType = TextInputType.text,
    required this.hintText,
    this.validate = "",
    this.focusNode,
    this.suffix,
    this.suffixIcon,
    this.enabled = true,
    this.readonly = false,
    this.maxLength,
    this.onChanged,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.width = 240,
    this.obscureText = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.focusNode?.addListener(() {
        if (widget.focusNode!.hasFocus) {
          widget.controller.selection = TextSelection(
              baseOffset: 0, extentOffset: widget.controller.text.length);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.controller.text.length,
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width,
          padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
          child: TextFormField(
            obscureText: widget.obscureText,
            autofocus: widget.autofocus,
            focusNode: widget.focusNode,
            showCursor: !widget.readonly,
            readOnly: widget.readonly,
            enableInteractiveSelection: true,
            maxLength: widget.maxLength,
            textInputAction: TextInputAction.next,
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: _keyboardType(),
            inputFormatters: _inputFormater(),
            enabled: widget.enabled,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              border: const OutlineInputBorder(),
              suffix: widget.suffix,
              suffixIcon: widget.suffixIcon,
              labelText: widget.hintText,
              counterText: '',
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
              ),
            ),
            validator: (value) {
              if (widget.validate == "email") {
                if (GetUtils.isEmail('$value') == false) {
                  return 'This email address looks incorrect';
                }
                return null;
              } else if (widget.validate == 'number') {
                if (value == "") {
                  return 'Required';
                } else if (GetUtils.isNumericOnly('$value') == false) {
                  return 'Incorrect number';
                }
                return null;
              } else if (widget.validate == 'double') {
                if (value == "") {
                  return 'Required';
                } else if (GetUtils.isNum('$value') == false) {
                  return 'Incorrect number';
                }
                return null;
              } else if (widget.validate == 'string') {
                if (GetUtils.isNullOrBlank('$value') == true) {
                  return 'Required';
                }
                return null;
              } else if (widget.validate == 'String') {
                if (GetUtils.isNullOrBlank('$value') == true) {
                  return 'Required';
                }
                return null;
              } else if (widget.validate == 'gst') {
                if (value == '') {
                  return null;
                }
                if ('$value'.isValidGST() == false) {
                  return 'Invalid GST number';
                }
                return null;
              } else if (widget.validate == 'ifsc_code') {
                if (value == '') {
                  return null;
                }
                if ('$value'.isValidIFSC() == false) {
                  return 'Invalid IFSC number';
                }
                return null;
              }
              return null;
            },
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            onFieldSubmitted: (value) {
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted!(value);
              }
            },
            onTapOutside: (val) {},
          ),
        ),
      ],
    );
  }

  _keyboardType() {
    if (widget.validate == 'double') {
      return const TextInputType.numberWithOptions(decimal: true);
    } else if (widget.validate == 'number') {
      return TextInputType.number;
    } else {
      return TextInputType.text;
    }
  }

  _inputFormater() {
    if (widget.validate == 'double') {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,3}')),
      ];
    } else if (widget.validate == 'number') {
      return [FilteringTextInputFormatter.digitsOnly];
    } else {
      return [FilteringTextInputFormatter.deny(RegExp(r'[\\]'))];
    }
  }
}
