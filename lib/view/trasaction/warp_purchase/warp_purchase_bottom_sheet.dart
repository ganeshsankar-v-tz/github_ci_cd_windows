import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_purchase/warp_purchase_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/LoomModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class AddWarpPurchaseBottomSheet extends StatefulWidget {
  const AddWarpPurchaseBottomSheet({super.key});

  @override
  State<AddWarpPurchaseBottomSheet> createState() => _State();
}

class _State extends State<AddWarpPurchaseBottomSheet> {
  TextEditingController orderController = TextEditingController(text: "No");
  TextEditingController warpIdController = TextEditingController();
  Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController warpConditionController =
      TextEditingController(text: "Dyed");
  TextEditingController productQuantityController =
      TextEditingController(text: "0");
  TextEditingController meterController = TextEditingController(text: "0.000");
  TextEditingController usedEmptyController = TextEditingController();
  TextEditingController emptyQytController = TextEditingController(text: "0");
  TextEditingController sheetController = TextEditingController(text: "0");
  TextEditingController calculateTypeController =
      TextEditingController(text: "Direct Amount");
  TextEditingController weightController = TextEditingController(text: "0.000");
  TextEditingController rateController = TextEditingController(text: "0.00");
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController warpColourController = TextEditingController();
  Rxn<NewColorModel> colorname = Rxn<NewColorModel>();
  TextEditingController warpForController =
      TextEditingController(text: "Weaving");
  Rxn<LedgerModel> weaverNameController = Rxn<LedgerModel>();
  TextEditingController weaverNameTextController = TextEditingController();
  Rxn<LoomModel> loomNoController = Rxn<LoomModel>();
  TextEditingController loomNoTextController = TextEditingController();

  final FocusNode _weaverFocusNode = FocusNode();
  final FocusNode _loomFocusNode = FocusNode();
  final FocusNode _submitFocusNode = FocusNode();

  RxBool warpFor = RxBool(true);

  /// this key used to disable the field after the dyer oy roller delivery
  RxBool isDelivered = RxBool(false);

