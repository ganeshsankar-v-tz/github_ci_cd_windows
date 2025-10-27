import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WindingYarnConversationModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/basics/winding_yarn_conversation/add_winding_yarn_conversation.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_winder/yarn_delivery_to_winder_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/new_color/add_new_color.dart';

class YarnDeliveryToWinderBottomSheet extends StatefulWidget {
  const YarnDeliveryToWinderBottomSheet({super.key});

  @override
  State<YarnDeliveryToWinderBottomSheet> createState() => _State();
}

class _State extends State<YarnDeliveryToWinderBottomSheet> {
  Rxn<WindingYarnConversationModel> yarnName =
      Rxn<WindingYarnConversationModel>();
  TextEditingController yarnNameTextController = TextEditingController();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController colorNameController = TextEditingController();
  TextEditingController deliveredFromController = TextEditingController();
  TextEditingController bagBoxNoController = TextEditingController();
  TextEditingController packController = TextEditingController(text: "0");
  TextEditingController stockBalanceController =
      TextEditingController(text: "0");
  TextEditingController netQuantityController =
      TextEditingController(text: "0.000");
  TextEditingController calculateTypeController = TextEditingController();
  TextEditingController wagesRsController = TextEditingController(text: "0.00");
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController returnYarnNameController = TextEditingController();
  TextEditingController returnQuantityController =
      TextEditingController(text: "0.000");
  YarnDeliveryToWinderController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _netQtyFocusNode = FocusNode();
  final FocusNode _colorNameFocusNode = FocusNode();
  var shortCut = RxString("");

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
    return GetBuilder<YarnDeliveryToWinderController>(builder: (controller) {
      return ShortCutWidget(
        appBar:
            AppBar(title: const Text('Add Item to Yarn Delivery To Winder')),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
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
                          MySearchField(
                            label: 'Yarn Name',
                            items: controller.yarnDropdown,
                            textController: yarnNameTextController,
                            focusNode: _yarnNameFocusNode,
                            requestFocus: _netQtyFocusNode,
                            onChanged: (WindingYarnConversationModel item) {
                              yarnName.value = item;
                              returnYarnNameController.text =
                                  '${item.toYarnName}';
                              yarnStockBalanceCheck();
                            },
                          ),
                          Focus(
                            focusNode: _colorNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Color Name',
                              items: controller.colorDropdown,
                              selectedItem: colorName.value,
                              enabled: !isUpdate.value,
                              onChanged: (NewColorModel item) async {
                                colorName.value = item;
                                yarnStockBalanceCheck();
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MyDropdownButtonFormField(
                            controller: deliveredFromController,
                            hintText: "Delivered from",
                            items: Constants.deliveredFrom,
                            enabled: !isUpdate.value,
                            onChanged: (value) async {
                              yarnStockBalanceCheck();
                            },
                          ),
                          MyTextField(
                            controller: bagBoxNoController,
                            hintText: 'Bag /Box No',
                            enabled: !isUpdate.value,
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          MyTextField(
                            controller: packController,
                            hintText: 'Pack',
                            validate: 'number',
                            onChanged: (value) {
                              _sumQuantityRate();
                            },
                          ),
                          MyTextField(
                            enabled: false,
                            controller: stockBalanceController,
                            hintText: 'Stock',
                            readonly: true,
                          ),
                        ],
                      ),
                      Wrap(
                        children: [
                          MyDropdownButtonFormField(
                            controller: calculateTypeController,
                            hintText: "Calculate Type",
                            items: Constants.yarnDeliverCalculateType,
                            onChanged: (value) {
                              _sumQuantityRate();
                            },
                          ),
                          Focus(
                            skipTraversal: true,
                            child: MyTextField(
                              focusNode: _netQtyFocusNode,
                              controller: netQuantityController,
                              hintText: "Net Quantity",
                              validate: "double",
                              onChanged: (value) {
                                _sumQuantityRate();
                              },
                              suffix: Text(
                                yarnName.value?.unitName ?? "Unit",
                                style:
                                    const TextStyle(color: Color(0XFF5700BC)),
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
                                controller: wagesRsController,
                                hintText: 'Wages (Rs)',
                                validate: 'double',
                                onChanged: (value) {
                                  _sumQuantityRate();
                                },
                              ),
                              onFocusChange: (hasFocus) {
                                AppUtils.fractionDigitsText(
                                  wagesRsController,
                                  fractionDigits: 2,
                                );
                              }),
                          MyTextField(
                            controller: amountController,
                            hintText: 'Amount (Rs)',
                            validate: 'double',
                            readonly: true,
                            enabled: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Text(
                            "Excepted",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        children: [
                          MyTextField(
                            controller: returnYarnNameController,
                            hintText: 'Yarn Name',
                            validate: 'string',
                            readonly: true,
                            enabled: false,
                          ),
                          MyTextField(
                            controller: returnQuantityController,
                            hintText: 'Quantity',
                            validate: 'double',
                            readonly: true,
                            enabled: false,
                            suffix: Obx(() => Text(
                                yarnName.value?.unitName ?? "Unit",
                                style:
                                    const TextStyle(color: Color(0xFF5700BC)))),
                          ),
                        ],
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

  shortCutKeys() {
    if (_yarnNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'Yarn Conversions',Press Alt+C ";
    } else if (_colorNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Color',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_yarnNameFocusNode.hasFocus) {
      var result = await Get.toNamed(
        AddWindingYarnConversation.routeName,
      );

      if (result == "success") {
        controller.yarnnameInfo();
      }
    } else if (_colorNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddNewColor.routeName);

      if (result == "success") {
        controller.colorInfo();
      }
    }
  }

  _alertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Alert!',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text('Net Quantity is Greater Than Stock Balance'),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Get.back(result: true);
              },
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text('OK'),
            ),
            OutlinedButton(
              onPressed: () => Get.back(result: false),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red), // Border color
              ),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      var netQuantity = double.tryParse(netQuantityController.text) ?? 0.00;

      if (netQuantity == 0) {
        return AppUtils.infoAlert(message: "Entered net qty is '0'");
      }

      var stock =
          double.tryParse(stockBalanceController.text.replaceAll(",", "")) ??
              0.0;
      var request = {
        "yarn_id": yarnName.value?.fromYarnId,
        "yarn_name": yarnName.value?.fromYarnName,
        "color_id": colorName.value?.id,
        "color_name": colorName.value?.name,
        "stock_in": deliveredFromController.text,
        "box_no": bagBoxNoController.text,
        "pack": int.tryParse(packController.text) ?? 0,
        "quantity": 0.00,
        "less_quanitty": 0.00,
        "gross_quantity": netQuantity,
        "calculate_type": calculateTypeController.text,
        "wages": double.tryParse(wagesRsController.text) ?? 0.00,
        "amount": double.tryParse(amountController.text) ?? 0.0,
        "exp_yarn_id": yarnName.value?.toYarnId,
        "exp_yarn_name": yarnName.value?.toYarnName,
        "exp_quantity": double.tryParse(returnQuantityController.text) ?? 0.0,
        "sync": 0,
      };
      if (netQuantity > stock) {
        var result = await _alertDialog(context);
        if (result == true) {
          Get.back(result: request);
        }
      } else {
        Get.back(result: request);
      }
    }
  }

  void _initValue() {
    YarnDeliveryToWinderController controller = Get.find();

    deliveredFromController.text = Constants.deliveredFrom[0];
    calculateTypeController.text = Constants.yarnDeliverCalculateType[0];
    if (controller.colorDropdown.isNotEmpty) {
      colorName.value = controller.colorDropdown.first;
    }

    if (controller.yarnName.isNotEmpty) {
      yarnNameTextController.text = controller.yarnName;
    }

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];

      deliveredFromController.text = '${item['stock_in']}';
      bagBoxNoController.text = item['bag_box_no'] ?? '';
      packController.text = '${item['pack']}';
      netQuantityController.text = '${item['gross_quantity']}';
      calculateTypeController.text = '${item['calculate_type']}';
      wagesRsController.text = '${item['wages']}';
      amountController.text = '${item['amount']}';
      returnQuantityController.text = '${item['exp_quantity']}';

      var yarnList = controller.yarnDropdown
          .where((element) => '${element.fromYarnId}' == '${item['yarn_id']}')
          .toList();
      if (yarnList.isNotEmpty) {
        yarnName.value = yarnList.first;
        yarnNameTextController.text = '${yarnList.first.fromYarnName}';
        returnYarnNameController.text = '${yarnList.first.toYarnName}';
      }
      var colorList = controller.colorDropdown
          .where((element) => '${element.id}' == '${item['color_id']}')
          .toList();
      if (colorList.isNotEmpty) {
        colorName.value = colorList.first;
        colorNameController.text = '${colorList.first.name}';
      }
    } else if (controller.itemList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        var item = controller.itemList.last;

        deliveredFromController.text = '${item['stock_in']}';

        var yarnList = controller.yarnDropdown
            .where((element) => '${element.fromYarnId}' == '${item['yarn_id']}')
            .toList();
        if (yarnList.isNotEmpty) {
          yarnName.value = yarnList.first;
          returnYarnNameController.text = '${yarnList.first.toYarnName}';
        }
        var colorList = controller.colorDropdown
            .where((element) => '${element.id}' == '${item['color_id']}')
            .toList();
        if (colorList.isNotEmpty) {
          colorName.value = colorList.first;
        }
        yarnStockBalanceCheck();
      });
    }
  }

  void _sumQuantityRate() {
    double netQuantity = double.tryParse(netQuantityController.text) ?? 0.0;
    // double less = double.tryParse(lessController.text) ?? 0.0;
    double wage = double.tryParse(wagesRsController.text) ?? 0.0;
    double pack = double.tryParse(packController.text) ?? 0.0;
    // var netQuantity = quantity - less;
    // netQuantityController.text = '$netQuantity';

    if (yarnName.value != null) {
      WindingYarnConversationModel item = yarnName.value!;
      var fromQty = item.fromQty;
      var toQty = item.toQty;
      var returnQty = (netQuantity / fromQty) * toQty;
      returnQuantityController.text = returnQty.toStringAsFixed(3);
    }

    dynamic amount = 0;
    if (calculateTypeController.text == 'Qty x Wages') {
      amount = netQuantity * wage;
    } else {
      amount = pack * wage;
    }
    amountController.text = amount.toStringAsFixed(2);
  }

  String formatWeight(num weight) {
    final formatter = NumberFormat("#,##0.00");
    return formatter.format(weight);
  }

  Future<void> yarnStockBalanceCheck() async {
    /// Yarn Stock Balance Api Call
    var yarnId = yarnName.value?.fromYarnId;
    var colorId = colorName.value?.id;
    var stockIn = deliveredFromController.text;
    if (yarnId == null || colorId == null || stockIn.isEmpty) {
      return;
    }
    double deliveredQty = 0.0;

    var data = await controller.yarnStockBalance(yarnId, colorId, stockIn);

    double stockQty = double.tryParse("${data?.balanceQty}") ?? 0.0;
    var ll = controller.itemList
        .where((e) => e['yarn_id'] == yarnId && e['color_id'] == colorId)
        .toList();
    for (var element in ll) {
      deliveredQty += element['gross_quantity'];
    }
    var formatter = NumberFormat('#,##,000.000');
    stockBalanceController.text = formatter.format((stockQty - deliveredQty));
  }
}
