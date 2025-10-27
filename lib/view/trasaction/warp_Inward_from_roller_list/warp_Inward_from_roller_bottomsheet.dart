import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller_controller.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/weaverAndLoomChange.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/RollerInwardWarpDetails.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_autocompletes/roller_inward_warp_id_drop_down.dart';

class WarpInwardFromRollerBottomSheet extends StatefulWidget {
  const WarpInwardFromRollerBottomSheet({super.key});

  @override
  State<WarpInwardFromRollerBottomSheet> createState() => _State();
}

class _State extends State<WarpInwardFromRollerBottomSheet> {
  Rxn<WarpDesignModel> warpDesign = Rxn<WarpDesignModel>();
  Rxn<RollerInwardWarpDetails> oldWarpId = Rxn<RollerInwardWarpDetails>();
  TextEditingController newWarpIDController = TextEditingController();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController productQtyController = TextEditingController();
  TextEditingController meterController = TextEditingController(text: "0.000");
  TextEditingController wagesController = TextEditingController(text: "0.00");
  TextEditingController warpWeightController =
      TextEditingController(text: "0.000");
  TextEditingController detailsController = TextEditingController();
  TextEditingController usedEmptyController =
      TextEditingController(text: "Beam");
  TextEditingController emptyQtyController = TextEditingController(text: "0");
  TextEditingController sheetController = TextEditingController(text: "0");
  TextEditingController warpColourController = TextEditingController();
  Rxn<NewColorModel> colorname = Rxn<NewColorModel>();

  FocusNode qtyFocus = FocusNode();
  FocusNode wagesFocus = FocusNode();
  FocusNode detailsFocus = FocusNode();
  FocusNode submitButtonFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  RxBool isEnable = RxBool(false);
  WarpInwardFromRollerController controller = Get.find();

  // for backend tracking
  int? weaverId;
  int? subWeaverNo;
  String? warpTrackerId;
  String? warpFor;

  RxBool isVisible = RxBool(false);

