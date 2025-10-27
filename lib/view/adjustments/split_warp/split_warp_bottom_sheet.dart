import 'dart:convert';
import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/adjustments/split_warp/split_warp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MultiSelect.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class SplitWarpBottomSheet extends StatefulWidget {
  const SplitWarpBottomSheet({Key? key}) : super(key: key);

  @override
  State<SplitWarpBottomSheet> createState() => _State();
}

class _State extends State<SplitWarpBottomSheet> {
  Rxn<NewWarpModel> newWarpDesignName = Rxn<NewWarpModel>();
  TextEditingController newWarpDesignNameController = TextEditingController();
  TextEditingController warpIdController = TextEditingController();
  // TextEditingController endsController = TextEditingController(text: '0');
  TextEditingController meterController = TextEditingController();
  TextEditingController warpConditionController =
      TextEditingController(text: "Dyed");
  TextEditingController emptyTypeController =
      TextEditingController(text: "Nothing");
  TextEditingController emptyQtyController = TextEditingController();
  TextEditingController sheetController = TextEditingController(text: "0");
  Rxn<NewColorModel> warpColor = Rxn<NewColorModel>();
  var selectedWarpColor = <NewColorModel>[].obs;

  final _formKey = GlobalKey<FormState>();
  late SplitWarpController controller;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplitWarpController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(title: const Text('Add Item (Split Warp - Adjustment)')),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
              submit(),
        },
        loadingStatus: controller.status.isLoading,
        child: SingleChildScrollView(
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: Get.width,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Wrap(
                                  children: [
                                    Row(
                                      children: [
                                        MyDropdownSearch(
                                          label: 'Warp Design',
                                          items: controller.newWarp,
                                          //  isValidate: false,
                                          selectedItem: newWarpDesignName.value,
                                          onChanged: (NewWarpModel item) async {
                                            newWarpDesignNameController.text =
                                                '${item.groupName}';
                                            newWarpDesignName.value = item;
                                            await controller
                                                .warpIdNoDropdown(item.id);
                                          },
                                        ),
                                        MyTextField(
                                            controller: warpIdController,
                                            hintText: 'Warp Id No')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        // MyTextField(
                                        //   controller: endsController,
                                        //   hintText: 'Ends',
                                        // ),
                                        MyTextField(
                                          controller: meterController,
                                          hintText: 'Meter',
                                          validate: 'double',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        MyDropdownButtonFormField(
                                          controller: warpConditionController,
                                          hintText: "Warp Condition",
                                          items: ["Dyed", "Undyed"],
                                        ),
                                        MyDropdownButtonFormField(
                                          controller: emptyTypeController,
                                          hintText: "Empty Type",
                                          items: [
                                            "Nothing",
                                            "Bobbin",
                                            "Sheet",
                                            "Beam"
                                          ],
                                        ),
                                      ],
                                    ),
                                    MyTextField(
                                      controller: emptyQtyController,
                                      hintText: 'Empty Qty',
                                      validate: 'number',
                                    ),
                                    MyTextField(
                                      controller: sheetController,
                                      hintText: 'Sheet',
                                      validate: 'number',
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // const Text(
                                            //   'Warp Color',
                                            //   style: TextStyle(
                                            //       fontWeight: FontWeight.w600,
                                            //       color: Colors.black87),
                                            // ),
                                            Container(
                                              // margin: EdgeInsets.all(7),
                                              width: 240,
                                              child: DropDownMultiSelect(
                                                onChanged: (List<dynamic> x) {
                                                  var json =
                                                      jsonDecode(jsonEncode(x));
                                                  var items = (json as List)
                                                      .map((i) => NewColorModel
                                                          .fromJson(i))
                                                      .toList();
                                                  selectedWarpColor.value =
                                                      items;
                                                },
                                                labelText: 'Warp Color',

                                                options:
                                                    controller.colorDropdown,
                                                selectedValues:
                                                    selectedWarpColor.value,
                                                // validator: (value) =>
                                                //     selectedWarpColor.value.isEmpty
                                                //         ? 'Required'
                                                //         : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyAddButton(
                                    onPressed: () => submit(),
                                  ),
                                 /* MyCloseButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Close'),
                                  ),
                                  const SizedBox(width: 16),*/
                                  /*SizedBox(
                                    child: MyElevatedButton(
                                      onPressed: () => submit(),
                                      child: const Text('ADD'),
                                    ),
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        // "warp_design_no_id": warpDesignController.value?.id,
        "warp_design_name": newWarpDesignName.value?.warpName,
        "warp_design_id": newWarpDesignName.value?.id,
        "warp_id_no": warpIdController.text,
        // "ends": int.tryParse(endsController.text) ?? 0,
        "metre": int.tryParse(meterController.text) ?? 0,
        "wrap_condition": warpConditionController.text,
        "empty_type": emptyTypeController.text,
        "empty_qty": int.tryParse(emptyQtyController.text) ?? 0,
        "sheet": int.tryParse(sheetController.text) ?? 0,
        "wrap_color": selectedWarpColor.value.join(','),
      };
      Get.back(result: request);
    }
  }

  Future<void> _initValue() async {
    SplitWarpController controller = Get.find();
    if (Get.arguments != null) {
      SplitWarpController controller = Get.find();
      var data = Get.arguments['item'];

      var warplist = controller.newWarp
          .where((element) => '${element.id}' == '${data['warp_design_id']}')
          .toList();
      if (warplist.isNotEmpty) {
        newWarpDesignName.value = warplist.first;
      }

      meterController.text = tryCast(data['metre']);
      warpIdController.text = tryCast(data['warp_id_no']);
      warpConditionController.text = tryCast(data['wrap_condition']);
      emptyTypeController.text = tryCast(data['empty_type']);
      emptyQtyController.text = tryCast(data['empty_qty']);
      sheetController.text = tryCast(data['sheet']);
      var warpColorList = controller.colorDropdown
          .where((element) => '${element.id}' == '${data['wrap_color']}')
          .toList();
      if (warpColorList.isNotEmpty) {
        warpColor.value = warpColorList.first;

        //  selectedWarpColor.value.join(',')= '${warpColorList.first.name}';
        // selectedWarpColor.value =
        //     '${warpColorList.first.name}' as List<NewColorModel>;
        selectedWarpColor.addAll(warpColorList);
      }
    }
  }
}
