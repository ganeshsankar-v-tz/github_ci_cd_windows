import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class MyNewMultiSelectDropdown extends StatefulWidget {
  final Function(List<Object>) onChanged;
  final String label;
  final double width;
  final List<Object> items;
  final List<Object> selectedItems;
  final bool isValidate;
  final bool enabled;
  TextInputAction textInputAction;
  bool forceNextFocus;

  MyNewMultiSelectDropdown({
    Key? key,
    required this.onChanged,
    required this.label,
    this.isValidate = true,
    this.enabled = true,
    this.forceNextFocus = false,
    this.selectedItems = const [],
    this.textInputAction = TextInputAction.next,
    this.width = 240,
    required this.items,
  }) : super(key: key);

  @override
  State<MyNewMultiSelectDropdown> createState() => _State();
}

class _State extends State<MyNewMultiSelectDropdown> {
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
        child: Autocomplete<Object>(
          optionsBuilder: (TextEditingValue value) {
            if (!widget.enabled) {
              return [];
            }
            if (value.text == '') {
              return widget.items;
            }
            if (widget.selectedItems.isNotEmpty) {
              return widget.items.where((Object option) {
                return option
                    .toString()
                    .toLowerCase()
                    .contains(value.text.toLowerCase());
              });
            }
            return widget.items.where((Object option) {
              return option
                  .toString()
                  .toLowerCase()
                  .contains(value.text.toLowerCase());
            });
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints:
                  BoxConstraints(maxHeight: 400, maxWidth: widget.width),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final dynamic option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          if (widget.selectedItems.contains(option)) {
                            widget.selectedItems.remove(option);
                          } else {
                            widget.selectedItems.add(option);
                          }
                          widget.onChanged(widget.selectedItems);
                          // _focusNode.nextFocus();
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
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: widget.selectedItems.contains(option),
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      widget.selectedItems.add(option);
                                    } else {
                                      widget.selectedItems.remove(option);
                                    }
                                    widget.onChanged(widget.selectedItems);
                                  },
                                ),
                                Text('$option'),
                              ],
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
              if (focusNode.hasFocus) {
                controller.text = widget.selectedItems.join(', ');
                controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.text.length,
                );
              }
            });

            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.text = widget.selectedItems.join(', ');
            });

            return TextFormField(
              onFieldSubmitted: (value) {
                onFieldSubmitted();
              },
              textInputAction: widget.textInputAction,
              enabled: widget.enabled,
              controller: controller,
              style: const TextStyle(fontSize: 14),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (item) {
                if (widget.isValidate == false) {
                  return null;
                }
                if (widget.selectedItems.isEmpty) {
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
                  suffixIcon: Icon(Icons.arrow_drop_down)),
              focusNode: focusNode,
              onTapOutside: (v) {
                _focusNode.nextFocus();
              },
            );
          },
          onSelected: (item) {},
        ),
      );
    });
  }
}
