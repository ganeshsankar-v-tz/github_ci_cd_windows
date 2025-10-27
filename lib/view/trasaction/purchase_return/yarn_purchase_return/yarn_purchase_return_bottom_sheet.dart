import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/view/trasaction/purchase_return/yarn_purchase_return/yarn_purchase_return_controller.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../utils/app_utils.dart';
import '../../../../utils/constant.dart';
import '../../../../widgets/MyAddButton.dart';
import '../../../../widgets/MyAutoComplete.dart';
import '../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../widgets/MyTextField.dart';
import '../../../../widgets/flutter_shortcut_widget.dart';

class YarnPurchaseReturnBottomSheet extends StatefulWidget {
  const YarnPurchaseReturnBottomSheet({super.key});

  @override
  State<YarnPurchaseReturnBottomSheet> createState() => _State();
}

class _State extends State<YarnPurchaseReturnBottomSheet> {
  YarnPurchaseReturnController controller = Get.find();
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameTextController = TextEditingController();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();

  TextEditingController stockToController =
      TextEditingController(text: "Office");
  TextEditingController bagController = TextEditingController();
  TextEditingController packController = TextEditingController(text: "0");

  TextEditingController netQuantityController =
      TextEditingController(text: "0.000");
  TextEditingController calculateController =
      TextEditingController(text: 'Qty x Rate');
  TextEditingController rateController = TextEditingController(text: "0");
  TextEditingController amountController = TextEditingController();
  var returnQtyController = TextEditingController(text: "0.00");

  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _colorNameFocusNode = FocusNode();
  final FocusNode _stockToFocusNode = FocusNode();
  final FocusNode _netQtyFocusNode = FocusNode();
  var shortCut = RxString("");

  final _formKey = GlobalKey<FormState>();
  var itemList = <dynamic>[];

