import 'package:abtxt/model/LoomGroup.dart';
import 'package:flutter/material.dart';

import '../searchfield/decoration.dart';
import '../searchfield/searchfield.dart';

class MyLoomSearchField extends StatefulWidget {
  final String label;
  final TextEditingController textController;
  final FocusNode focusNode;
  final FocusNode requestFocus;
  final List<LoomGroup> items;
  final Function onChanged;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final double width;
  final bool isValidate;

  const MyLoomSearchField({
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
  });

  @override
  State<MyLoomSearchField> createState() => _MyLoomSearchFieldState();
}

class _MyLoomSearchFieldState extends State<MyLoomSearchField> {
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
    var list = widget.items;

    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<LoomGroup>(
        suggestions: loomSuggestions(list),
        itemHeight: 45,
        maxSuggestionsInViewPort: 8,
        enabled: widget.enabled,
        controller: widget.textController,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        searchStyle: const TextStyle(fontSize: 14),
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
          width: 500,
          color: Colors.white,
          elevation: 3,
        ),
        onSearchTextChanged: (query) {
          return loomSuggestions(list, query: query);
        },
        onSuggestionTap: (value) {
          var item = value.item!;
          widget.onChanged(item);
          FocusScope.of(context).requestFocus(widget.requestFocus);
        },
        validator: (value) {
          if (widget.isValidate == false) {
            return null;
          }

          if (widget.textController.text.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }

  loomSuggestions(List<LoomGroup> list, {var query = ''}) {
    final filter = list
        .where((element) =>
            '$element'.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    var suggestions = filter.map(
      (e) {
        var newDD = e.looms.where((f) => f.currentStatus == 'New');
        var runningDD = e.looms.where((f) => f.currentStatus == 'Running');
        var completedDD = e.looms.where((f) => f.currentStatus == 'Completed');
        return SearchFieldListItem<LoomGroup>(
          '${e.loomNo}',
          item: e,
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(4),
                  width: 100,
                  child: Text('${e.loomNo}')),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(newDD.isNotEmpty ? 'New' : ''),
                  ),
                  SizedBox(
                      width: 100,
                      child: Text(runningDD.isNotEmpty ? 'Running' : '')),
                  SizedBox(
                      width: 100,
                      child: Text(completedDD.isNotEmpty ? 'Completed' : '')),
                ],
              ),
            ],
          ),
        );
      },
    ).toList();

    return suggestions;
  }
}
