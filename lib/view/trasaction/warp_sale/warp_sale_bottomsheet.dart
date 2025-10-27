import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/model/WarpSaleWarpIdModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_sale/warp_sale_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyAddButton.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class WarpSaleBottomSheet extends StatefulWidget {
  const WarpSaleBottomSheet({super.key});

  @override
  State<WarpSaleBottomSheet> createState() => _State();
}

class _State extends State<WarpSaleBottomSheet> {
  WarpSaleController controller = Get.find();

  Rxn<WarpDesignModel> warpDesignController = Rxn<WarpDesignModel>();
  TextEditingController warpDesignTextController = TextEditingController();
  TextEditingController warpTypeController = TextEditingController();
  Rxn<WarpSaleWarpIdModel> warpIdController = Rxn<WarpSaleWarpIdModel>();
  TextEditingController warpIdTextController = TextEditingController();
  TextEditingController productQytController = TextEditingController(text: "0");
  TextEditingController meterController = TextEditingController(text: "0.000");
  TextEditingController usedEmptyController =
      TextEditingController(text: "Beam");
  TextEditingController emptyQtyController = TextEditingController(text: "0");
  TextEditingController sheetController = TextEditingController(text: "0");
  TextEditingController warpColorController = TextEditingController();
  TextEditingController warpWeightController =
      TextEditingController(text: "0.00");
  TextEditingController rateController = TextEditingController(text: "0.00");
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController detailsController = TextEditingController();

  final FocusNode _warpDesignFocusNode = FocusNode();
  final FocusNode _warpIdFocusNode = FocusNode();
  final FocusNode _rateFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller.warpIdDetails.clear();

    if (controller.warpName.isNotEmpty) {
      warpDesignTextController.text = controller.warpName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpSaleController>(builder: (controller) {
      return ShortCutWidget(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
        appBar: AppBar(title: const Text('Add Item to Warp Sale')),
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
            ),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              MySearchField(
                                label: "Warp Design",
                                items: controller.designSheetDropdown,
                                textController: warpDesignTextController,
                                focusNode: _warpDesignFocusNode,
                                requestFocus: _warpIdFocusNode,
                                onChanged: (WarpDesignModel item) {
                                  warpDesignController.value = item;
                                  warpTypeController.text = "${item.warpType}";
                                  warpIdTextController.text = "";
                                  warpIdController.value = null;
                                  controllersClear();
                                  controller
                                      .warpIdDetailsApi(item.warpDesignId);
                                },
                              ),
                              MyTextField(
                                controller: warpTypeController,
                                hintText: "Warp Type",
                                enabled: false,
                              )
                            ],
                          ),
                          Wrap(
                            children: [
                              MySearchField(
                                  label: "Warp Id",
                                  items: controller.warpIdDetails,
                                  textController: warpIdTextController,
                                  focusNode: _warpIdFocusNode,
                                  requestFocus: _rateFocusNode,
                                  onChanged: (WarpSaleWarpIdModel item) {
                                    warpIdController.value = item;
                                    warpIdDetailsDisplay(item);
                                  }),
                              MyTextField(
                                controller: productQytController,
                                hintText: "Product Qty",
                                validate: "number",
                              )
                            ],
                          ),
                          Wrap(
                            children: [
                              MyTextField(
                                controller: meterController,
                                hintText: "Meter",
                                validate: "double",
                              ),
                              MyDropdownButtonFormField(
                                controller: usedEmptyController,
                                hintText: "Used Empty",
                                items: const ["Beam", "Bobbin", "Nothing"],
                                onChanged: (value) {
                                  if (value == "Nothing") {
                                    emptyQtyController.text = "0";
                                  }
                                },
                              )
                            ],
                          ),
                          Wrap(
                            children: [
                              MyTextField(
                                controller: emptyQtyController,
                                hintText: "Empty Qty",
                                validate: "number",
                              ),
                              MyTextField(
                                controller: sheetController,
                                hintText: "Sheet",
                                validate: "number",
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              MyTextField(
                                controller: warpColorController,
                                hintText: "Warp Color",
                              ),
                              MyTextField(
                                controller: warpWeightController,
                                hintText: "Warp Weight",
                                enabled: false,
                                // validate: "double",
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              Focus(
                                skipTraversal: true,
                                child: MyTextField(
                                  controller: rateController,
                                  focusNode: _rateFocusNode,
                                  hintText: "Rate",
                                  validate: "double",
                                  onChanged: (value) => amountCollection(),
                                ),
                              ),
                              MyTextField(
                                controller: amountController,
                                hintText: "Amount",
                                enabled: false,
                                // validate: "double",
                              ),
                            ],
                          ),
                          MyTextField(
                            focusNode: _detailsFocusNode,
                            controller: detailsController,
                            hintText: "Details",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyAddButton(
                          onPressed: () => submit(),
                        ),
                      ],
                    ),
                  ],
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
      if (warpDesignController.value == null) {
        return AppUtils.infoAlert(message: "Select the Warp Design");
      }

      var request = {
        "warp_design_id": warpDesignController.value?.warpDesignId,
        "warp_design_name": warpDesignController.value?.warpName,
        "warp_type": warpTypeController.text,
        "warp_id": warpIdController.value?.newWarpId,
        "product_qty": int.tryParse(productQytController.text) ?? 0,
        "meter": double.tryParse(meterController.text) ?? 0.0,
        "empty_type": usedEmptyController.text,
        "empty_qty": int.tryParse(emptyQtyController.text) ?? 0,
        "sheet": int.tryParse(sheetController.text) ?? 0,
        "warp_color": warpColorController.text,
        "details": detailsController.text,
        "warp_weight": double.tryParse(warpWeightController.text) ?? 0.0,
        "amount": double.tryParse(amountController.text) ?? 0.0,
        "rate": double.tryParse(rateController.text) ?? 0.0,
      };
      Get.back(result: request);
    }
  }

  void warpIdDetailsDisplay(WarpSaleWarpIdModel item) {
    productQytController.text = "${item.qty}";
    meterController.text = "${item.meter}";
    sheetController.text = "${item.sheet}";
    warpColorController.text = item.warpColor ?? "";
    detailsController.text = item.warpDet ?? "";
    warpWeightController.text = "${item.warpWeight}";

    setState(() {
      if (item.bobbin != 0) {
        usedEmptyController.text = "Bobbin";
        emptyQtyController.text = "${item.bobbin}";
      } else if (item.beam != 0) {
        usedEmptyController.text = "Beam";
        emptyQtyController.text = "${item.beam}";
      } else {
        usedEmptyController.text = "Nothing";
        emptyQtyController.text = "0";
      }
    });
  }

  controllersClear() {
    productQytController.text = "0";
    meterController.text = "0.00";
    sheetController.text = "0";
    warpColorController.text = "";
    detailsController.text = "";
    usedEmptyController.text = "Beam";
    emptyQtyController.text = "0";
    warpWeightController.text = "0.00";
    amountController.text = "0.00";
    rateController.text = "0.00";
  }

  amountCollection() {
    double rate = double.tryParse(rateController.text) ?? 0.0;
    double weight = double.tryParse(warpWeightController.text) ?? 0.0;
    double amount = rate * weight;
    amountController.text = amount.toStringAsFixed(2);
  }
}