  RxString weaverName = RxString("");
  RxString loomNo = RxString("");

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpInwardFromRollerController>(builder: (controller) {
      return ShortCutWidget(
        appBar:
            AppBar(title: const Text('Add Item to Warp Inward From Roller')),
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
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
                      Wrap(
                        children: [
                          MyAutoComplete(
                            label: 'Warp Design',
                            items: controller.warpDesignDropdown,
                            selectedItem: warpDesign.value,
                            enabled: !isUpdate.value,
                            onChanged: (WarpDesignModel item) {
                              controller.warpDesignIdByWarpDetails.clear();
                              clearTeControllers();
                              warpTypeController.text = '${item.warpType}';
                              warpDesign.value = item;
                              controller.warpIdByWarpDetails(
                                  item.warpDesignId, controller.rollerId);
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
                      Wrap(
                        children: [
                          RollerInwardWarpIdDropDown(
                            enabled: !isUpdate.value,
                            label: 'Old Warp Id',
                            selectedItem: oldWarpId.value,
                            items: controller.warpDesignIdByWarpDetails,
                            onChanged: (RollerInwardWarpDetails item) {
                              warpWagesCalculation();
                              oldWarpId.value = item;
                              FocusScope.of(context).requestFocus(qtyFocus);
                              clearTeControllers();
                              warpDetailsDisplay(item);
                            },
                          ),
                          MyTextField(
                            controller: newWarpIDController,
                            hintText: 'New Warp ID',
                            validate: "string",
                            enabled: !isUpdate.value,
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          MyTextField(
                            focusNode: qtyFocus,
                            controller: productQtyController,
                            hintText: 'Product Qty',
                            validate: 'number',
                            suffix: const Text('Saree',
                                style: TextStyle(color: Color(0xFF5700BC))),
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(wagesFocus);
                            },
                          ),
                          Focus(
                              skipTraversal: true,
                              child: MyTextField(
                                controller: meterController,
                                hintText: 'Meter',
                                validate: 'double',
                              ),
                              onFocusChange: (hasFocus) {
                                AppUtils.fractionDigitsText(meterController);
                              }),
                        ],
                      ),
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
                                focusNode: wagesFocus,
                                controller: wagesController,
                                hintText: 'Wages (Rs)',
                                validate: 'double',
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(detailsFocus);
                                },
                              ),
                              onFocusChange: (hasFocus) {
                                AppUtils.fractionDigitsText(
                                  wagesController,
                                  fractionDigits: 2,
                                );
                              }),
                        ],
                      ),
                      Wrap(
                        children: [
                          MyDropdownButtonFormField(
                              controller: usedEmptyController,
                              hintText: "Used Empty",
                              items: const ["Beam", "Bobbin", "Nothing"]),
                          MyTextField(
                            controller: emptyQtyController,
                            hintText: 'Empty Qty',
                            validate: 'number',
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          MyTextField(
                            controller: sheetController,
                            hintText: 'Sheet',
                            validate: 'number',
                          ),
                          MyTextField(
                            focusNode: detailsFocus,
                            controller: detailsController,
                            hintText: 'Details',
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(submitButtonFocus);
                            },
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          MyAutoComplete(
                            label: 'Color Name',
                            items: controller.colorDropdown,
                            isValidate: false,
                            selectedItem: colorname.value,
                            onChanged: (NewColorModel item) {
                              warpColourController.text += '${item.name}, ';
                              colorname.value = item;
                              //  _firmNameFocusNode.requestFocus();
                            },
                          ),
                          MyTextField(
                            controller: warpColourController,
                            hintText: 'Warp Color',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => Visibility(
                          visible: isVisible.value == true,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              minimumSize:
                                  WidgetStateProperty.all(const Size(100, 40)),
                              foregroundColor: WidgetStateProperty.resolveWith(
                                  (states) => Colors.white),
                              shape: WidgetStateProperty.resolveWith((s) =>
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(4.0))),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.focused)) {
                                  return const Color(0xFF5700BC);
                                }
                                return Colors.blue;
                              }),
                            ),
                            onPressed: () async {
                              if (warpTrackerId != null &&
                                  warpTrackerId!.isNotEmpty) {
                                var result = await Get.dialog(
                                    WeaverAndLoomChange(
                                        trackingId: warpTrackerId!));

                                if (result != null) {
                                  weaverId = result["weaver_id"];
                                  subWeaverNo = result["sub_weaver_no"];
                                  weaverName.value = result["weaver_name"];
                                  loomNo.value = result["loom_no"];
                                  warpFor = result["warp_for"];
                                }
                              }
                            },
                            child: const Text(
                              'Weaver Change',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        children: [
                          const Text("Weaver Name:  "),
                          Obx(
                            () => Text(
                              weaverName.value,
                              style: const TextStyle(color: Colors.red),
                            ),
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
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: MyAddButton(
                          focusNode: submitButtonFocus,
                          onPressed: () => submit(),
                        ),
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
      var newWarpId = newWarpIDController.text;

      var exists = _checkWarpIdAlreadyExits(newWarpId);
      if (exists) {
        return AppUtils.infoAlert(message: "This warp id already exists!");
      }

      var request = {
        "warp_design_id": warpDesign.value?.warpDesignId,
        "warp_design_name": warpDesign.value?.warpName,
        "old_warp_id": oldWarpId.value?.oldWarpId,
        "new_warp_id": newWarpIDController.text,
        "qty": int.tryParse(productQtyController.text) ?? 0,
        "length": double.tryParse(meterController.text) ?? 0,
        "wages": double.tryParse(wagesController.text) ?? 0.00,
        "empty_typ": usedEmptyController.text,
        "empty_qty": int.tryParse(emptyQtyController.text) ?? 0,
        "sheet": int.tryParse(sheetController.text) ?? 0,
        "warp_color": warpColourController.text,
        "warp_type": warpTypeController.text,
        "warp_weight": warpWeightController.text,
        "warp_det": detailsController.text,
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

  void _initValue() async {
    WarpInwardFromRollerController controller = Get.find();
    newWarpIDController.text = controller.warpID ?? '';

    if (controller.colorDropdown.isNotEmpty) {
      colorname.value = controller.colorDropdown.first;
    }

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      var wagesStatus = Get.arguments["payment_status"];
      if (wagesStatus == "Paid") {
        isEnable.value = true;
      } else {
        isEnable.value = false;
      }

      detailsController.text = tryCast(item['warp_det']);
      warpTypeController.text = '${item['warp_type']} ';
      productQtyController.text = '${item['qty']}';
      meterController.text = '${item['length']}';
      warpWeightController.text = '${item['warp_weight']}';
      usedEmptyController.text = '${item['empty_typ']}';
      emptyQtyController.text = '${item['empty_qty']}';
      sheetController.text = '${item['sheet']}';
      warpColourController.text = tryCast(item['warp_color']);
      wagesController.text = '${item['wages']}';
      newWarpIDController.text = "${item["new_warp_id"]}";

      warpDesign.value = WarpDesignModel(
        warpDesignId: item["warp_design_id"],
        warpName: item["warp_design_name"],
      );

      oldWarpId.value = RollerInwardWarpDetails(oldWarpId: item["old_warp_id"]);

      weaverId = item["weaver_id"];
      subWeaverNo = item["sub_weaver_no"];
      warpTrackerId = item["warp_tracker_id"];

      if (item["warp_tracker_id"] != null) {
        isVisible.value = true;
      }

      warpFor = item["warp_for"];
      weaverName.value = item["weaver_name"] ?? "";
      loomNo.value = item["loom_no"] ?? "";
    } else if (controller.lastWarp != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        var item = controller.lastWarp;
        var warpDesignList = controller.warpDesignDropdown
            .where((element) =>
                '${element.warpDesignId}' == '${item['warp_design_id']}')
            .toList();
        if (warpDesignList.isNotEmpty) {
          warpDesign.value = warpDesignList.first;
          warpTypeController.text = warpDesignList.first.warpType!;
          controller.warpIdByWarpDetails(
              warpDesign.value?.warpDesignId, controller.rollerId);
        }
      });
    }
  }

  void warpDetailsDisplay(RollerInwardWarpDetails item) {
    productQtyController.text = "${item.qty}";
    meterController.text = item.length!.toStringAsFixed(3);
    warpWeightController.text = item.warpWeight!.toStringAsFixed(3);
    usedEmptyController.text = "${item.emptyType}";
    emptyQtyController.text = "${item.emptyQty}";
    sheetController.text = "${item.sheet}";
    detailsController.text = item.warpDet ?? '';
    warpColourController.text = item.warpColor ?? '';
    warpTrackerId = item.warpTrackerId;

    if (item.warpTrackerId != null) {
      isVisible.value = true;
    }

    weaverId = item.weaverId;
    subWeaverNo = item.subWeaverNo;
    warpFor = item.warpFor;
    weaverName.value = item.weaverName ?? '';
    loomNo.value = item.loomNo ?? '';
  }

  clearTeControllers() {
    productQtyController.text = "0";
    meterController.text = "0.000";
    warpWeightController.text = "0.000";
    emptyQtyController.text = "0";
    sheetController.text = "0";
    detailsController.text = "";
    warpColourController.text = "";
    warpTrackerId = null;
    isVisible.value = false;
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

    if (total >= 6001 && total <= 7999) {
      wagesController.text = "1450.00";
    } else if (total >= 8000) {
      wagesController.text = "1550.00";
    } else if (total >= 3500 && total <= 6000) {
      wagesController.text = "1100.00";
    } else {
      wagesController.text = "0.00";
    }
  }

  weaverChange() {}
}
