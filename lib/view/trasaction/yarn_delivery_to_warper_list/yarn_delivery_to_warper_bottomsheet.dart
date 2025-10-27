import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
import 'package:abtxt/view/basics/yarn/add_yarn.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_warper_list/yarn_delivery_to_warper_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/NewColorModel.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class YarnDeliveryToWarperBottomSheet extends StatefulWidget {
  const YarnDeliveryToWarperBottomSheet({super.key});

  @override
  State<YarnDeliveryToWarperBottomSheet> createState() => _State();
}

class _State extends State<YarnDeliveryToWarperBottomSheet> {
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameTextController = TextEditingController();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController deliveryFromController =
      TextEditingController(text: "Office");
  TextEditingController copsReelController =
      TextEditingController(text: "Nothing");
  TextEditingController bagBoxNoController = TextEditingController();
  TextEditingController packController = TextEditingController(text: '0');
  TextEditingController netQuantityController =
      TextEditingController(text: "0.000");
  TextEditingController stockBalanceController = TextEditingController();

  YarnDeliveryToWarperController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _yarnFocusNode = FocusNode();
  final FocusNode _colorFocusNode = FocusNode();
  final FocusNode _netQtyFocusNode = FocusNode();
  var shortCut = RxString("");

  @override
  void initState() {
    _initState();
    _yarnFocusNode.addListener(() => shortCutKeys());
    _colorFocusNode.addListener(() => shortCutKeys());
    super.initState();
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnDeliveryToWarperController>(builder: (controller) {
      return ShortCutWidget(
        appBar:
            AppBar(title: const Text('Add Item to Yarn Delivery To Warper')),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true):
              NavigateAnotherPageIntent(),
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
            NavigateAnotherPageIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
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
                            enabled: !isUpdate.value,
                            textController: yarnNameTextController,
                            focusNode: _yarnFocusNode,
                            requestFocus: _netQtyFocusNode,
                            onChanged: (YarnModel item) {
                              yarnName.value = item;
                              yarnStockBalanceCheck();
                            },
                          ),
                          Focus(
                            focusNode: _colorFocusNode,
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
                          Wrap(
                            children: [
                              MyDropdownButtonFormField(
                                controller: deliveryFromController,
                                hintText: "Delivery from",
                                items: const ["Office", "Godown"],
                                enabled: !isUpdate.value,
                                onChanged: (value) async {
                                  yarnStockBalanceCheck();
                                },
                              ),
                              MyTextField(
                                controller: stockBalanceController,
                                hintText: 'Stock',
                                readonly: true,
                                enabled: false,
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
                                controller: bagBoxNoController,
                                hintText: 'Bag /Box No',
                                enabled: !isUpdate.value,
                              ),
                              MyDropdownButtonFormField(
                                controller: copsReelController,
                                hintText: 'Cops / Reel Name',
                                items: const ["Nothing", "J.Reel", "M.Reel"],
                                focusNode: _firstInputFocusNode,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MyTextField(
                            controller: packController,
                            hintText: 'Pack',
                          ),
                          Focus(
                              skipTraversal: true,
                              child: MyTextField(
                                focusNode: _netQtyFocusNode,
                                controller: netQuantityController,
                                hintText: 'Net Quantity',
                                validate: 'double',
                                suffix: const Text('Kg',
                                    style: TextStyle(color: Color(0xFF5700BC))),
                              ),
                              onFocusChange: (hasFocus) {
                                AppUtils.fractionDigitsText(
                                    netQuantityController);
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
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
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "yarn_id": yarnName.value?.id,
        "yarn_name": yarnName.value?.name,
        "color_id": colorName.value?.id,
        "color_name": colorName.value?.name,
        "stock_in": deliveryFromController.text,
        "box_no": bagBoxNoController.text,
        "cr_no": copsReelController.text == "Nothing" ? 0 : 1,
        "pck": int.tryParse(packController.text) ?? 0,
        "gross_quantity": 0.0,
        "less_quantity": 0.0,
        "quantity": double.tryParse(netQuantityController.text) ?? 0.0,
      };
      controller.getBackBoolean.value = true;
      Get.back(result: request);
    }
  }

  void _initState() {
    // AUTO SELECT THE FIRST ITEM OF COLOUR.
    if (controller.colorDropdown.isNotEmpty) {
      colorName.value = controller.colorDropdown.first;
    }

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      var stockIn = item["stock_in"];
      bagBoxNoController.text = item['box_no'] ?? '';
      packController.text = tryCast(item['pck']);
      netQuantityController.text = tryCast(item['quantity']);
      deliveryFromController.text = stockIn;
      var yarnNameList = controller.yarnDropdown
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnNameList.isNotEmpty) {
        yarnName.value = yarnNameList.first;
        yarnNameTextController.text = yarnNameList.first.name!;
      }

      var colorNameList = controller.colorDropdown
          .where((element) => '${element.id}' == '${item['color_id']}')
          .toList();
      if (colorNameList.isNotEmpty) {
        colorName.value = colorNameList.first;
      }
    } else if (controller.itemList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        var item = controller.itemList.last;
        var stockIn = item["stock_in"];
        deliveryFromController.text = stockIn;

        var yarnNameList = controller.yarnDropdown
            .where((element) => '${element.id}' == '${item['yarn_id']}')
            .toList();
        if (yarnNameList.isNotEmpty) {
          yarnName.value = yarnNameList.first;
          yarnNameTextController.text = yarnNameList.first.name!;
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

  Future<void> yarnStockBalanceCheck() async {
    /// Yarn Stock Balance Api Call
    var yarnId = yarnName.value?.id;
    var colorId = colorName.value?.id;
    var stockIn = deliveryFromController.text;
    double deliveredQty = 0.0;

    var data = await controller.yarnStockBalance(yarnId, colorId, stockIn);
    double stockQty = double.tryParse("${data?.balanceQty}") ?? 0.0;

    var ll = controller.itemList
        .where((e) => e['yarn_id'] == yarnId && e['color_id'] == colorId)
        .toList();
    for (var element in ll) {
      deliveredQty += element['quantity'];
    }

    var formatter = NumberFormat('#,##,000.000');
    stockBalanceController.text = formatter.format((stockQty - deliveredQty));
  }

  shortCutKeys() {
    if (_yarnFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Yarn',Press Alt+C ";
    } else if (_colorFocusNode.hasFocus) {
      shortCut.value = "To Create 'Color',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  navigateAnotherPage() async {
    if (_yarnFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddYarn.routeName);

      if (result == "success") {
        controller.yarnNameInfo();
      }
    } else if (_colorFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddNewColor.routeName);

      if (result == "success") {
        controller.colorInfo();
      }
    }
  }
}
