import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_dyer/warp_Inward_from_dyer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/WarpInwardWarpDetailsModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class WarpInwardFromDyerBottomSheet extends StatefulWidget {
  const WarpInwardFromDyerBottomSheet({super.key});

  @override
  State<WarpInwardFromDyerBottomSheet> createState() => _State();
}

class _State extends State<WarpInwardFromDyerBottomSheet> {
  Rxn<WarpDesignModel> warpDesign = Rxn<WarpDesignModel>();
  Rxn<WarpInwardWarpDetailsModel> oldWarpIdBydDetails =
      Rxn<WarpInwardWarpDetailsModel>();
  TextEditingController newWarpIdIdController = TextEditingController();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController productQtyController = TextEditingController(text: "0");
  TextEditingController meterController = TextEditingController(text: "0.000");
  TextEditingController wagesRsController = TextEditingController(text: "0.00");
  TextEditingController warpWeightController =
      TextEditingController(text: "0.000");
  TextEditingController colourController = TextEditingController();
  TextEditingController warpColourController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  Rxn<NewColorModel> colorname = Rxn<NewColorModel>();

  final FocusNode _wagesFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  RxBool isEnable = RxBool(false);
  WarpInwardFromDyerController controller = Get.find();

  // for backend tracking
  int? weaverId;
  int? subWeaverNo;
  String? warpTrackerId;
  String? warpFor;