  @override
  void initState() {
    _initValue();
    super.initState();
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_stockToFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnPurchaseReturnController>(builder: (controller) {
      return ShortCutWidget(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        appBar: AppBar(title: const Text('Add Item to Yarn Purchase Return')),
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () => Get.back()),
            SaveIntent: SetCounterAction(perform: () => submit()),
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
            ),
            child: SingleChildScrollView(
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
                                label: 'Yarn Name',
                                enabled: false,
                                items: controller.yarnDropdown,
                                textController: yarnNameTextController,
                                focusNode: _yarnNameFocusNode,
                                requestFocus: _netQtyFocusNode,
                                onChanged: (YarnModel item) {
                                  yarnName.value = item;
                                },
                              ),
                              Focus(
                                focusNode: _colorNameFocusNode,
                                skipTraversal: true,
                                child: MyAutoComplete(
                                  enabled: false,
                                  label: 'Color Name',
                                  items: controller.colorDropdown,
                                  selectedItem: colorName.value,
                                  onChanged: (NewColorModel item) {
                                    colorName.value = item;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              MyDropdownButtonFormField(
                                focusNode: _stockToFocusNode,
                                controller: stockToController,
                                hintText: "Stock to",
                                items: const ["Office", "Godown"],
                              ),
                              MyTextField(
                                controller: bagController,
                                hintText: "Bag/Box No",
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              MyTextField(
                                controller: packController,
                                hintText: "Pack",
                                validate: "number",
                                onChanged: (value) {
                                  _sumQuantityRate();
                                },
                              ),
                              Focus(
                                skipTraversal: true,
                                child: MyTextField(
                                  enabled: false,
                                  focusNode: _netQtyFocusNode,
                                  controller: netQuantityController,
                                  hintText: "Net Quantity",
                                  validate: "double",
                                  suffix: const Text(
                                    "Unit",
                                    style: TextStyle(color: Color(0XFF5700BC)),
                                  ),
                                ),
                                onFocusChange: (hasFocus) {
                                  AppUtils.fractionDigitsText(
                                      netQuantityController);
                                },
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    controller: returnQtyController,
                                    hintText: "Return Quantity",
                                    validate: "double",
                                    onChanged: (value) {
                                      _sumQuantityRate();
                                    },
                                    suffix: const Text(
                                      "Unit",
                                      style:
                                          TextStyle(color: Color(0XFF5700BC)),
                                    ),
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                        netQuantityController);
                                  }),
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    enabled: false,
                                    controller: rateController,
                                    hintText: "Rate(Rs)",
                                    validate: "double",
                                    onChanged: (value) {
                                      _sumQuantityRate();
                                    },
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(rateController,
                                        fractionDigits: 2);
                                  }),
                            ],
                          ),
                          Wrap(
                            children: [
                              MyDropdownButtonFormField(
                                controller: calculateController,
                                hintText: "Calculate Type",
                                items: const [
                                  "Qty x Rate",
                                  "Pack x Rate",
                                  "Nothing"
                                ],
                                onChanged: (value) {
                                  _sumQuantityRate();
                                },
                              ),
                              MyTextField(
                                controller: amountController,
                                hintText: "Amount(Rs)",
                                validate: "double",
                                onFieldSubmitted: (value) {
                                  double number = double.tryParse(value) ?? 0;
                                  String formattedValue =
                                      number.toStringAsFixed(2);
                                  amountController.text = formattedValue;
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(shortCut.value,
                              style: AppUtils.shortCutTextStyle()),
                        ),
                        const SizedBox(width: 12),
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
      if (yarnName.value == null) {
        return AppUtils.infoAlert(message: "Select the Yarn name");
      }

      double netQuantity = double.tryParse(netQuantityController.text) ?? 0;
      double returnQty = double.tryParse(returnQtyController.text) ?? 0;

      if (returnQty == 0) {
        return AppUtils.infoAlert(
            message: "Return quantity should be greater than 0");
      }

      if (netQuantity < returnQty) {
        return AppUtils.infoAlert(
            message: "Return quantity should be less than net quantity");
      }

      var request = {
        "yarn_name": yarnName.value?.name,
        "color_name": colorName.value?.name,
        "yarn_id": yarnName.value?.id,
        "color_id": colorName.value?.id,
        "stock_to": stockToController.text,
        "box_no": bagController.text,
        "pack": int.tryParse(packController.text) ?? 0,
        "item_quantity": returnQty,
        "less": 0,
        "net_quantity": returnQty,
        "calculate_type": calculateController.text,
        "rate": double.tryParse(rateController.text) ?? 0,
        "amount": double.tryParse(amountController.text) ?? 0,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      bagController.text = item['box_no'] ?? '';
      packController.text = '${item['pack']}';
      netQuantityController.text = '${item['net_quantity']}';
      rateController.text = '${item['rate']}';
      amountController.text = '${item['amount']}';
      yarnName.value = YarnModel(id: item['yarn_id'], name: item['yarn_name']);
      yarnNameTextController.text = "${item['yarn_name']}";
      colorName.value =
          NewColorModel(id: item['color_id'], name: item['color_name']);

      if (Constants.stockTo.contains(item['stock_to'])) {
        stockToController.text = '${item['stock_to']}';
      }

      if (["Qty x Rate", "Pack x Rate"].contains(item['calculate_type'])) {
        calculateController.text = '${item['calculate_type']}';
      }
    }
  }

  void _sumQuantityRate() {
    double netQuantity = double.tryParse(returnQtyController.text) ?? 0;
    // double less = double.tryParse(lessController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;
    int pack = int.tryParse(packController.text) ?? 0;
    // var netQuantity = quantity - less;
    // netQuantityController.text = '$netQuantity';

    double amount = 0;
    if (calculateController.text == 'Qty x Rate') {
      amount = netQuantity * rate;
    } else if (calculateController.text == "Pack x Rate") {
      amount = pack * rate;
    } else {
      amount = 0;
    }

    amountController.text = amount.toStringAsFixed(3);
  }
}
