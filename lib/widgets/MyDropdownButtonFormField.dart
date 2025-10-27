import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDropdownButtonFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final List<String> items;
  final Function? onChanged;
  final FocusNode? focusNode;
  final bool enabled;
  final bool autofocus;
  final double width;

  const MyDropdownButtonFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.items,
    this.focusNode,
    this.onChanged,
    this.autofocus = false,
    this.enabled = true,
    this.width = 240,
  });

  @override
  State<MyDropdownButtonFormField> createState() => _State();
}

class _State extends State<MyDropdownButtonFormField> {
  final FocusNode _dropdownFocusNode = FocusNode(onKeyEvent: _handleKeyEvent);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: Focus(
        skipTraversal: true,
        focusNode: _dropdownFocusNode,
        child: DropdownButtonFormField<String>(
          iconEnabledColor: widget.enabled ? Colors.black : Colors.grey,
          isExpanded: true,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          value: widget.controller.text,
          items: widget.items.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                enabled: widget.enabled,
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
          ).toList(),
          onChanged: widget.enabled
              ? (String? newValue) {
                  widget.controller.text = newValue!;
                  if (widget.onChanged != null) {
                    widget.onChanged!(newValue);
                  }
                }
              : null,
          /*onChanged:(String? newValue) {
            widget.controller.text = newValue!;
            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },*/
          style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF141414),
              fontFamily: 'Poppins',
              overflow: TextOverflow.ellipsis),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            border: const OutlineInputBorder(),
            hintText: widget.hintText,
            labelText: widget.hintText,
            enabled: widget.enabled,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF939393),
                width: 0.4,
              ),
            ),
            labelStyle: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}

KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent keyEvent) {
  if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown) {
    return KeyEventResult.handled;
  } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp) {
    return KeyEventResult.handled;
  } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft) {
    return KeyEventResult.handled;
  } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowRight) {
    return KeyEventResult.handled;
  }
  return KeyEventResult.ignored;
}
