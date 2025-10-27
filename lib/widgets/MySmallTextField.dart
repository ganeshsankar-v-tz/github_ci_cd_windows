import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class MySmallTextField extends StatefulWidget {
  final String validate;
  final TextEditingController controller;
  final Function? onChanged;
  final Widget? suffix;
  final bool readonly;
  final bool enabled;
  final TextInputAction textInputAction;
  const MySmallTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.validate = "double",
    this.suffix,
    this.readonly = false,
    this.enabled = true,
    this.textInputAction = TextInputAction.none,
  });

  @override
  State<MySmallTextField> createState() => _MySmallTextFieldState();
}

class _MySmallTextFieldState extends State<MySmallTextField> {
  @override
  Widget build(BuildContext context) {
    widget.controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.controller.text.length,
    );
    return Container(
      width: 100.0,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: TextFormField(
        controller: widget.controller,
        showCursor: !widget.readonly,
        readOnly: widget.readonly,
        enabled: widget.enabled,
        keyboardType: _keyboardType(),
        inputFormatters: _inputFormater(),
        textInputAction: widget.textInputAction,
        validator: (value) {
          if (widget.validate == 'number') {
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
          }
          return null;
        },
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        decoration: InputDecoration(
          isCollapsed: true,
          suffix: widget.suffix,
          contentPadding: const EdgeInsets.all(12),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4)),
        ),
        style: const TextStyle(fontSize: 12.0),
      ),
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
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
      ];
    } else if (widget.validate == 'number') {
      return [FilteringTextInputFormatter.digitsOnly];
    } else {
      return [FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))];
    }
  }
}
