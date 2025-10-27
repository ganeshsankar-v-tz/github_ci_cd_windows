import 'package:abtxt/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../model/weaving_models/WeaverLoomDetailsModel.dart';

class WeaverDropDown extends StatefulWidget {
  final Function onChanged;
  final String label;
  final double width;
  final List<WeaverLoomDetailsModel> items;
  dynamic selectedItem;
  final bool isValidate;
  final bool enabled;
  bool forceNextFocus;

  WeaverDropDown({
    Key? key,
    required this.onChanged,
    required this.label,
    this.isValidate = true,
    this.enabled = true,
    this.forceNextFocus = false,
    this.selectedItem,
    this.width = 240,
    required this.items,
  }) : super(key: key);

  @override
  State<WeaverDropDown> createState() => _State();
}

class _State extends State<WeaverDropDown> {
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
        child: Autocomplete<WeaverLoomDetailsModel>(
          /*initialValue: TextEditingValue(
            text: widget.selectedItem != null
                ? widget.selectedItem.toString()
                : "",
          ),*/

          optionsBuilder: (TextEditingValue value) {
            if (value.text == '' || value.text == ' ') {
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
                      const BoxConstraints(maxHeight: 400, maxWidth: 650),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final WeaverLoomDetailsModel option =
                          options.elementAt(index);

                      return InkWell(
                        onTap: () => onSelected(option),
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
                                '${option.ledgerName}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: SizedBox(
                                width: 350,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        "${option.totalLooms != 0 ? option.totalLooms : ''}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        "${option.activeLooms != 0 ? option.activeLooms : ''}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        tryCast(option.city),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        "${option.virtualLoom != 0 ? option.virtualLoom : ""}",
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
          /*optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dynamic option = options.elementAt(index);
                    final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                    return Container(
                      color: highlight ? Colors.green : null,
                      child: InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('$option'),
                        ),
                      ),
                    );
                    return ListTile(
                      tileColor: highlight
                          ? Theme.of(context).focusColor.withOpacity(0.1)
                          : null,
                      title: Text('$option'),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },*/
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
              onTap: () {
                controller.text = widget.selectedItem != null
                    ? '${widget.selectedItem?.toString()} '
                    : "";
              },
              textInputAction: TextInputAction.none,
              autofocus: true,
              enabled: widget.enabled,
              controller: controller,
              /*controller: controller
                ..text = widget.selectedItem != null
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
                  suffixIcon: Icon(Icons.arrow_drop_down)),
              /*suffixIcon: IconButton(
                    focusNode: FocusNode(skipTraversal: true),
                    icon:
                    const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      if (widget.selectedItem != null) {
                        controller.text = '${widget.selectedItem?.toString()}';
                        controller.text = '${widget.selectedItem?.toString()} ';
                      }else{
                        focusNode.requestFocus();
                      }
                    },
                  )),*/
              focusNode: focusNode,
              onTapOutside: (v) {
                focusNode.nextFocus();
                //FocusScope.of(context).enclosingScope;
                //FocusManager.instance.primaryFocus?.nextFocus();
              },
            );
          },
          onSelected: (item) {
            widget.selectedItem = item;
            widget.onChanged(item);
            if (widget.forceNextFocus == true) {
              FocusScope.of(context).nextFocus();
              FocusScope.of(context).nextFocus();
            }
            //FocusScope.of(context).nextFocus();
          },
        ),
      );
    });
  }
}
