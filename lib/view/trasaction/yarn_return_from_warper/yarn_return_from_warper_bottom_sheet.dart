import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/view/trasaction/yarn_return_from_warper/yarn_return_from_warper_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class YarnReturnFromWarperBottomSheet extends StatefulWidget {
  const YarnReturnFromWarperBottomSheet({super.key});

  @override
  State<YarnReturnFromWarperBottomSheet> createState() => _State();
}

class _State extends State<YarnReturnFromWarperBottomSheet> {
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController packController = TextEditingController(text: '0');
  TextEditingController netQuantityController =
      TextEditingController(text: "0.000");
  TextEditingController lessController = TextEditingController(text: '0');
  TextEditingController quantityController = TextEditingController();
  TextEditingController bagBoxNoController = TextEditingController();
  TextEditingController copsreelController =
      TextEditingController(text: "Nothing");
  TextEditingController stockController = TextEditingController(text: "Office");

  TextEditingController balanceController = TextEditingController();

  var selectedWarpColor = <NewColorModel>[].obs;
  YarnReturnFromWarperController controller = Get.find();

  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _yarnFocusNode = FocusNode();
  final FocusNode _colorFocusNode = FocusNode();
  final FocusNode _netQtyFocusNode = FocusNode();

  @override
  void initState() {
    _initValue();
    super.initState();
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnReturnFromWarperController>(builder: (controller) {
      return ShortCutWidget(
        appBar:
            AppBar(title: const Text('Add Item to Yarn Return From Warper')),
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
                        Wrap(
                          children: [
                            Focus(
                              focusNode: _yarnFocusNode,
                              skipTraversal: true,
                              child: MyAutoComplete(
                                label: 'Yarn Name',
                                items: controller.yarnName,
                                selectedItem: yarnName.value,
                                enabled: !isUpdate.value,
                                onChanged: (YarnModel item) {
                                  yarnName.value = item;
                                },
                              ),
                            ),
                            Focus(
                              focusNode: _colorFocusNode,
                              skipTraversal: true,
                              child: MyAutoComplete(
                                label: 'Color Name',
                                items: controller.colorName,
                                selectedItem: colorName.value,
                                enabled: !isUpdate.value,
                                onChanged: (NewColorModel item) async {
                                  colorName.value = item;

                                  /// Warp Stock Balance Api Call
                                  var yarnId = yarnName.value?.id;
                                  var colorId = colorName.value?.id;
                                  finiTheQty(yarnId, colorId);

                                  FocusScope.of(context)
                                      .requestFocus(_netQtyFocusNode);
                                },
                              ),
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
                              controller: stockController,
                              hintText: "Stock in",
                              items: const ["Office", "Godown"],
                              enabled: !isUpdate.value,
                              onChanged: (value) async {},
                            ),
                            MyTextField(
                              controller: balanceController,
                              hintText: 'Balance',
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
                              hintText: 'Bag / Box No',
                              enabled: !isUpdate.value,
                            ),
                            MyDropdownButtonFormField(
                              controller: copsreelController,
                              hintText: 'Cops / Reel Name',
                              items: const ["Nothing", "J.Reel", "M.Reel"],
                              focusNode: _firstInputFocusNode,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Wrap(
                    //       children: [
                    //         MyTextField(
                    //           controller: quantityController,
                    //           hintText: 'Quantity',
                    //           validate: 'double',
                    //           onChanged: (value) {
                    //             _sumQuantityRate();
                    //           },
                    //         ),
                    //         MyTextField(
                    //           controller: lessController,
                    //           hintText: 'Less (-)',
                    //           validate: 'double',
                    //           onChanged: (value) {
                    //             _sumQuantityRate();
                    //           },
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
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
                            ),
                            onFocusChange: (hasFocus) {
                              AppUtils.fractionDigitsText(
                                  netQuantityController);
                            }),
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
        "stock_in": stockController.text,
        "box_no": bagBoxNoController.text,
        "cr_no": copsreelController.text == "Nothing" ? 0 : 1,
        "pck": int.tryParse(packController.text) ?? 0,
        "gross_quantity": double.tryParse(quantityController.text) ?? 0.0,
        "less_quantity": double.tryParse(lessController.text) ?? 0,
        "quantity": double.tryParse(netQuantityController.text) ?? 0,
        "sync": 0,
        // "balance": balanceController.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];

      stockController.text = '${item['stock_in']}';
      bagBoxNoController.text = item['box_no'] ?? '';
      packController.text = '${item['pck']}';
      quantityController.text = '${item['gross_quantity']}';
      lessController.text = '${item['less_quantity']}';
      netQuantityController.text = '${item['quantity']}';

      var yarnNameList = controller.yarnName
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnNameList.isNotEmpty) {
        yarnName.value = yarnNameList.first;
      }

      var colorNameList = controller.colorName
          .where((element) => '${element.id}' == '${item['color_id']}')
          .toList();
      if (colorNameList.isNotEmpty) {
        colorName.value = colorNameList.first;
      }

      finiTheQty(yarnName.value?.id, colorName.value?.id);
    }
  }

  finiTheQty(int? yarnId, colorId) {
    double deliveryQty = 0;

    if (yarnId == null || colorId == null) {
      return;
    }

    var list = controller.deliveredDetails.where(
      (element) => element.colorId == colorId && element.yarnId == yarnId,
    );
    deliveryQty = double.tryParse("${list.first.balQuantity}") ?? 0.0;

    var ll = controller.itemList
        .where((e) =>
            e['yarn_id'] == yarnId &&
            e['color_id'] == colorId &&
            e["sync"] == 0)
        .toList();

    for (var e in ll) {
      deliveryQty -= e["quantity"];
    }
    balanceController.text = deliveryQty.toStringAsFixed(3);
  }
}