  final _formKey = GlobalKey<FormState>();
  late WarpPurchaseController controller;
  RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpPurchaseController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add Item (Warp Purchase)')),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
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
                    border:
                        Border.all(color: const Color(0xFFF9F3FF), width: 16)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyDropdownButtonFormField(
                                controller: orderController,
                                hintText: "Order",
                                items: const ['No'],
                                enabled: !isUpdate.value,
                              ),
                              MyTextField(
                                controller: warpIdController,
                                hintText: 'Warp ID',
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
                              MyAutoComplete(
                                label: 'Warp Design',
                                items: controller.warpDesignDropdown,
                                selectedItem: warpDesign.value,
                                enabled: !isUpdate.value,
                                onChanged: (NewWarpModel item) {
                                  warpTypeController.text = '${item.warpType}';
                                  warpDesign.value = item;
                                },
                              ),
                              MyTextField(
                                controller: warpTypeController,
                                hintText: 'WarpType',
                                readonly: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyDropdownButtonFormField(
                                enabled: !isDelivered.value,
                                controller: warpConditionController,
                                hintText: "Warp Condition",
                                items: const ["Dyed", "UnDyed"],
                              ),
                              MyTextField(
                                  enabled: !isUpdate.value,
                                  controller: productQuantityController,
                                  hintText: 'Product Qty',
                                  validate: 'number',
                                  onChanged: (val) {
                                    amountCalculation();
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
                                      controller: meterController,
                                      hintText: 'Meter',
                                      validate: 'double',
                                      enabled: !isUpdate.value,
                                      onChanged: (val) {
                                        amountCalculation();
                                      }),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                        meterController);
                                  }),
                              MyDropdownButtonFormField(
                                controller: usedEmptyController,
                                hintText: "Used Empty",
                                items: Constants.usedEmpty,
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
                                controller: emptyQytController,
                                hintText: 'Empty Qty',
                                validate: 'number',
                                enabled: !isUpdate.value,
                              ),
                              MyTextField(
                                controller: sheetController,
                                hintText: 'Sheet',
                                validate: 'number',
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
                              MyDropdownButtonFormField(
                                  controller: calculateTypeController,
                                  hintText: "Calculate Type",
                                  items: const [
                                    "Direct Amount",
                                    "Weight x Rate",
                                    "Prod Qty x Rate",
                                    "Length x Rate",
                                  ],
                                  onChanged: (value) {
                                    amountCalculation();
                                  }),
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                      controller: weightController,
                                      enabled: !isDelivered.value,
                                      hintText: 'Weight',
                                      validate: 'double',
                                      onChanged: (val) {
                                        amountCalculation();
                                      }),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                        weightController);
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
                                      controller: rateController,
                                      hintText: 'Rate (Rs)',
                                      validate: 'double',
                                      onChanged: (val) {
                                        amountCalculation();
                                      }),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                      rateController,
                                      fractionDigits: 2,
                                    );
                                  }),
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    controller: amountController,
                                    hintText: 'Amount (Rs)',
                                    validate: 'double',
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                      amountController,
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
                                label: 'Color Name',
                                items: controller.colorDropdown,
                                isValidate: false,
                                enabled: !isDelivered.value,
                                selectedItem: colorname.value,
                                onChanged: (NewColorModel item) {
                                  colorname.value = item;
                                  warpColourController.text += '${item.name}, ';
                                  //  _firmNameFocusNode.requestFocus();
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
                      MyDropdownButtonFormField(
                        controller: warpForController,
                        hintText: "Warp For",
                        items: const ["Weaving", "Sale"],
                        onChanged: (value) {
                          warpFor.value = value == "Weaving" ? true : false;
                        },
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Visibility(
                              visible: warpFor.value == true,
                              child: MySearchField(
                                setInitialValue: warpFor.value,
                                label: "Weaver Name",
                                items: controller.weaverDropdown,
                                textController: weaverNameTextController,
                                focusNode: _weaverFocusNode,
                                requestFocus: _loomFocusNode,
                                onChanged: (LedgerModel item) {
                                  controller.loomInfo(item.id);
                                  weaverNameController.value = item;
                                  loomNoTextController.text = "";
                                  loomNoController.value = null;
                                },
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: warpFor.value == true,
                              child: MySearchField(
                                label: "Loom No",
                                setInitialValue: warpFor.value,
                                items: controller.loomList,
                                textController: loomNoTextController,
                                focusNode: _loomFocusNode,
                                requestFocus: _submitFocusNode,
                                onChanged: (LoomModel item) {
                                  loomNoController.value = item;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          child: MyAddButton(
                              focusNode: _submitFocusNode,
                              onPressed: () => submit()),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      double meter = double.tryParse(meterController.text) ?? 0.0;
      int emptyQty = int.tryParse(emptyQytController.text) ?? 0;
      int productQty = int.tryParse(productQuantityController.text) ?? 0;

      if (warpTypeController.text == "Main Warp") {
        if (productQty == 0) {
          return AppUtils.infoAlert(message: "Enter the product qty");
        }
        if (usedEmptyController.text != "Nothing" && emptyQty == 0) {
          return AppUtils.infoAlert(message: "Enter the empty qty");
        }
      } else {
        if (meter == 0) {
          return AppUtils.infoAlert(message: "Enter the meter");
        }

        if (usedEmptyController.text != "Nothing" && emptyQty == 0) {
          return AppUtils.infoAlert(message: "Enter the empty qty");
        }
      }

      if (warpForController.text == "Weaving") {
        if (weaverNameController.value == null) {
          return AppUtils.infoAlert(message: "Select the Weaver Name");
        }
        if (loomNoController.value == null) {
          return AppUtils.infoAlert(message: "Select the Loom No");
        }
      }

      var orderNo = "";
      if (orderController.text == "No") {
        orderNo = "0";
      } else {
        orderNo = "1";
      }
      var request = {
        "order_rec_no": int.tryParse(orderNo),
        "warp_design_id": warpDesign.value?.id,
        "warp_design_name": warpDesign.value?.warpName,
        "warp_type": warpDesign.value?.warpType,
        "wrap_condition": warpConditionController.text,
        "qty": int.tryParse(productQuantityController.text) ?? 0,
        "metre": double.tryParse(meterController.text) ?? 0.0,
        "empty_type": usedEmptyController.text,
        "empty_qty": int.tryParse(emptyQytController.text) ?? 0,
        "sheet": int.tryParse(sheetController.text) ?? 0,
        "calculate_type": calculateTypeController.text,
        "weight": double.tryParse(weightController.text) ?? 0.0,
        "rate": double.tryParse(rateController.text) ?? 0.0,
        "amount": double.tryParse(amountController.text) ?? 0.0,
        "warp_color": warpColourController.text,
        "warp_id": warpIdController.text,
        "warp_for": warpForController.text,
        "sync": 0,
      };

      if (warpForController.text == "Weaving") {
        request["weaver_id"] = weaverNameController.value?.id;
        request["weaver_name"] = weaverNameController.value?.ledgerName;
        request["sub_weaver_no"] = loomNoController.value?.id;
        request["loom_no"] = loomNoController.value?.subWeaverNo;
      } else {
        request["weaver_id"] = 0;
        request["sub_weaver_no"] = 0;
      }

      if (Get.arguments != null) {
        var item = Get.arguments['item'];

        if (item["sync"] != 0) {
          // API call for row update

          request["sync"] = 1;
          int id = item["id"];
          int warpPurchaseId = item["wrap_purchase_id"];
          String warpTrackerId = item["warp_tracker_id"] ?? "";
          request["id"] = id;
          request["wrap_purchase_id"] = warpPurchaseId;
          request["warp_tracker_id"] = warpTrackerId;
          controller.isChanged = true;

          var result = await controller.selectedRowUpdate(request);
          if (result["status"] == "success") {
            Get.back(result: request);
          }
        } else {
          Get.back(result: request);
        }
      } else {
        Get.back(result: request);
      }
    }
  }

  void _initValue() async {
    WarpPurchaseController controller = Get.find();
    usedEmptyController.text = Constants.usedEmpty[0];

    // AUTO SELECT THE FIRST ITEM OF COLOUR.
    if (controller.colorDropdown.isNotEmpty) {
      colorname.value = controller.colorDropdown.first;
    }

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];

      if (item["warp_delivery"] == 1) {
        isDelivered.value = true;
      }

      var order = "";
      if (item["order_rec_no"] == 0) {
        order = "No";
      } else {
        order = "Yes";
      }
      orderController.text = order;
      warpIdController.text = tryCast(item['warp_id']);
      warpConditionController.text = '${item['wrap_condition']}';
      productQuantityController.text = '${item['qty']}';
      meterController.text = '${item['metre']}';
      usedEmptyController.text = '${item['empty_type']}';
      emptyQytController.text = '${item['empty_qty']}';
      sheetController.text = '${item['sheet']}';
      calculateTypeController.text = '${item['calculate_type']}';
      weightController.text = '${item['weight']}';
      rateController.text = '${item['rate']}';
      amountController.text = '${item['amount']}';
      warpColourController.text = '${item['warp_color'] ?? ""}';

      var warpDesignList = controller.warpDesignDropdown
          .where((element) => '${element.id}' == '${item['warp_design_id']}')
          .toList();
      if (warpDesignList.isNotEmpty) {
        warpDesign.value = warpDesignList.first;
        warpTypeController.text = '${warpDesignList.first.warpType}';
      }
      warpForController.text = "${item["warp_for"] ?? "Weaving"}";
      warpFor.value = item["warp_for"] == "Weaving" ? true : false;
      if (warpForController.text == "Weaving") {
        weaverNameController.value = LedgerModel(
            id: item["weaver_id"] ?? 0, ledgerName: item["weaver_name"]);
        weaverNameTextController.text = "${item["weaver_name"]}";

        loomNoController.value =
            LoomModel(id: item["sub_weaver_no"], subWeaverNo: item["loom_no"]);
        loomNoTextController.text = "${item["loom_no"]}";
      }

      // loom details API call
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (item["weaver_id"] != null && item["weaver_id"] != 0) {
          controller.loomInfo(item["weaver_id"]);
        }
      });
    } else if (controller.lastWarp != null) {
      var item = controller.lastWarp;
      var warpDesignList = controller.warpDesignDropdown
          .where((element) => '${element.id}' == '${item['warp_design_id']}')
          .toList();
      if (warpDesignList.isNotEmpty) {
        warpDesign.value = warpDesignList.first;
        warpTypeController.text = '${warpDesignList.first.warpType}';
      }
      rateController.text = "${item["rate"]}";
      warpIdController.text = controller.warpID ?? '';
    } else {
      warpIdController.text = controller.warpID ?? '';
    }
  }

  void amountCalculation() {
    double weight = double.tryParse(weightController.text) ?? 0.00;
    double meter = double.tryParse(meterController.text) ?? 0.00;
    double rate = double.tryParse(rateController.text) ?? 0.00;
    int productQty = int.tryParse(productQuantityController.text) ?? 0;
    double amount = 0.00;

    if (calculateTypeController.text == "Weight x Rate") {
      amount = weight * rate;
    } else if (calculateTypeController.text == "Prod Qty x Rate") {
      amount = productQty * rate;
    } else if (calculateTypeController.text == "Length x Rate") {
      amount = meter * rate;
    } else {
      amount = 0.00;
    }
    amountController.text = amount.toStringAsFixed(2);
  }
}
