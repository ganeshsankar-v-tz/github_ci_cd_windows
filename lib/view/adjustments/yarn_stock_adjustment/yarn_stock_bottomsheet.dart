import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/adjustments/yarn_stock_adjustment/yarn_stock_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/new_color/add_new_color.dart';
import '../../basics/yarn/add_yarn.dart';

class YarnStockBottomSheet extends StatefulWidget {
  const YarnStockBottomSheet({super.key});

  @override
  State<YarnStockBottomSheet> createState() => _State();
}

class _State extends State<YarnStockBottomSheet> {
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> colorname = Rxn<NewColorModel>();
  TextEditingController yarnController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController adjustmentIn = TextEditingController(text: "Office");
  TextEditingController bagContoller = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController packController = TextEditingController(text: "0");
  TextEditingController quantityController =
      TextEditingController(text: "0.000");
  TextEditingController copsreelController =
      TextEditingController(text: 'Nothing');
  TextEditingController adjustmentTypeController =
      TextEditingController(text: 'Shortage');
  TextEditingController stockBalanceController = TextEditingController();

  YarnStockController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _colorNameFocusNode = FocusNode();
  var shortCut = RxString("");

  @override
  void initState() {
    _yarnNameFocusNode.addListener(() => shortCutKeys());
    _colorNameFocusNode.addListener(() => shortCutKeys());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initValue();
    });
    super.initState();
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnStockController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(title: const Text('Add Item (Yarn Stock - Adjustment)')),
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Focus(
                            focusNode: _yarnNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Yarn Name',
                              items: controller.Yarn,
                              selectedItem: yarnName.value,
                              enabled: !isUpdate.value,
                              onChanged: (YarnModel item) {
                                yarnName.value = item;
                                stockController.text = '${item.holderUnit}';
                              },
                            ),
                          ),
                          Focus(
                            focusNode: _colorNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Color Name',
                              items: controller.Color,
                              selectedItem: colorname.value,
                              enabled: !isUpdate.value,
                              onChanged: (NewColorModel item) async {
                                colorname.value = item;

                                yarnStockBalanceCheck();
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MyDropdownButtonFormField(
                            controller: adjustmentIn,
                            hintText: "Adjustments in",
                            items: Constants.stockTo,
                            enabled: !isUpdate.value,
                            onChanged: (value) async {
                              yarnStockBalanceCheck();
                            },
                          ),
                          MyTextField(
                            controller: bagContoller,
                            hintText: "Bag/Box No",
                            enabled: !isUpdate.value,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MyTextField(
                            controller: packController,
                            hintText: "Pack",
                            focusNode: _firstInputFocusNode,
                            validate: "number",
                          ),
                          MyTextField(
                            enabled: false,
                            controller: stockBalanceController,
                            hintText: 'Stock',
                            readonly: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Focus(
                              skipTraversal: true,
                              child: MyTextField(
                                controller: quantityController,
                                hintText: "Quantity",
                                validate: "double",
                              ),
                              onFocusChange: (hasFocus) {
                                AppUtils.fractionDigitsText(quantityController);
                              }),
                          /*MyTextField(
                            enabled: false,
                            controller: copsreelController,
                            hintText: 'Cops/Reel Name',
                            readonly: true,
                          ),*/
                          MyDropdownButtonFormField(
                            controller: copsreelController,
                            hintText: 'Cops/Reel Name',
                            items: const [
                              "Nothing" /*, "J.Reel", "M.Reel"*/
                            ],
                          ),
                        ],
                      ),
                      MyDropdownButtonFormField(
                        controller: adjustmentTypeController,
                        hintText: 'Adjustment Type',
                        items: const ["Shortage", "Excess"],
                      ),
                      const SizedBox(height: 12),
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
      shortCut.value = "To Create 'New Yarn',Press Alt+C ";
    } else if (_colorNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Color',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_yarnNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddYarn.routeName);

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
      int crNo = 0;
      if (copsreelController.text == "Nothing") {
        crNo = 0;
      }
      /*else if (copsreelController.text == "J.Reel"){
        crNo = 1;
      }else if(copsreelController.text == "M.Reel"){
        crNo = 2;
      }*/
      var request = {
        "sync": 0,
        "yarn_id": yarnName.value?.id,
        "yarn_name": yarnName.value?.name,
        "color_id": colorname.value?.id,
        "color_name": colorname.value?.name,
        "stock_in": adjustmentIn.text,
        "cr_no": crNo,
        "box_no": bagContoller.text,
        "typ": adjustmentTypeController.text,
        "pck": int.tryParse(packController.text) ?? 0,
        "quantity": double.tryParse(quantityController.text) ?? 0,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];

      //Yarn Name
      var yarnList = controller.Yarn.where(
          (element) => '${element.id}' == '${item['yarn_id']}').toList();
      if (yarnList.isNotEmpty) {
        yarnName.value = yarnList.first;
        yarnController.text = '${yarnList.first.name}';
      }

      //Color Name
      var colorList = controller.Color.where(
          (element) => '${element.id}' == '${item['color_id']}').toList();
      if (colorList.isNotEmpty) {
        colorname.value = colorList.first;
        colorController.text = '${colorList.first.name}';
      }
      var stockIn = "${item["stock_in"]}";

      bagContoller.text = tryCast(item['box_no']);
      packController.text = '${item['pck']}';
      quantityController.text = '${item['quantity']}';
      adjustmentTypeController.text = '${item['typ']}';
      adjustmentIn.text = stockIn;
      yarnStockBalanceCheck();
    }
  }

  Future<void> yarnStockBalanceCheck() async {
    /// Yarn Stock Balance Api Call
    var yarnId = yarnName.value?.id;
    var colorId = colorname.value?.id;
    var stockIn = adjustmentIn.text;
    double adjustmentQty = 0.0;

    var data = await controller.yarnStockBalance(yarnId, colorId, stockIn);

    double stockQty = double.tryParse("${data?.balanceQty}") ?? 0.0;
    var ll = controller.itemList
        .where((e) => e['yarn_id'] == yarnId && e['color_id'] == colorId)
        .toList();
    for (var element in ll) {
      if (element["sync"] == 0) {
        if (element['typ'] == "Shortage") {
          adjustmentQty -= element['quantity'];
        } else if (element['typ'] == "Excess") {
          adjustmentQty += element['quantity'];
        }
      }
    }

    var formatter = NumberFormat('#,##,000.000');
    stockBalanceController.text = formatter.format((stockQty + adjustmentQty));
  }
}
