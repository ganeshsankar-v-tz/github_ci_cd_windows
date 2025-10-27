import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/sale_return/yarn_sales_return/yarn_sale_return_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../utils/constant.dart';
import '../../../../widgets/MyAddButton.dart';
import '../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../widgets/MyTextField.dart';
import '../../../../widgets/flutter_shortcut_widget.dart';
import '../../../basics/new_color/add_new_color.dart';
import '../../../basics/yarn/add_yarn.dart';

class YarnSaleReturnBottomSheet extends StatefulWidget {
  const YarnSaleReturnBottomSheet({super.key});

  @override
  State<YarnSaleReturnBottomSheet> createState() => _State();
}

class _State extends State<YarnSaleReturnBottomSheet> {
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController deliveredFromController =
      TextEditingController(text: "Office");
  TextEditingController bagContoller = TextEditingController();
  TextEditingController packController = TextEditingController(text: "0");

  TextEditingController netQuantityController =
      TextEditingController(text: "0");
  TextEditingController calculateController =
      TextEditingController(text: 'Qty x Rate');
  TextEditingController rateController = TextEditingController(text: "0");
  TextEditingController amountController = TextEditingController();
  TextEditingController deliveryQtyController = TextEditingController();
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _colorNameFocusNode = FocusNode();
  var shortCut = RxString("");

  YarnSaleReturnController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    _yarnNameFocusNode.addListener(() => shortCutKeys());
    _colorNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnSaleReturnController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add Item to Yarn Sales')),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
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
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Color(0xFFF9F3FF), width: 12),
                        // ),
                        //color: Colors.white,
                        padding: const EdgeInsets.all(16),
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
                                      Focus(
                                        focusNode: _yarnNameFocusNode,
                                        skipTraversal: true,
                                        child: MyAutoComplete(
                                          label: 'Yarn Name',
                                          items: controller.yarnNameDropdown,
                                          selectedItem: yarnName.value,
                                          enabled: false,
                                          onChanged: (YarnModel item) {
                                            yarnName.value = item;
                                          },
                                        ),
                                      ),
                                      Focus(
                                        focusNode: _colorNameFocusNode,
                                        skipTraversal: true,
                                        child: MyAutoComplete(
                                          label: 'Color Name',
                                          items: controller.colorNameDropdown,
                                          selectedItem: colorName.value,
                                          enabled: false,
                                          onChanged:
                                              (NewColorModel item) async {
                                            colorName.value = item;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      MyDropdownButtonFormField(
                                        controller: deliveredFromController,
                                        hintText: "Delivered from",
                                        items: Constants.stockTo,
                                        enabled: !isUpdate.value,
                                      ),
                                      MyTextField(
                                        controller: bagContoller,
                                        hintText: "Bag/Box No",
                                        enabled: !isUpdate.value,
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
                                      MyTextField(
                                        enabled: false,
                                        controller: deliveryQtyController,
                                        hintText: 'Stock',
                                        readonly: true,
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      Obx(
                                        () => Focus(
                                            skipTraversal: true,
                                            child: MyTextField(
                                              controller: netQuantityController,
                                              hintText: "Net Quantity",
                                              validate: "double",
                                              onChanged: (value) {
                                                _sumQuantityRate();
                                              },
                                              suffix: Text(
                                                yarnName.value?.unitName ??
                                                    "Unit",
                                                style: const TextStyle(
                                                    color: Color(0XFF5700BC)),
                                              ),
                                            ),
                                            onFocusChange: (hasFocus) {
                                              AppUtils.fractionDigitsText(
                                                  netQuantityController);
                                            }),
                                      ),
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
                                            AppUtils.fractionDigitsText(
                                                rateController,
                                                fractionDigits: 2);
                                          }),
                                      /*MyTextField(
                                        controller: rateController,
                                        hintText: "Rate(Rs)",
                                        validate: "double",
                                        onChanged: (value) {
                                          _sumQuantityRate();
                                        },
                                      ),*/
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      MyDropdownButtonFormField(
                                        controller: calculateController,
                                        hintText: "Calculate Type",
                                        enabled: false,
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
                                        readonly: true,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
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
                    Flexible(
                        flex: 1, child: Container(color: Colors.grey[400])),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  shortCutKeys() {
    if (_yarnNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Yarn',Press Alt+C ";
    } else if (_colorNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Color',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_yarnNameFocusNode.hasFocus) {
      var result = await Get.toNamed(
        AddYarn.routeName,
      );

      if (result == "success") {
        controller.YarnInfo();
      }
    } else if (_colorNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddNewColor.routeName);

      if (result == "success") {
        controller.ColorInfo();
      }
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      double netQuantity = double.tryParse(netQuantityController.text) ?? 0;
      double deliveryQty =
          double.tryParse(deliveryQtyController.text) ?? 0;

      if (netQuantity <= 0) {
        AppUtils.infoAlert(message: "Net Quantity must be greater than 0");
        return;
      }

      if(netQuantity > deliveryQty) {
        AppUtils.infoAlert(message: "Net Quantity must be less than or equal to Stock");
        return;
      }


      var request = {
        "yarn_name": yarnName.value?.name,
        "color_name": colorName.value?.name,
        "yarn_id": yarnName.value?.id,
        "color_id": colorName.value?.id,
        "stock_to": deliveredFromController.text,
        "box_no": bagContoller.text,
        "pack": int.tryParse(packController.text) ?? 0,
        "quantity": double.tryParse(netQuantityController.text) ?? 0,
        "less_quantity": 0,
        "net_quantity": double.tryParse(netQuantityController.text) ?? 0,
        "calculate_type": calculateController.text,
        "rate": rateController.text,
        "amount": double.tryParse(amountController.text) ?? 0,
      };

      Get.back(result: request);
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      bagContoller.text = item['box_no'] ?? '';
      packController.text = '${item['pack']}';

      deliveryQtyController.text = tryCast(item['gross_quantity']);
      netQuantityController.text = tryCast(item['gross_quantity']);
      rateController.text = '${item['rate']}';
      amountController.text = '${item['amount']}';

      yarnName.value = YarnModel(id: item["yarn_id"], name: item["yarn_name"]);

      colorName.value =
          NewColorModel(id: item["color_id"], name: item["color_name"]);

      if (Constants.stockTo.contains(item['delivered_from'])) {
        deliveredFromController.text = '${item['delivered_from']}';
      }

      if (["Qty x Rate", "Pack x Rate"].contains(item['calculate_type'])) {
        calculateController.text = '${item['calculate_type']}';
      }
    }
  }

  void _sumQuantityRate() {
    double netQuantity = double.tryParse(netQuantityController.text) ?? 0;
    // double less = double.tryParse(lessController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;
    int pack = int.tryParse(packController.text) ?? 0;
    // var netQuantity = quantity - less;
    // netQuantityController.text = '$netQuantity';

    double amount = 0;
    if (calculateController.text == 'Qty x Rate') {
      amount = netQuantity * rate;
    } else if (calculateController.text == 'Pack x Rate') {
      amount = pack * rate;
    } else {
      amount = 0;
    }
    amountController.text = amount.toStringAsFixed(3);
  }
}
