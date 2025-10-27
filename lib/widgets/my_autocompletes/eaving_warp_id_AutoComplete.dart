import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../model/weaving_models/WeavingWarpDeliveryModel.dart';

class WeavWarpIdDropDown extends StatefulWidget {
  final Function onChanged;
  final String label;
  final double width;
  final List<WeavingWarpDeliveryModel> items;
  dynamic selectedItem;
  final bool isValidate;
  final bool enabled;
  final TextInputAction textInputAction;
  final bool forceNextFocus;

  WeavWarpIdDropDown({
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
  }) : super(key: key);

  @override
  State<WeavWarpIdDropDown> createState() => _State();
}

class _State extends State<WeavWarpIdDropDown> {
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
      child: Autocomplete<WeavingWarpDeliveryModel>(
        optionsBuilder: (TextEditingValue value) {
          if (value.text == '') {
            widget.selectedItem = null;
            return widget.items;
          }
          if (value.text == '${widget.selectedItem?.toString()} ') {
            return widget.items;
          }
          return widget.items.where((WeavingWarpDeliveryModel option) {
            var details = value.text.toString().toLowerCase();
            var newWarpId = '${option.newWarpId}'.toLowerCase();
            var warpDet = '${option.warpDet}'.toLowerCase();
            var warpColor = '${option.warpColor}'.toLowerCase();
            return newWarpId.contains(details) ||
                warpDet.contains(details) ||
                warpColor.contains(details);
          });
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 400, maxWidth: 710),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final WeavingWarpDeliveryModel option =
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
                              '${option.newWarpId}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: SizedBox(
                              width: 490,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      option.warpDet ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      option.warpColor ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      "${option.meter}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
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
            onTapOutside: (v) {
              _focusNode.nextFocus();
            },
            textInputAction: widget.textInputAction,
            autofocus: true,
            enabled: widget.enabled,
            controller: controller,
            /* ..text = widget.selectedItem != null
                  ? widget.selectedItem.toString()
                  : '',*/
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
            _focusNode.nextFocus();
          }
        },
      ),
    );
  }
}
