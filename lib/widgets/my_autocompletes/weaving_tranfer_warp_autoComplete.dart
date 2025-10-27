import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../model/weaving_models/WeavingOtherWarpBalanceModel.dart';

class WeavingTransferWarpAutoComplete extends StatefulWidget {
  final Function onChanged;
  final String label;
  final double width;
  final List<WeavingOtherWarpBalanceModel> items;
  dynamic selectedItem;
  final bool isValidate;
  final bool enabled;
  final bool autofocus;
  TextInputAction textInputAction;
  bool forceNextFocus;

  WeavingTransferWarpAutoComplete({
    super.key,
    required this.onChanged,
    required this.label,
    this.isValidate = true,
    this.enabled = true,
    this.forceNextFocus = false,
    this.autofocus = true,
    this.selectedItem,
    this.textInputAction = TextInputAction.next,
    this.width = 240,
    required this.items,
  });

  @override
  State<WeavingTransferWarpAutoComplete> createState() => _State();
}

class _State extends State<WeavingTransferWarpAutoComplete> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: Autocomplete<WeavingOtherWarpBalanceModel>(
        optionsBuilder: (TextEditingValue value) {
          if (!widget.enabled) {
            return [];
          }
          if (value.text == '') {
            widget.selectedItem = null;
            return widget.items;
          }
          if (value.text == '${widget.selectedItem?.toString()} ') {
            return widget.items;
          }
          return widget.items.where((WeavingOtherWarpBalanceModel option) {
            return option
                .toString()
                .toLowerCase()
                .startsWith(value.text.toLowerCase());
          });
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 400, maxWidth: 450),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final WeavingOtherWarpBalanceModel option =
                        options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                        _focusNode.nextFocus();
                      },
                      child: Builder(builder: (BuildContext context) {
                        final bool highlight =
                            AutocompleteHighlightedOption.of(context) == index;
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
                              '${option.warpName}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: SizedBox(
                              width: 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      "${option.warpType == "Main Warp" ? option.balanceQty : ""}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 90,
                                    child: Text(
                                      option.balanceMeter!.toStringAsFixed(3),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
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
            } else if (focusNode.hasFocus) {
              controller.text = ' ';
              controller.text = '';
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
            onTap: () {
              controller.text = widget.selectedItem != null
                  ? '${widget.selectedItem?.toString()} '
                  : "";
            },
            textInputAction: widget.textInputAction,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            controller: controller,
            /*controller: controller
              ..text = widget.selectedItem != null
                  ? widget.selectedItem.toString()
                  : '',*/
            style: const TextStyle(fontSize: 14, color: Colors.black),
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
            onTapOutside: (v) {
              _focusNode.nextFocus();
            },
          );
        },
        onSelected: (item) {
          widget.selectedItem = item;
          widget.onChanged(item);
          if (widget.forceNextFocus == true) {
            _focusNode.nextFocus();
          }
          //FocusScope.of(context).nextFocus();
        },
      ),
    );
  }
}
