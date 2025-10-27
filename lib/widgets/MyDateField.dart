import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDateField extends StatefulWidget {
  final TextEditingController controller;
  final String validate;
  final Widget? suffix;
  final int lastDate;
  final TextInputType inputType;
  final String hintText;
  final bool enabled;
  final bool readonly;

  const MyDateField({
    Key? key,
    required this.controller,
    this.inputType = TextInputType.text,
    required this.hintText,
    this.validate = "",
    this.suffix = const Icon(Icons.calendar_month, color: Colors.orange),
    this.lastDate = 365,
    this.enabled = true,
    this.readonly = true,
  }) : super(key: key);

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Text(widget.hintText, style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black87),),*/
        Container(
          width: 240,
          padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
          child: TextFormField(
            onTap: () => datePick(),
            readOnly: widget.readonly,
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.inputType,
            enabled: widget.enabled,
            style: TextStyle(fontSize: 14,color: Colors.black),
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              border: const OutlineInputBorder(),
              suffixIcon: widget.suffix,
              labelText: widget.hintText,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
              ),
            ),
            validator: (value) {
             if (widget.validate == 'string') {
                if (GetUtils.isNullOrBlank('$value') == true) {
                  return 'Required';
                }
                return null;
              } else if (widget.validate == 'String') {
                if (GetUtils.isNullOrBlank('$value') == true) {
                  return 'Required';
                }
                return null;
              }
              return null;
              /*if (GetUtils.isEmail('$value') == false) {
                return 'This email address looks incorrect';
              }
              return null;*/
            },
          ),
        ),
      ],
    );
  }

  void datePick() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now().add(Duration(days: widget.lastDate)),
    ).then((value) {
      if (value != null) {
        widget.controller.text = value.toString().split(' ')[0];
      }
    });
  }
}
