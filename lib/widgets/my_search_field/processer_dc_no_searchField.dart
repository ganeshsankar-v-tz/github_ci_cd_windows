import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/material.dart';

import '../../view/trasaction/product_inward_from_process/product_inward_from_process_controller.dart';
import '../searchfield/decoration.dart';
import '../searchfield/searchfield.dart';

class ProcessorDcNoDropDownNew extends StatefulWidget {
  final String label;
  final TextEditingController textController;
  final FocusNode focusNode;
  final FocusNode requestFocus;
  final List<ProcessorIdByDcNoModel> items;
  final Function onChanged;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final double width;
  final bool isValidate;

  const ProcessorDcNoDropDownNew({
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
  State<ProcessorDcNoDropDownNew> createState() =>
      _ProcessorDcNoDropDownNewState();
}

class _ProcessorDcNoDropDownNewState extends State<ProcessorDcNoDropDownNew> {
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
      child: SearchField<ProcessorIdByDcNoModel>(
        suggestions: suggestions(list),
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
          width: 350,
          color: Colors.white,
          elevation: 3,
        ),
        onSuggestionTap: (value) {
          var item = value.item!;
          widget.onChanged(item);
          FocusScope.of(context).requestFocus(widget.requestFocus);
        },
        onSearchTextChanged: (query) {
          return suggestions(list, query: query);
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

  suggestions(List<ProcessorIdByDcNoModel> list, {var query = ''}) {
    var filter = list;
    if (query.isNotEmpty) {
      filter = filter.where(
        (element) {
          var dcNo = element.dcNo.toString().toLowerCase();
          var eDate = element.eDate.toString().toLowerCase();
          var q = query.toLowerCase();
          return dcNo.toLowerCase().contains(q) ||
              eDate.toLowerCase().contains(q);
        },
      ).toList();
    }

    var suggestions = filter.map(
      (e) {
        return SearchFieldListItem<ProcessorIdByDcNoModel>(
          '${e.dcNo}',
          item: e,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(6),
                  width: 80,
                  child: Text('${e.dcNo}')),
              Container(
                  padding: const EdgeInsets.all(6),
                  width: 180,
                  child: Text('${e.eDate}')),
              SizedBox(
                width: 50,
                child: Text(tryCast(e.firmShortCode)),
              ),
            ],
          ),
        );
      },
    ).toList();
    return suggestions;
  }
}
