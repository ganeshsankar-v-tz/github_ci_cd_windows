import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../view/trasaction/yarn_inward_from_winder/yarn_inward_from_winder_controller.dart';

class MyDcNoDropdown extends StatefulWidget {
  final Function onChanged;
  final String label;
  final double width;
  final List<WinderIdByDcNoModel> items;
  dynamic selectedItem;
  final bool isValidate;
  final bool enabled;
  final TextInputAction textInputAction;
  final bool forceNextFocus;
  final bool autofocus;

  MyDcNoDropdown({
    Key? key,
    required this.onChanged,
    required this.label,
    this.isValidate = true,
    this.enabled = true,
    this.selectedItem,
    this.width = 240,
    required this.items,
    this.textInputAction = TextInputAction.next,
    this.forceNextFocus = false,
    this.autofocus = true,
  }) : super(key: key);

  @override
  State<MyDcNoDropdown> createState() => _State();
}

class _State extends State<MyDcNoDropdown> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      return Container(
        width: widget.width,
        padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
        child: Autocomplete<WinderIdByDcNoModel>(
          optionsBuilder: (TextEditingValue value) {
            if (value.text == '') {
              widget.selectedItem = null;
              return widget.items;
            }
            if (value.text == '${widget.selectedItem?.toString()} ') {
              return widget.items;
            }
            return widget.items.where((WinderIdByDcNoModel option) {
              var _value = value.text.toString().toLowerCase();
              var _dcNo = '${option.dcNo}'.toLowerCase();
              var _eDate = '${option.eDate}'.toLowerCase();
              return _dcNo.contains(_value) || _eDate.contains(_value);
            });
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 400, maxWidth: 350),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final WinderIdByDcNoModel option =
                          options.elementAt(index);

                      return InkWell(
                        onTap: () {
                          onSelected(option);
                          _focusNode.nextFocus();
                        },
                        child: Builder(builder: (BuildContext context) {
                          final bool highlight =
                              AutocompleteHighlightedOption.of(context) ==
                                  index;
                          if (highlight) {
                            SchedulerBinding.instance
                                .addPostFrameCallback((Duration timeStamp) {
                              Scrollable.ensureVisible(context, alignment: 0.5);
                            });
                          }
                          return Container(
                            color: highlight ? const Color(0xffA3D8FF) : null,
                            child: ListTile(
                              title: Text(
                                '${option.dcNo}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: SizedBox(
                                  child: Text(
                                    "${option.eDate}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController controller,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            _focusNode = focusNode;
            focusNode.addListener(() {
              if (focusNode.hasFocus && widget.selectedItem != null) {
                controller.text = '${widget.selectedItem?.toString()} ';
                controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.text.length,
                );
              }
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.text = widget.selectedItem != null
                  ? '${widget.selectedItem?.toString()} '
                  : "";
            });
            return TextFormField(
              onFieldSubmitted: (value) {
                onFieldSubmitted();
              },
              textInputAction: widget.textInputAction,
              autofocus: widget.autofocus,
              enabled: widget.enabled,
              controller: controller,
              style: const TextStyle(fontSize: 14),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (item) {
                if (widget.isValidate == false) {
                  return null;
                }

                if (widget.selectedItem == null) {
                  return "Required";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
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
                  suffixIcon: const Icon(Icons.arrow_drop_down)),
              focusNode: focusNode,
            );
          },
          onSelected: (item) {
            widget.selectedItem = item;
            widget.onChanged(item);
            if (widget.forceNextFocus == true) {
              _focusNode.nextFocus();
            }
          },
        ),
      );
    });
  }
}
