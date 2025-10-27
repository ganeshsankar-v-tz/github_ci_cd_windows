import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../model/LoomGroup.dart';

class MyLoomAutoComplete extends StatefulWidget {
  final Function onChanged;
  final String label;
  final TextInputAction? textInputAction;
  final double width;
  final List<LoomGroup> items;
  dynamic selectedItem;
  final bool isValidate;
  final bool enabled;
  bool forceNextFocus;

  MyLoomAutoComplete({
    super.key,
    required this.onChanged,
    required this.label,
    this.textInputAction = TextInputAction.none,
    this.isValidate = true,
    this.enabled = true,
    this.selectedItem,
    this.width = 240,
    required this.items,
    this.forceNextFocus = false,
  });

  @override
  State<MyLoomAutoComplete> createState() => _State();
}

class _State extends State<MyLoomAutoComplete> {
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
      child: Autocomplete<LoomGroup>(
        optionsBuilder: (TextEditingValue value) {
          if (value.text == '') {
            widget.selectedItem = null;
            return widget.items;
          }
          if (value.text == '${widget.selectedItem?.toString()} ') {
            return widget.items;
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
                    const BoxConstraints(maxHeight: 400, maxWidth: 450),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final LoomGroup option = options.elementAt(index);
                    var newDD =
                        option.looms.where((f) => f.currentStatus == 'New');
                    var runningDD = option.looms
                        .where((f) => f.currentStatus == 'Running');
                    var completedDD = option.looms
                        .where((f) => f.currentStatus == 'Completed');

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
                          //padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Text('${option.loomNo}'),
                            trailing: SizedBox(
                              width: 300,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child:
                                        Text(newDD.isNotEmpty ? 'NEW' : ''),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Text(runningDD.isNotEmpty
                                        ? 'RUNNING'
                                        : ''),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Text(completedDD.isNotEmpty
                                        ? 'COMPLETED'
                                        : ''),
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
            }
            if (focusNode.hasFocus && widget.selectedItem == null) {
              controller.text = ' ';
              controller.text = '';
            }
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.text = widget.selectedItem != null
                ? '${widget.selectedItem?.toString()} '
                : "";

            if (widget.selectedItem != null) {
              controller.text = '${widget.selectedItem?.toString()} ';
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
            }
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
        },
      ),
    );
  }
}
