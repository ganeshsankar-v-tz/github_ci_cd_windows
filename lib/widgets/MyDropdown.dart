
import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/ProductInfoModel.dart';

class MyDropdown extends StatefulWidget {
  final Function? onChanged;
  final String hintText;
  final double width;
  final List<dynamic> items;

  const MyDropdown({
    Key? key,
    this.onChanged,
    required this.hintText,
    this.width = 240.0,
    required this.items,
  }) : super(key: key);

  @override
  State<MyDropdown> createState() => _State();
}

class _State extends State<MyDropdown> {
  dynamic selectedItem;


  @override
  void initState() {
    /*if(widget.items.isNotEmpty){
      selectedItem = jsonEncode(widget.items[0]);
    }*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: widget.width,
      padding: EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: null,
        items: widget.items.map<DropdownMenuItem<String>>((dynamic value) {
            return DropdownMenuItem<String>(
              value: jsonEncode(value),
              child: Text('$value'),
            );
          },
        ).toList(),
        onChanged: (dynamic newValue) {
          if (widget.onChanged != null) {
            widget.onChanged!(jsonDecode(newValue));
          }
        },
        style: TextStyle(fontSize: 14,color: Color(0xFF141414), fontFamily: 'Poppins'),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          border: OutlineInputBorder(),
          labelText: '${widget.hintText}',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
          ),
          labelStyle: TextStyle(fontSize: 14),
        ),

        validator: (value) {
          if (value == null) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }
}
