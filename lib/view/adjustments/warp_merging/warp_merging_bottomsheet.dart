import 'dart:convert';
import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/adjustments/warp_merging/warp_merging_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';

class WarpMergingBottomSheet extends StatefulWidget {
  const WarpMergingBottomSheet({Key? key}) : super(key: key);

  @override
  State<WarpMergingBottomSheet> createState() => _State();
}

class _State extends State<WarpMergingBottomSheet> {
  Rxn<NewWarpModel> newWarpDesignName = Rxn<NewWarpModel>();
  TextEditingController newWarpDesignNameController = TextEditingController();
  TextEditingController warpIDNoController = TextEditingController();
  TextEditingController endsController = TextEditingController();
  TextEditingController meterController = TextEditingController();
  TextEditingController emptyTypeController = TextEditingController();
  TextEditingController emptyqtyController = TextEditingController(text: "0");
  TextEditingController sheetController = TextEditingController(text: "0");
  TextEditingController warpColorController = TextEditingController();
  Rxn<NewColorModel> warpColor = Rxn<NewColorModel>();
  Rxn<WarpIDByWarpDetails> warpIdNo = Rxn<WarpIDByWarpDetails>();
  var selectedWarpColor = <NewColorModel>[].obs;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpMergingController>(builder: (controller) {
      return CoreWidget(
        appBar:
            AppBar(title: const Text('Add Item (Warp Merging - Adjustment)')),
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
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Row(
                                    children: [
                                      MyAutoComplete(
                                        label: 'Warp Design',
                                        items: controller.newWarp,
                                        //  isValidate: false,
                                        selectedItem: newWarpDesignName.value,
                                        onChanged: (NewWarpModel item) async {
                                          endsController.clear();
                                          warpIdNo.value = null;
                                          newWarpDesignNameController.text =
                                              '${item.groupName}';
                                          newWarpDesignName.value = item;
                                          endsController.text =
                                              tryCast(item.totalEnds);
                                          await controller
                                              .warpDetailsDropdown(item.id);
                                        },
                                      ),
                                      MyAutoComplete(
                                        label: 'Warp Id No',
                                        enabled:
                                            controller.warpDetails.isNotEmpty,
                                        items: controller.warpDetails,
                                        selectedItem: warpIdNo.value,
                                        onChanged:
                                            (WarpIDByWarpDetails item) async {
                                          warpIdNo.value = item;
                                          meterController.clear();
                                          emptyTypeController.clear();
                                          emptyqtyController.clear();
                                          sheetController.clear();
                                          warpColorController.clear();

                                          warpIdDetailsDisplay(item);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyTextField(
                                        controller: endsController,
                                        hintText: 'Ends',
                                        validate: 'number',
                                      ),
                                      MyTextField(
                                        controller: meterController,
                                        hintText: 'Meter',
                                        validate: 'number',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyTextField(
                                        controller: emptyTypeController,
                                        hintText: 'Empty Type',
                                        validate: 'string',
                                      ),
                                      MyTextField(
                                        controller: emptyqtyController,
                                        hintText: 'Empty Qty',
                                        validate: 'string',
                                      ),
                                    ],
                                  ),
                                  MyTextField(
                                    controller: sheetController,
                                    hintText: 'Sheet',
                                    validate: 'number',
                                  ),
                                  MyTextField(
                                    controller: warpColorController,
                                    hintText: 'Warp Color',
                                    validate: 'String',
                                  ),
                                  /*Row(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            // margin: EdgeInsets.all(7),
                                            width: 240,
                                            child: DropDownMultiSelect(
                                              onChanged: (List<dynamic> x) {
                                                var json =
                                                    jsonDecode(jsonEncode(x));
                                                var items = (json as List)
                                                    .map((i) =>
                                                        NewColorModel.fromJson(
                                                            i))
                                                    .toList();
                                                selectedWarpColor.value = items;
                                              },
                                              labelText: 'Warp Color',
                                              options: controller.colorDropdown,
                                              selectedValues:
                                                  selectedWarpColor.value,
                                              validator: (value) =>
                                                  selectedWarpColor
                                                          .value.isEmpty
                                                      ? 'Required'
                                                      : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )*/
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyAddButton(
                                    onPressed: () => submit(),
                                  ),
                                  /*MyCloseButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Close'),
                                  ),
                                  const SizedBox(width: 16),*/
                                 /* SizedBox(
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

  Future<void> warpIdDetailsDisplay(WarpIDByWarpDetails item) async {
    print(jsonEncode(item));
    meterController.text = '${item.metre}';
    emptyTypeController.text = '${item.emptyType}';
    emptyqtyController.text = '${item.emptyQty}';
    warpColorController.text = '${item.warpColor}';
    sheetController.text = '${item.sheet}';
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "warp_design_id": newWarpDesignName.value?.id,
        "warp_design_name": newWarpDesignName.value?.warpName,
        "warp_id_no": warpIdNo.value?.warpId,
        "total_ends": endsController.text,
        "metre": int.tryParse(meterController.text) ?? 0,
        "empty_typ": emptyTypeController.text,
        "empty_qty": int.tryParse(emptyqtyController.text) ?? 0,
        "sheet": int.tryParse(sheetController.text) ?? 0,
        //  "warp_color": selectedWarpColor.value.join(','),
      };
      Get.back(result: request);
    }
  }

  Future<void> _initValue() async {
    WarpMergingController controller = Get.find();
    if (Get.arguments != null) {
      var item = Get.arguments['item'];

      //warpDesign
      var warplist = controller.newWarp
          .where((element) => '${element.id}' == '${item['warp_design_id']}')
          .toList();
      if (warplist.isNotEmpty) {
        newWarpDesignName.value = warplist.first;
        await controller.warpDetailsDropdown(newWarpDesignName.value?.id);
        var warpIdList = controller.warpDetails
            .where((e) => '${e.warpId}' == '${item.warpIdNo}')
            .toList();
        if (warpIdList.isNotEmpty) {
          warpIdNo.value = warpIdList.first;
        }
      }

      //warpID
      // warpIDNoController.text = tryCast(item['warp_id_no']);

      endsController.text = '${item['total_ends']}';
      meterController.text = '${item['metre']}';
      emptyTypeController.text = '${item['empty_typ']}';
      emptyqtyController.text = '${item['empty_qty']}';
      sheetController.text = '${item['sheet']}';
    }
  }
}
