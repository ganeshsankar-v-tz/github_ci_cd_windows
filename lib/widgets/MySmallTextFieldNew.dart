import 'package:flutter/material.dart';

class MySmallTextFieldNew extends StatefulWidget {
  final TextEditingController controller;
  final Function? onChanged;
  final Widget? suffix;
  final bool enabled;
  const MySmallTextFieldNew({
    super.key,
    required this.controller,
    this.onChanged,
    this.suffix,
    required this.enabled,
  });

  @override
  State<MySmallTextFieldNew> createState() => _MySmallTextFieldState();
}

class _MySmallTextFieldState extends State<MySmallTextFieldNew> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      padding: EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        decoration: InputDecoration(
          isCollapsed: true,
          suffix: widget.suffix,
          contentPadding: EdgeInsets.all(12),
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(fontSize: 12.0),
      ),
    );
  }
}