  RxString weaverName = RxString("");
  RxString loomNo = RxString("");

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpInwardFromDyerController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add Item to Warp Inward From Dyer')),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyAutoComplete(
                                label: 'Warp Designs',
                                items: controller.warpDesignDropDown,
                                selectedItem: warpDesign.value,
                                enabled: !isUpdate.value,
                                onChanged: (WarpDesignModel item) {
                                  warpDesign.value = item;
                                  controller.designIdByWarpDetails.clear();
                                  oldWarpIdBydDetails.value = null;
                                  clearTheControllers();
                                  warpTypeController.text = '${item.warpType}';
                                  var id = item.warpDesignId;
                                  controller.warpDesignIdDetails(
                                      id, controller.dyerId);
                                },
                              ),
                              MyTextField(
                                controller: warpTypeController,
                                hintText: 'Warp Type',
                                readonly: true,
                                enabled: !isUpdate.value,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyAutoComplete(
                                enabled: !isUpdate.value,
                                label: 'Old Warp Id',
                                items: controller.designIdByWarpDetails,
                                selectedItem: oldWarpIdBydDetails.value,
                                onChanged: (WarpInwardWarpDetailsModel item) {
                                  warpWagesCalculation();
                                  FocusScope.of(context)
                                      .requestFocus(_wagesFocusNode);
                                  clearTheControllers();
                                  oldWarpIdBydDetails.value = item;
                                  warpDetailsDisplay(item);
                                },
                              ),
                              MyTextField(
                                controller: newWarpIdIdController,
                                hintText: 'New Warp ID',
                                validate: "string",
                                enabled: !isUpdate.value,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyTextField(
                                controller: productQtyController,
                                hintText: 'Product Qty',
                                validate: 'number',
                                suffix: const Text('Saree',
                                    style: TextStyle(color: Color(0xFF5700BC))),
                              ),
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    controller: meterController,
                                    hintText: 'Meter',
                                    validate: 'double',
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                        meterController);
                                  }),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    controller: warpWeightController,
                                    hintText: 'Warp Weight',
                                    validate: 'double',
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                        warpWeightController);
                                  }),
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    enabled: !isEnable.value,
                                    focusNode: _wagesFocusNode,
                                    controller: wagesRsController,
                                    hintText: 'Wages (Rs)',
                                    validate: 'double',
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context)
                                          .requestFocus(_detailsFocusNode);
                                    },
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                      wagesRsController,
                                      fractionDigits: 2,
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyAutoComplete(
                                isValidate: false,
                                label: 'Color Name',
                                items: controller.colorDropdown,
                                selectedItem: colorname.value,
                                onChanged: (NewColorModel item) {
                                  colorname.value = item;
                                  warpColourController.text += '${item.name}, ';
                                },
                              ),
                              MyTextField(
                                controller: warpColourController,
                                hintText: 'Warp Color',
                              ),
                            ],
                          ),
                        ],
                      ),
                      MyTextField(
                        focusNode: _detailsFocusNode,
                        controller: detailsController,
                        hintText: "Details",
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        children: [
                          const Text("Weaver Name:  "),
                          Obx(
                            () => Text(weaverName.value,
                                style: const TextStyle(color: Colors.red)),
                          ),
                          const SizedBox(width: 10),
                          const Text("Loom No:  "),
                          Obx(
                            () => Text(loomNo.value,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyAddButton(onPressed: () => submit()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var newWarpId = newWarpIdIdController.text;

      var exists = _checkWarpIdAlreadyExits(newWarpId);
      if (exists) {
        return AppUtils.infoAlert(message: "This warp id already exists!");
      }

      var request = {
        "warp_design_id": warpDesign.value?.warpDesignId,
        "warp_design_name": warpDesign.value?.warpName,
        "old_warp_id": oldWarpIdBydDetails.value?.warpId,
        "new_warp_id": newWarpIdIdController.text,
        "warp_type": warpTypeController.text,
        "qty": int.tryParse(productQtyController.text) ?? 0,
        "length": double.tryParse(meterController.text) ?? 0.0,
        "wages": double.tryParse(wagesRsController.text) ?? 0.0,
        "warp_color": warpColourController.text,
        "design_name": warpDesign.value?.warpName,
        "warp_det": detailsController.text,
        "warp_weight": double.tryParse(warpWeightController.text) ?? 0.00,
        "sync": 0,
        "weaver_id": weaverId,
        "sub_weaver_no": subWeaverNo,
        "warp_tracker_id": warpTrackerId,
        "warp_for": warpFor,
        "weaver_name": weaverName.value,
        "loom_no": loomNo.value,
      };
      controller.getBackBoolean.value = true;
      Get.back(result: request);
    }
  }

  _checkWarpIdAlreadyExits(newWarpId) {
    if (Get.arguments == null) {
      var exists = controller.itemList
          .any((element) => element['new_warp_id'] == newWarpId);
      return exists;
    } else {
      return false;
    }
  }

  void _initValue() {
    WarpInwardFromDyerController controller = Get.find();
    controller.designIdByWarpDetails.clear();

    // AUTO SELECT THE FIRST ITEM OF COLOUR.
    if (controller.colorDropdown.isNotEmpty) {
      colorname.value = controller.colorDropdown.first;
    }

    newWarpIdIdController.text = controller.warpID ?? '';

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      var wagesStatus = Get.arguments["payment_status"];
      if (wagesStatus == "Paid") {
        isEnable.value = true;
      } else {
        isEnable.value = false;
      }

      newWarpIdIdController.text = '${item['new_warp_id']}';
      productQtyController.text = '${item['qty']}';
      meterController.text = '${item['length']}';
      wagesRsController.text = '${item['wages']}';
      warpColourController.text = tryCast(item['warp_color']);
      warpWeightController.text = '${item['warp_weight']}';
      detailsController.text = '${item['warp_det']}';
      warpTypeController.text = item['warp_type'] ?? '';
      warpDesign.value = WarpDesignModel(
          warpDesignId: item['warp_design_id'],
          warpName: item["warp_design_name"]);
      oldWarpIdBydDetails.value =
          WarpInwardWarpDetailsModel(warpId: item["old_warp_id"]);
      weaverId = item["weaver_id"];
      subWeaverNo = item["sub_weaver_no"];
      warpTrackerId = item["warp_tracker_id"];
      warpFor = item["warp_for"];
      weaverName.value = item["weaver_name"] ?? "";
      loomNo.value = item["loom_no"] ?? "";
    } else if (controller.lastWarp != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        var item = controller.lastWarp;

        var warpDesignList = controller.warpDesignDropDown
            .where((element) =>
                '${element.warpDesignId}' == '${item['warp_design_id']}')
            .toList();

        if (warpDesignList.isNotEmpty) {
          warpDesign.value = warpDesignList.first;
          warpTypeController.text = warpDesignList.first.warpType ?? '';
          await controller.warpDesignIdDetails(
              warpDesign.value?.warpDesignId, controller.dyerId);
        }
      });
    }
  }

  void warpDetailsDisplay(WarpInwardWarpDetailsModel item) {
    productQtyController.text = "${item.productQty}";
    meterController.text = item.metre!.toStringAsFixed(3);
    warpWeightController.text = item.warpWeight!.toStringAsFixed(3);
    warpColourController.text = item.warpColor ?? '';
    detailsController.text = item.warpDet ?? '';
    warpTrackerId = item.warpTrackerId;
    weaverId = item.weaverId;
    subWeaverNo = item.subWeaverNo;
    warpFor = item.warpFor;
    weaverName.value = item.weaverName ?? '';
    loomNo.value = item.loomNo ?? '';
  }

  clearTheControllers() {
    productQtyController.text = "0";
    meterController.text = "0.000";
    warpWeightController.text = "0.000";
    warpColourController.text = "";
    detailsController.text = "";
    warpTrackerId = null;
    warpFor = null;
    subWeaverNo = null;
    weaverId = null;
    weaverName.value = "";
    loomNo.value = "";
  }

  void warpWagesCalculation() {
    var nums = warpDesign.value?.warpName?.split("+");
    int total = 0;
    for (String num in nums!) {
      var value = num.replaceAll(RegExp(r'[^0-9]'), '');

      total += int.tryParse(value) ?? 0;
    }

    if (total >= 6000 && total <= 7999) {
      wagesRsController.text = "1600.00";
    } else if (total >= 8000) {
      wagesRsController.text = "1650.00";
    } else {
      wagesRsController.text = "400.00";
    }
  }
}
