import 'package:flutter/material.dart';

import '../../view/trasaction/yarn_inward_from_winder/yarn_inward_from_winder_controller.dart';
import '../searchfield/decoration.dart';
import '../searchfield/searchfield.dart';

class WinderInwardDcDropDown extends StatefulWidget {
  final String label;
  final TextEditingController textController;
  final FocusNode focusNode;
  final FocusNode requestFocus;
  final List<WinderIdByDcNoModel> items;
  final Function onChanged;
  final Function searchTextChange;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final double width;
  final bool isValidate;
  final WinderIdByDcNoModel? selectedItem;

  const WinderInwardDcDropDown({
    super.key,
    required this.label,
    required this.items,
    required this.textController,
    required this.focusNode,
    required this.requestFocus,
    required this.onChanged,
    required this.selectedItem,
    required this.searchTextChange,
    this.enabled = true,
    this.autofocus = true,
    this.textInputAction = TextInputAction.next,
    this.width = 240,
    this.isValidate = true,
  });

  @override
  State<WinderInwardDcDropDown> createState() => _WinderInwardDcDropDownState();
}

class _WinderInwardDcDropDownState extends State<WinderInwardDcDropDown> {
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
    if (widget.selectedItem != null) {
      initialValue = SearchFieldListItem<WinderIdByDcNoModel>(
        "${widget.selectedItem?.dcNo}",
        item: widget.selectedItem,
        child:
            SizedBox(width: 300, child: Text("${widget.selectedItem?.dcNo}")),
      );
    }

    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<WinderIdByDcNoModel>(
        suggestions: suggestions(widget.items),
        onSearchTextChanged: (query) {
          widget.searchTextChange(query);
          return suggestions(widget.items, query: query);
        },
        itemHeight: 60,
        initialValue: initialValue,
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
        onSuggestionTap: (value) {
          var item = value.item!;
          FocusScope.of(context).requestFocus(widget.requestFocus);
          widget.onChanged(item);
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

  suggestions(List<WinderIdByDcNoModel> list, {var query = ''}) {
    var filter = list;
    if (query.isNotEmpty) {
      filter = filter.where((e) {
        var dcNo = '${e.dcNo}'.toLowerCase();
        var eDate = '${e.eDate}'.toLowerCase();
        var yarnNames = '${e.yarnNames}'.toLowerCase();
        var q = query.toLowerCase();
        return dcNo.contains(q) || eDate.contains(q) || yarnNames.contains(q);
      }).toList();
    }

    var suggestions = filter
        .map(
          (e) => SearchFieldListItem<WinderIdByDcNoModel>(
            '${e.dcNo}',
            item: e,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        '${e.dcNo}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        '${e.eDate}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Tooltip(
                  message: "${e.yarnNames}",
                  child: Text(
                    '${e.yarnNames}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff020d8a),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
    return suggestions;
  }
}
