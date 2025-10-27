import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../model/RollerInwardWarpDetails.dart';

class RollerInwardWarpIdDropDown extends StatefulWidget {
  final Function onChanged;
  final String label;
  final double width;
  final List<RollerInwardWarpDetails> items;
  dynamic selectedItem;
  final bool isValidate;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final bool forceNextFocus;

  RollerInwardWarpIdDropDown({
    Key? key,
    required this.onChanged,
    required this.label,
    this.isValidate = true,
    this.enabled = true,
    this.selectedItem,
    this.width = 240,
    required this.items,
    this.autofocus = true,
    this.textInputAction = TextInputAction.next,
    this.forceNextFocus = false,
  }) : super(key: key);

  @override
  State<RollerInwardWarpIdDropDown> createState() => _State();
}

class _State extends State<RollerInwardWarpIdDropDown> {
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
        child: Autocomplete<RollerInwardWarpDetails>(
          optionsBuilder: (TextEditingValue value) {
            if (value.text == '') {
              widget.selectedItem = null;
              return widget.items;
            }
            if (value.text == '${widget.selectedItem?.toString()} ') {
              return widget.items;
            }
            return widget.items.where((RollerInwardWarpDetails option) {
              var item = value.text.toString().toLowerCase();
              var warpId = '${option.oldWarpId}'.toLowerCase();
              var meter = '${option.length}'.toLowerCase();
              return warpId.contains(item) || meter.contains(item);
            });
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 400, maxWidth: 300),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final RollerInwardWarpDetails option =
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
                                '${option.oldWarpId}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: SizedBox(
                                width: 130,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        "${option.length}",
                                        style: const TextStyle(fontSize: 14),
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
            focusNode.addListener(() {
              if (focusNode.hasFocus && widget.selectedItem != null) {
                controller.text = '${widget.selectedItem?.toString()} ';
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
