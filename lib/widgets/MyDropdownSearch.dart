import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../model/ProductInfoModel.dart';

class MyDropdownSearch extends StatefulWidget {
  final Function onChanged;
  final String label;
  final double width;
  final List<dynamic> items;
  final dynamic selectedItem;
  final bool isValidate;
  final bool enabled;
  final dynamic itemBuilder;

  const MyDropdownSearch({
    Key? key,
    required this.onChanged,
    required this.label,
    this.isValidate = true,
    this.enabled = true,
    this.selectedItem,
    this.width = 240,
    this.itemBuilder = null,
    required this.items,
  }) : super(key: key);

  @override
  State<MyDropdownSearch> createState() => _State();
}

class _State extends State<MyDropdownSearch> {
  dynamic selectedItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: DropdownSearch<dynamic>(
          enabled: widget.enabled,
          selectedItem: widget.selectedItem,
          items: widget.items,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validator: (Object? item) {
            if (widget.isValidate == false) {
              return null;
            }
            if (item == null) {
              return "Required field";
            } else
              return null;
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: const TextStyle(
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: widget.label,
              labelStyle: const TextStyle(fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF939393),
                  width: 0.4,
                ),
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            searchDelay: Duration(seconds: 0),
            fit: FlexFit.loose,
            showSearchBox: true,
            itemBuilder: widget.itemBuilder,
            searchFieldProps: TextFieldProps(
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                hintText: 'Search...',
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          onChanged: (value) {
            widget.onChanged(value);
          }),
    );
  }

  Widget popupItemBuilderExample(BuildContext context, dynamic item, bool isSelected) {
    return ListTile(
      selected: isSelected,
      title: Text('$item'),
    );
  }
}
