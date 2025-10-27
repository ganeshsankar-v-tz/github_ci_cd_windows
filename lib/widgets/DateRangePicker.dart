import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePickerFilter extends StatefulWidget {
  final TextEditingController controller;

  //final Widget? suffix;
  final TextInputType inputType;
  final String labelText;
  final String hintText;
  final int lastDate;
  final bool enabled;
  final bool readonly;
  final bool required;
  final Function? onChanged;
  final FocusNode? focusNode;

  const DateRangePickerFilter({
    Key? key,
    required this.controller,
    this.inputType = TextInputType.number,
    this.hintText = "yyyy-MM-dd",
    required this.labelText,
    this.enabled = true,
    this.readonly = false,
    this.required = true,
    this.lastDate = 0,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  @override
  State<DateRangePickerFilter> createState() => _DateRangePickerFilterState();
}

class _DateRangePickerFilterState extends State<DateRangePickerFilter> {
  DateTime currentDate = DateTime.now();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 240,
          padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
          child: TextFormField(
            readOnly: widget.readonly,
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.inputType,
            focusNode: widget.focusNode,
            maxLength: 10,
            textInputAction: TextInputAction.next,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              DateInputFormatter(),
              // _formatDate(),
            ],
            enabled: widget.enabled,
            style: const TextStyle(fontSize: 14),
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
            /*
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
            */
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
              selectionMode: DateRangePickerSelectionMode.range,
              minDate: DateTime(2010),
              // maxDate: DateTime.now(),
              onSelectionChanged: (arg) {
                setState(() {
                  _startDate = arg.value.startDate;
                  _endDate = arg.value.endDate;

                  if (_startDate != null && _endDate != null) {
                    widget.controller.text =
                        '${_startDate!.toString().split(' ')[0]}  -  ${_endDate!.toString().split(' ')[0]}';
                    Get.back();
                  }
                  // Get.back();
                });
              },
            ),
          ),
        );
      },
    );
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
