import 'package:abtxt/view/trasaction/yarn_inward_from_winder/yarn_inward_from_winder_controller.dart';
import 'package:abtxt/widgets/my_search_field/WinderInwardDcDropDown.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class WiderItemBottomSheet extends StatefulWidget {
  const WiderItemBottomSheet({super.key});

  @override
  State<WiderItemBottomSheet> createState() => _WiderItemBottomSheetState();
}

class _WiderItemBottomSheetState extends State<WiderItemBottomSheet> {
  Rxn<WinderIdByDcNoModel> dcNumber = Rxn<WinderIdByDcNoModel>();
  TextEditingController entryTypeController =
      TextEditingController(text: "Inward");
  TextEditingController dcNoTextController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  FocusNode firstFocusNode = FocusNode();
  YarnInwardFromWinderController controller = Get.find();

  ///Return
  Rxn<YarnModel> returnYarn = Rxn<YarnModel>();
  TextEditingController returnYarnTextController = TextEditingController();
  Rxn<NewColorModel> returnColor = Rxn<NewColorModel>();
  TextEditingController returnColorTextController = TextEditingController();
  TextEditingController returnStockToController = TextEditingController();
  TextEditingController returnBagBoxNoController = TextEditingController();
  TextEditingController returnPackController = TextEditingController(text: "0");
  TextEditingController returnQtyController = TextEditingController();
  TextEditingController returnLessController = TextEditingController(text: "0");
  TextEditingController returnNetQtyController =
      TextEditingController(text: "0.000");

  final FocusNode returnYarnFocusNode = FocusNode();
  final FocusNode returnColorFocusNode = FocusNode();
  final FocusNode _returnNetQtyFocusNode = FocusNode();

  ///Inward
  Rxn<YarnModel> inwardYarn = Rxn<YarnModel>();
  TextEditingController inwardYarnTextController = TextEditingController();
  Rxn<NewColorModel> inwardColor = Rxn<NewColorModel>();
  TextEditingController inwardColorTextController = TextEditingController();
  TextEditingController inwardStockToController =
      TextEditingController(text: 'Office');
  TextEditingController inwardBagBoxNoController = TextEditingController();
  TextEditingController inwardPackController = TextEditingController(text: "0");
  TextEditingController inwardQtyController = TextEditingController();
  TextEditingController inwardLessController =
      TextEditingController(text: "0.00");
  TextEditingController inwardNetQtyController =
      TextEditingController(text: "0.000");

  final FocusNode inwardYarnFocusNode = FocusNode();
  final FocusNode inwardColorFocusNode = FocusNode();
  final FocusNode _inwardNetQtyFocusNode = FocusNode();

  ///Excess
  Rxn<YarnModel> excessYarn = Rxn<YarnModel>();
  TextEditingController excessYarnTextController = TextEditingController();
  Rxn<NewColorModel> excessColor = Rxn<NewColorModel>();
  TextEditingController excessColorTextController = TextEditingController();
  TextEditingController excessQtyController =
      TextEditingController(text: "0.000");

  final FocusNode excessYarnFocusNode = FocusNode();
  final FocusNode excessColorFocusNode = FocusNode();
  final FocusNode excessQtyFocusNode = FocusNode();

  ///Wastage
  Rxn<YarnModel> wastageYarn = Rxn<YarnModel>();
  TextEditingController wastageYarnTextController = TextEditingController();
  Rxn<NewColorModel> wastageColor = Rxn<NewColorModel>();
  TextEditingController wastageColorTextController = TextEditingController();
  TextEditingController wastageQtyController =
      TextEditingController(text: "0.000");

  final FocusNode wastageYarnFocusNode = FocusNode();
  final FocusNode wastageColorFocusNode = FocusNode();
  final FocusNode wastageQtyFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _selectedEntryType = Constants.ENTRY_TYPES[0].obs;

  /// DC Dropdown request focus usage
  late FocusNode requestFocus;
  final FocusNode dcNoFocusNode = FocusNode();

