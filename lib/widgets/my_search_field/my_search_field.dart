import 'package:flutter/material.dart';

import '../searchfield/decoration.dart';
import '../searchfield/searchfield.dart';

class MySearchField extends StatefulWidget {
  final String label;
  final TextEditingController textController;
  final FocusNode focusNode;
  final FocusNode requestFocus;
  final List<Object> items;
  final Function onChanged;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final double width;
  final bool isValidate;
  final bool setInitialValue;
  final bool isArrayValidate;

  const MySearchField({
    super.key,
    required this.label,
    required this.items,
    required this.textController,
    required this.focusNode,
    required this.requestFocus,
    required this.onChanged,
    this.enabled = true,
    this.autofocus = true,
    this.textInputAction = TextInputAction.next,
    this.width = 240,
    this.isValidate = true,
    this.setInitialValue = true,
    this.isArrayValidate = true,
  });

  @override
  State<MySearchField> createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
  var initialValue;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        widget.textController.selection = TextSelection(
            baseOffset: 0, extentOffset: widget.textController.text.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.setInitialValue == true) {
      if (widget.textController.text.isNotEmpty && widget.items.isNotEmpty) {
        var item = widget.items
            .where(
              (element) =>
                  element.toString().toLowerCase() ==
                  widget.textController.text.toLowerCase(),
            )
            .toList();

        if (item.isNotEmpty) {
          initialValue = SearchFieldListItem<Object>(
            widget.textController.text,
            item: Object,
            child: SizedBox(
              width: 300,
              child: Text(widget.textController.text),
            ),
          );
        }
      } else {
        initialValue = null;
      }
    }

    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<Object>(
        suggestions: suggestions(widget.items),
        // suggestions: widget.items
        //     .map((e) => SearchFieldListItem<Object>('$e', item: e))
        //     .toList(),
        itemHeight: 45,
        initialValue: initialValue,
        maxSuggestionsInViewPort: 8,
        enabled: widget.enabled,
        controller: widget.textController,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        searchStyle: const TextStyle(fontSize: 14, color: Colors.black),
        searchInputDecoration: InputDecoration(
            label: Text(widget.label),
            labelStyle: const TextStyle(fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down)),
        suggestionsDecoration: SuggestionDecoration(
          selectionColor: const Color(0xffA3D8FF),
          color: Colors.white,
          elevation: 3,
        ),
        onSuggestionTap: (value) {
          var item = value.item!;
          widget.onChanged(item);
          FocusScope.of(context).requestFocus(widget.requestFocus);
        },
        onSearchTextChanged: (query) {
          return suggestions(widget.items, query: query);
        },
        validator: (value) {
          if (widget.isValidate == false) {
            return null;
          }
          bool validate() {
            var result = widget.items.where((element) {
              return element.toString().toLowerCase() ==
                  widget.textController.text.toLowerCase();
            });

            if (widget.isArrayValidate == true) {
              if (result.isNotEmpty) {
                return true;
              }
              return false;
            } else {
              return true;
            }
          }

          if (widget.textController.text.isEmpty) {
            return "Required";
          } else if (validate() == false) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }

  suggestions(List<Object> list, {var query = ''}) {
    final filter = list
        .where(
            (element) => '$element'.toLowerCase().contains(query.toLowerCase()))
        .toList();
    var suggestions = filter
        .map(
          (e) => SearchFieldListItem<Object>(
            '$e',
            item: e,
            child: SizedBox(width: 300, child: Text('$e')),
          ),
        )
        .toList();

    return suggestions;
  }
}
