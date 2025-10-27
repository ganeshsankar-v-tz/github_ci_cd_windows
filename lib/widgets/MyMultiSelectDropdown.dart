/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MyMultiSelectDropdown extends StatefulWidget {
  final List<Object> items;
  final double width;
  final String? hintText;
  final bool isValidate;
  final Function onChanged;

  const MyMultiSelectDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.isValidate = true,
    this.width = 240,
  });

  @override
  State<MyMultiSelectDropdown> createState() => _MyMultiSelectDropdownState();
}

class _MyMultiSelectDropdownState extends State<MyMultiSelectDropdown> {
  final controller = MultiSelectController<Object>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: MultiDropdown<Object>(
        items: dropdownItem(widget.items),
        controller: controller,
        enabled: true,
        searchEnabled: true,
        chipDecoration: const ChipDecoration(
          wrap: true,
          runSpacing: 2,
          spacing: 10,
          labelStyle: TextStyle(overflow: TextOverflow.ellipsis),
        ),
        fieldDecoration: FieldDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
              color: Colors.black87, overflow: TextOverflow.ellipsis),
          showClearIcon: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
          ),
        ),
        dropdownDecoration: const DropdownDecoration(
          marginTop: 2,
          maxHeight: 300,
        ),
        dropdownItemDecoration: DropdownItemDecoration(
          selectedIcon: const Icon(Icons.check_box, color: Colors.green),
          disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
        ),
        validator: (value) {
          if (widget.isValidate == false) {
            return null;
          }

          if (value == null || value.isEmpty) {
            return 'Required';
          }
          return null;
        },
        onSelectionChange: (selectedItems) {
          var item = controller.selectedItems.map((e) => e.value).toList();

          widget.onChanged(item);
        },
      ),
    );
  }

  dropdownItem(List<Object> items) {
    var item = items
        .map((e) => DropdownItem<Object>(value: e, label: e.toString()))
        .toList();

    return item;
  }
}
*/