  @override
  void initState() {
    requestFocus = inwardYarnFocusNode;
    controller.yarn_dropdown.clear();
    controller.color_dropdown.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initValue();
    });
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(firstFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnInwardFromWinderController>(builder: (controller) {
      return ShortCutWidget(
        appBar:
            AppBar(title: const Text('Add Item to Yarn Inward From Winder')),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        MyDropdownButtonFormField(
                          focusNode: firstFocusNode,
                          controller: entryTypeController,
                          hintText: "Entry Type",
                          items: const [
                            "Inward",
                            "Return",
                            "Wastage",
                            "Excess"
                          ],
                          onChanged: (value) {
                            entryTypeController.text = value;
                            _selectedEntryType.value = value;
                            controllerClear();
                            dcNumber.value = null;
                            dcNoTextController.text = "";
                          },
                        ),
                        WinderInwardDcDropDown(
                          autofocus: false,
                          label: 'Dc No',
                          selectedItem: dcNumber.value,
                          items: controller.dcNo,
                          textController: dcNoTextController,
                          focusNode: dcNoFocusNode,
                          requestFocus: requestFocus,
                          searchTextChange: (String query) {
                            dcNumber.value = null;
                          },
                          onChanged: (WinderIdByDcNoModel item) async {
                            dcNumber.value = item;
                            controllerClear();
                            controller.yarn_dropdown.clear();
                            controller.color_dropdown.clear();
                            focusSet();

                            await controller.dcRecNobYYarnColorAndQty(item.id);
                            defaultColorNameSet();
                          },
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Obx(
                        () => Container(
                          child: updateWidget(_selectedEntryType.value),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Align(
                        alignment: Alignment.center,
                        child: MyAddButton(onPressed: () => submit())),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget updateWidget(String option) {
    if (option == 'Inward') {
      return Wrap(
        children: [
          MySearchField(
            label: 'Yarn Name',
            setInitialValue: false,
            items: controller.yarn_dropdown,
            textController: inwardYarnTextController,
            focusNode: inwardYarnFocusNode,
            requestFocus: _inwardNetQtyFocusNode,
            onChanged: (YarnModel item) {
              inwardYarn.value = item;
              finiTheQty(item.id, inwardColor.value?.id);
            },
          ),
          MySearchField(
            label: 'Color Name',
            items: controller.color_dropdown,
            textController: inwardColorTextController,
            focusNode: inwardColorFocusNode,
            requestFocus: _inwardNetQtyFocusNode,
            onChanged: (NewColorModel item) async {
              inwardColor.value = item;
              var yarnId = inwardYarn.value?.id;
              var colorId = item.id;
              finiTheQty(yarnId, colorId);
            },
          ),
          Row(
            children: [
              Wrap(
                children: [
                  MyDropdownButtonFormField(
                    controller: inwardStockToController,
                    hintText: "Stock to",
                    items: const ["Office", "Godown"],
                  ),
                  MyTextField(
                    controller: inwardBagBoxNoController,
                    hintText: 'Bog / Box No',
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
                    controller: inwardPackController,
                    hintText: 'Pack',
                    validate: 'number',
                  ),
                  MyTextField(
                    controller: stockController,
                    hintText: 'Balance',
                    readonly: true,
                    enabled: false,
                  ),
                ],
              ),
            ],
          ),
          Focus(
              skipTraversal: true,
              child: MyTextField(
                focusNode: _inwardNetQtyFocusNode,
                controller: inwardNetQtyController,
                hintText: 'Net Quantity',
                validate: 'double',
              ),
              onFocusChange: (hasFocus) {
                AppUtils.fractionDigitsText(inwardNetQtyController);
              }),
        ],
      );
    } else if (option == 'Return') {
      return Wrap(
        children: [
          MySearchField(
            label: 'Yarn Name',
            items: controller.yarn_dropdown,
            setInitialValue: false,
            textController: returnYarnTextController,
            focusNode: returnYarnFocusNode,
            requestFocus: _returnNetQtyFocusNode,
            onChanged: (YarnModel item) {
              returnYarn.value = item;
            },
          ),
          MySearchField(
            label: 'Color Name',
            items: controller.color_dropdown,
            textController: returnColorTextController,
            focusNode: returnColorFocusNode,
            requestFocus: _returnNetQtyFocusNode,
            onChanged: (NewColorModel item) async {
              returnColor.value = item;
            },
          ),
          Row(
            children: [
              Wrap(
                children: [
                  MyDropdownButtonFormField(
                    controller: returnStockToController,
                    hintText: "Stock to",
                    items: Constants.STOCK_TO,
                  ),
                  MyTextField(
                    controller: returnBagBoxNoController,
                    hintText: 'Bog / Box No',
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
                    controller: returnPackController,
                    hintText: 'Pack',
                    validate: 'number',
                  ),
                  Focus(
                      skipTraversal: true,
                      child: MyTextField(
                        focusNode: _returnNetQtyFocusNode,
                        controller: returnNetQtyController,
                        hintText: 'Net Quantity',
                        validate: 'double',
                      ),
                      onFocusChange: (hasFocus) {
                        AppUtils.fractionDigitsText(returnNetQtyController);
                      }),
                ],
              ),
            ],
          ),
        ],
      );
    } else if (option == 'Wastage') {
      return Wrap(
        children: [
          MySearchField(
            label: 'Yarn Name',
            items: controller.yarn_dropdown,
            setInitialValue: false,
            textController: wastageYarnTextController,
            focusNode: wastageYarnFocusNode,
            requestFocus: wastageQtyFocusNode,
            onChanged: (YarnModel item) {
              wastageYarn.value = item;
              finiTheQty(item.id, wastageColor.value?.id);
            },
          ),
          MySearchField(
            label: 'Color Name',
            items: controller.color_dropdown,
            textController: wastageColorTextController,
            focusNode: wastageColorFocusNode,
            requestFocus: wastageQtyFocusNode,
            onChanged: (NewColorModel item) async {
              wastageColor.value = item;
              var yarnId = wastageYarn.value?.id;
              var colorId = item.id;

              finiTheQty(yarnId, colorId);
            },
          ),
          Row(
            children: [
              Wrap(
                children: [
                  Focus(
                      skipTraversal: true,
                      child: MyTextField(
                        focusNode: wastageQtyFocusNode,
                        controller: wastageQtyController,
                        hintText: 'Quantity',
                        validate: 'double',
                        onChanged: (value) {
                          _sumQuantityRate();
                        },
                      ),
                      onFocusChange: (hasFocus) {
                        AppUtils.fractionDigitsText(wastageQtyController);
                      }),
                  MyTextField(
                    controller: stockController,
                    hintText: 'Balance',
                    readonly: true,
                    enabled: false,
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    } else if (option == 'Excess') {
      return Wrap(
        children: [
          MySearchField(
            label: 'Yarn Name',
            items: controller.yarn_dropdown,
            setInitialValue: false,
            textController: excessYarnTextController,
            focusNode: excessYarnFocusNode,
            requestFocus: excessQtyFocusNode,
            onChanged: (YarnModel item) {
              excessYarn.value = item;
              finiTheQty(item.id, excessColor.value?.id);
            },
          ),
          MySearchField(
            label: 'Color Name',
            items: controller.color_dropdown,
            textController: excessColorTextController,
            focusNode: excessColorFocusNode,
            requestFocus: excessQtyFocusNode,
            onChanged: (NewColorModel item) async {
              excessColor.value = item;
              var yarnId = excessYarn.value?.id;
              var colorId = item.id;

              finiTheQty(yarnId, colorId);
            },
          ),
          Row(
            children: [
              Wrap(
                children: [
                  Focus(
                      skipTraversal: true,
                      child: MyTextField(
                        focusNode: excessQtyFocusNode,
                        controller: excessQtyController,
                        hintText: 'Quantity',
                        validate: 'double',
                        onChanged: (value) {
                          _sumQuantityRate();
                        },
                      ),
                      onFocusChange: (hasFocus) {
                        AppUtils.fractionDigitsText(excessQtyController);
                      }),
                  MyTextField(
                    controller: stockController,
                    hintText: 'Balance',
                    readonly: true,
                    enabled: false,
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      if (dcNumber.value == null) {
        return AppUtils.infoAlert(message: "Select the DC No");
      }

      controller.lastDcNo = dcNumber.value!;

      var request = {
        "entry_type": _selectedEntryType.value,
        "deli_rec_no": dcNumber.value?.id,
        "dc_no": dcNumber.value?.dcNo,
        "sync": 0,
      };
      if (entryTypeController.text == "Excess") {
        request["yarn_id"] = excessYarn.value?.id;
        request["yarn_name"] = excessYarn.value?.name;
        request["color_name"] = excessColor.value?.name;
        request["color_id"] = excessColor.value?.id;
        request["quantity"] = double.tryParse(excessQtyController.text) ?? 0.00;
        request["gross_quantity"] =
            double.tryParse(excessQtyController.text) ?? 0.00;
        request["stock_in"] = "Office";
      } else if (entryTypeController.text == "Wastage") {
        request["yarn_id"] = wastageYarn.value?.id;
        request["yarn_name"] = wastageYarn.value?.name;
        request["color_name"] = wastageColor.value?.name;
        request["color_id"] = wastageColor.value?.id;
        request["quantity"] =
            double.tryParse(wastageQtyController.text) ?? 0.00;
        request["gross_quantity"] =
            double.tryParse(wastageQtyController.text) ?? 0.00;
        request["stock_in"] = "Office";
      } else if (entryTypeController.text == "Inward") {
        double netQty = double.tryParse(inwardNetQtyController.text) ?? 0.00;
        double stockQty = double.tryParse(stockController.text) ?? 0.0;

        if (netQty > stockQty) {
          return AppUtils.infoAlert(
              message: "Entered qty is grater then delivery qty");
        }

        request["yarn_id"] = inwardYarn.value?.id;
        request["yarn_name"] = inwardYarn.value?.name;
        request["color_name"] = inwardColor.value?.name;
        request["color_id"] = inwardColor.value?.id;
        request["stock_in"] = inwardStockToController.text;
        request["bag_box_no"] = inwardBagBoxNoController.text;
        request["pack"] = int.tryParse(inwardPackController.text) ?? 0;
        request["quantity"] = double.tryParse(inwardQtyController.text) ?? 0.00;
        request["less_quanitty"] =
            double.tryParse(inwardLessController.text) ?? 0.00;
        request["gross_quantity"] = netQty;
      } else if (entryTypeController.text == "Return") {
        request["yarn_id"] = returnYarn.value?.id;
        request["yarn_name"] = returnYarn.value?.name;
        request["color_name"] = returnColor.value?.name;
        request["color_id"] = returnColor.value?.id;
        request["stock_in"] = returnStockToController.text;
        request["bag_box_no"] = returnBagBoxNoController.text;
        request["pack"] = int.tryParse(returnPackController.text) ?? 0;
        request["quantity"] = double.tryParse(returnQtyController.text) ?? 0.00;
        request["less_quanitty"] =
            double.tryParse(returnLessController.text) ?? 0.00;
        request["gross_quantity"] =
            double.tryParse(returnNetQtyController.text) ?? 0.00;
      }
      Get.back(result: request);
    }
  }

  void _initValue() async {
    returnStockToController.text = Constants.STOCK_TO[0];
    _selectedEntryType.value = "Inward";
    entryTypeController.text = 'Inward';

    var winderId = controller.request['winder_id'];
    await controller.winderIdByDcNo(winderId);

    if (controller.lastDcNo.dcNo!.isNotEmpty) {
      dcNumber.value = controller.lastDcNo;
      dcNoTextController.text = "${controller.lastDcNo.dcNo}";
    }

    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      _selectedEntryType.value = item["entry_type"];
      entryTypeController.text = item["entry_type"];

      if (entryTypeController.text == "Excess") {
        excessQtyController.text = "${item["quantity"]}";

        /// Excess Yarn
        var yarnList = controller.yarn_dropdown
            .where((element) => '${element.id}' == '${item['yarn_id']}')
            .toList();
        if (yarnList.isNotEmpty) {
          wastageYarn.value = yarnList.first;
        }

        /// Excess Color
        var colorList = controller.color_dropdown
            .where((element) => '${element.id}' == '${item['color_id']}')
            .toList();
        if (colorList.isNotEmpty) {
          excessColor.value = colorList.first;
        }
      } else if (entryTypeController.text == "Wastage") {
        wastageQtyController.text = "${item["gross_quantity"]}";

        /// Wastage Yarn
        var yarnList = controller.yarn_dropdown
            .where((element) => '${element.id}' == '${item['yarn_id']}')
            .toList();
        if (yarnList.isNotEmpty) {
          wastageYarn.value = yarnList.first;
        }

        /// Wastage Color
        var colorList = controller.color_dropdown
            .where((element) => '${element.id}' == '${item['color_id']}')
            .toList();
        if (colorList.isNotEmpty) {
          wastageColor.value = colorList.first;
        }
      } else if (entryTypeController.text == "Inward") {
        inwardStockToController.text = '${item['stock_in']}';
        inwardBagBoxNoController.text = item["bag_box_no"] ?? '';
        inwardPackController.text = "${item["pack"]}";
        inwardQtyController.text = "${item["quantity"]}";
        inwardLessController.text = "${item["less_quanitty"]}";
        inwardNetQtyController.text = "${item["gross_quantity"]}";

        /// Inward Yarn
        var yarnList = controller.yarn_dropdown
            .where((element) => '${element.id}' == '${item['yarn_id']}')
            .toList();
        if (yarnList.isNotEmpty) {
          inwardYarn.value = yarnList.first;
        }

        /// Inward Color
        var colorList = controller.color_dropdown
            .where((element) => '${element.id}' == '${item['color_id']}')
            .toList();
        if (colorList.isNotEmpty) {
          inwardColor.value = colorList.first;
        }
      } else if (entryTypeController.text == "Return") {
        returnStockToController.text = '${item['stock_in']}';
        returnBagBoxNoController.text = item["bag_box_no"] ?? '';
        returnPackController.text = "${item["pack"]}";
        returnQtyController.text = "${item["quantity"]}";
        returnLessController.text = "${item["less_quanitty"]}";
        returnNetQtyController.text = "${item["gross_quantity"]}";

        /// Return Yarn
        var yarnList = controller.yarn_dropdown
            .where((element) => '${element.id}' == '${item['yarn_id']}')
            .toList();
        if (yarnList.isNotEmpty) {
          returnYarn.value = yarnList.first;
        }

        /// Return Color
        var colorList = controller.color_dropdown
            .where((element) => '${element.id}' == '${item['color_id']}')
            .toList();
        if (colorList.isNotEmpty) {
          returnColor.value = colorList.first;
        }
      }
    }
  }

  void controllerClear() {
    /// Stock
    stockController.text = "0";

    /// Inward Controllers
    inwardYarn.value = null;
    inwardYarnTextController.text = "";
    inwardColor.value = null;
    inwardColorTextController.text = "";
    inwardStockToController.text = "Office";
    inwardBagBoxNoController.text = "";
    inwardPackController.text = "0";
    inwardQtyController.text = "0";
    inwardLessController.text = "0.00";
    inwardNetQtyController.text = "0";

    /// Excess Controller
    excessYarn.value = null;
    excessYarnTextController.text = "";
    excessColor.value = null;
    excessColorTextController.text = "";
    excessQtyController.text = "0";

    /// Wastage Controller
    wastageYarn.value = null;
    wastageYarnTextController.text = "";
    wastageColor.value = null;
    wastageColorTextController.text = "";
    wastageQtyController.text = "0";

    /// Return Controller
    returnYarn.value = null;
    returnYarnTextController.text = "";
    returnColor.value = null;
    returnColorTextController.text = "";
    returnStockToController.text = "Office";
    returnBagBoxNoController.text = "";
    returnPackController.text = "0";
    returnQtyController.text = "0";
    returnLessController.text = "0";
    returnNetQtyController.text = "0";
  }

  void _sumQuantityRate() {
    /// inward sum
    // double quantity = double.tryParse(inwardQtyController.text) ?? 0.0;
    // double less = double.tryParse(inwardLessController.text) ?? 0.0;
    // double netQuantity = quantity - less;
    // inwardNetQtyController.text = '$netQuantity';

    /// Return sum
    // double returnQty = double.tryParse(returnQtyController.text) ?? 0.0;
    // double returnLess = double.tryParse(returnLessController.text) ?? 0.0;
    // double returnNetQty = returnQty - returnLess;
    // returnNetQtyController.text = "$returnNetQty";
  }

  void defaultColorNameSet() {
    // AUTO SELECT THE FIRST ITEM OF COLOUR.
    if (controller.color_dropdown.isNotEmpty) {
      // excess
      excessColor.value = controller.color_dropdown.first;
      excessColorTextController.text = controller.color_dropdown.first.name!;
      // inward

      inwardColor.value = controller.color_dropdown.first;
      inwardColorTextController.text = controller.color_dropdown.first.name!;
      // wastage
      wastageColor.value = controller.color_dropdown.first;
      wastageColorTextController.text = controller.color_dropdown.first.name!;
      // return
      returnColor.value = controller.color_dropdown.first;
      returnColorTextController.text = controller.color_dropdown.first.name!;
    }
  }

  /// selected yarn and color id to find the delivered yarn qty
  finiTheQty(int? yarnId, colorId) {
    double deliveryQty = 0;
    var dcNoId = dcNumber.value?.id;
    var dcNo = dcNumber.value?.dcNo;
    if (dcNoId == null || yarnId == null || colorId == null) {
      return;
    }

    // 1. Retrieve the total delivered quantity for the selected
    // yarn ID and color ID from the [deliveredDetails] list in the controller.

    // 2. Retrieved qty used to check the locally added date
    // if Inward, Wastage and Return entry type to minus the qty other wise add

    var list = controller.deliveredDetails.where(
      (element) => element.colorId == colorId && element.yarnId == yarnId,
    );
    deliveryQty = double.tryParse("${list.first.balanceQty}") ?? 0.0;

    var ll = controller.itemList
        .where((e) =>
            e["dc_no"] == dcNo &&
            e['yarn_id'] == yarnId &&
            e['color_id'] == colorId &&
            e["sync"] == 0)
        .toList();
    for (var e in ll) {
      if (e["entry_type"] == "Inward" ||
          e["entry_type"] == "Wastage" ||
          e['entry_type'] == "Return") {
        deliveryQty -= e['gross_quantity'];
      } else if (e["entry_type"] == "Excess") {
        deliveryQty += e["gross_quantity"];
      }
    }

    stockController.text = deliveryQty.toStringAsFixed(3);
  }

  void focusSet() {
    if (entryTypeController.text == "Inward") {
      requestFocus = inwardYarnFocusNode;
    } else if (entryTypeController.text == "Return") {
      requestFocus = returnYarnFocusNode;
    } else if (entryTypeController.text == "Wastage") {
      requestFocus = wastageYarnFocusNode;
    } else {
      requestFocus = excessYarnFocusNode;
    }
  }
}
