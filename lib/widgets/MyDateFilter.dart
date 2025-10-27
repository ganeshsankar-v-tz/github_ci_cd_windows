import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyDateFilter extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String labelText;
  final String hintText;
  final int lastDate;
  final bool enabled;
  final bool readonly;
  final bool required;
  final bool autofocus;
  final Function? onChanged;
  final FocusNode? focusNode;
  final double width;

  const MyDateFilter({
    super.key,
    required this.controller,
    this.inputType = TextInputType.number,
    this.hintText = "yyyy-MM-dd",
    required this.labelText,
    this.enabled = true,
    this.readonly = false,
    this.required = true,
    this.autofocus = false,
    this.lastDate = 0,
    this.onChanged,
    this.focusNode,
    this.width = 240,
  });

  @override
  State<MyDateFilter> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateFilter> {
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width,
          padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
          child: TextFormField(
            readOnly: widget.readonly,
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.inputType,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            maxLength: 10,
            textInputAction: TextInputAction.next,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              DateInputFormatter(),
              // _formatDate(),
            ],
            enabled: widget.enabled,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              border: const OutlineInputBorder(),
              counterText: "",
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                icon: const Icon(Icons.calendar_month, color: Colors.orange),
                //onPressed: () => datePick(),
                onPressed: () => _selectDateRange(context),
              ),
              labelText: widget.labelText,
              hintText: widget.hintText,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
              ),
            ),
            validator: (value) {
              //Date field optional condition
              if (widget.required == false) {
                if (widget.controller.text == '') {
                  return null;
                } else if (!isDate('$value')) {
                  return 'Invalid date';
                } else if (value?.length != 10) {
                  // return 'Date must be in the format YYYY-MM-DD';
                  return 'Invalid date';
                }
                // Date field required condition
              } else {
                if (!isDate('$value')) {
                  return 'Invalid date';
                } else if (value?.length != 10) {
                  return 'Invalid date';
                }
              }
              return null;
            },
            onChanged: (value) {
              if (widget.onChanged != null && isDate(value)) {
                widget.onChanged!(value);
              }
            },
            onTapOutside: (value) {},
          ),
        ),
      ],
    );
  }

  bool isDate(String input) {
    try {
      final DateTime dateTime = DateFormat('yyyy-MM-dd').parseStrict(input);
      return true;
      //not allowed future date code:
      /*if (isBetween(dateTime)) {
        return true;
      } else {
        return false;
      }*/
    } catch (e) {
      return false;
    }
  }

  //not allowed future date code:
  /*bool isBetween(DateTime date) {
    var formDate = DateTime(2010);
    var endDate = DateTime.now();
    final isAfter = date.isAfter(formDate);
    final isBefore = date.isBefore(endDate);
    return isAfter && isBefore;
  }*/

  void _selectDateRange(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          content: Container(
            width: 350,
            height: 350,
            padding: EdgeInsets.only(top: 12),
            child: SfDateRangePicker(
              navigationDirection: DateRangePickerNavigationDirection.vertical,
              navigationMode: DateRangePickerNavigationMode.scroll,
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.deepPurple[50],
              ),
              minDate: DateTime(2010),
              // maxDate: DateTime.now(),
              onSelectionChanged: (arg) {
                widget.controller.text = arg.value.toString().split(' ')[0];
                Get.back();
              },
            ),
          ),
        );
      },
    );
  }

  void datePick() async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      // lastDate: DateTime.now().add(Duration(days: widget.lastDate)),
      lastDate: DateTime(2100),
    ).then((value) {
      if (value != null) {
        widget.controller.text = value.toString().split(' ')[0];
        if (widget.onChanged != null && isDate(widget.controller.text)) {
          widget.onChanged!(value);
        }
        // Get.back();
      }
    });
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedValue = _formatDate(oldValue.text, newValue.text);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatDate(String oldValue, String newValue) {
    // Remove all characters except digits
    String digitsOnly = newValue.replaceAll(RegExp(r'[^\d]'), '');

    // If there are no digits, return empty string
    if (digitsOnly.isEmpty) return '';

    // If the length of the new value is less than the old value,
    // it means the user is removing characters.
    if (newValue.length < oldValue.length) {
      String oldDigitsOnly = oldValue.replaceAll(RegExp(r'[^\d]'), '');
      String year = oldDigitsOnly.substring(0, 4);
      String month = oldDigitsOnly.substring(4, 6);
      String day = oldDigitsOnly.substring(6, 8);

      return '$year-${digitsOnly.substring(4, 6)}-${digitsOnly.substring(6, 8)}';
    }

    // Format digits into YYYY-MM-DD
    String formattedDate = '';

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 4 || i == 6) {
        formattedDate += '-';
      }
      formattedDate += digitsOnly[i];
    }

    return formattedDate;
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer();
    int selectionIndex = newValue.selection.end;

    // Apply date formatting logic
    for (int i = 0; i < newValue.text.length; i++) {
      if (i == 4 || i == 6) {
        newText.write('-');
        if (selectionIndex > i) {
          selectionIndex += 1;
        }
      }
      newText.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
