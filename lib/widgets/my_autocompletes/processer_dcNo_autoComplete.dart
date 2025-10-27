import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../view/trasaction/product_inward_from_process/product_inward_from_process_controller.dart';

class ProcessorDcNoDropDown extends StatefulWidget {
  final Function onChanged;
  final String label;
  final double width;
  final List<ProcessorIdByDcNoModel> items;
  dynamic selectedItem;
  final bool isValidate;
  final bool enabled;

  ProcessorDcNoDropDown({
    Key? key,
    required this.onChanged,
    required this.label,
    this.isValidate = true,
    this.enabled = true,
    this.selectedItem,
    this.width = 240,
    required this.items,
  }) : super(key: key);

  @override
  State<ProcessorDcNoDropDown> createState() => _State();
}

class _State extends State<ProcessorDcNoDropDown> {
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
        child: Autocomplete<ProcessorIdByDcNoModel>(
          optionsBuilder: (TextEditingValue value) {
            if (value.text == '') {
              widget.selectedItem = null;
              return widget.items;
            }
            if (value.text == '${widget.selectedItem?.toString()} ') {
              return widget.items;
            }
            return widget.items.where((ProcessorIdByDcNoModel option) {
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
                      const BoxConstraints(maxHeight: 400, maxWidth: 400),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ProcessorIdByDcNoModel option =
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
                                '${option.dcNo}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: SizedBox(
                                width: 200,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        "${option.eDate}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        option.firmShortCode ?? '',
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
              textInputAction: TextInputAction.next,
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
          },
        ),
      );
    });
  }
}
