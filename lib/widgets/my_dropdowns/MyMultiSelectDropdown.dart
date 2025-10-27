import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class MyMultiSelectDropdown extends StatefulWidget {
  final String label;
  final double width;
  final List<Object> items;
  final bool isValidate;
  final void Function(List<Object?>) onConfirm;

  MyMultiSelectDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onConfirm,
    this.isValidate = true,
    this.width = 240,
  });

  @override
  State<MyMultiSelectDropdown> createState() => _MyState();
}

class _MyState extends State<MyMultiSelectDropdown> {
  late List<Object?> selectedItems;

  @override
  void initState() {
    selectedItems = <MultiSelectItem>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: MultiSelectDialogField<Object?>(
        items: multiSelectItem(widget.items),
        backgroundColor: Colors.white,
        dialogWidth: 350,
        searchable: true,
        title: Text(widget.label),
        buttonText: Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        selectedColor: Colors.blue,
        validator: (value) {
          if (widget.isValidate == false) {
            return null;
          }

          if (value == null || value.isEmpty) {
            return 'Please select at least one item';
          }
          return null;
        },
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: const Color(0xFF939393), width: 0.4),
        ),
        buttonIcon: const Icon(Icons.arrow_drop_down),
        chipDisplay: MultiSelectChipDisplay(
          scroll: true,
          items: multiSelectItem(selectedItems),
          onTap: (p0) {
            setState(() {
              selectedItems.remove(p0);
            });
          },
        ),
        onConfirm: (results) {
          selectedItems = results;

          widget.onConfirm(results.map((e) => e).toList());
        },
      ),
    );
  }

  List<MultiSelectItem<T>> multiSelectItem<T>(List<T> items) {
    return items.map((e) => MultiSelectItem<T>(e, e.toString())).toList();
  }
}
