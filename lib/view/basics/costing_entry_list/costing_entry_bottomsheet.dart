import 'dart:convert';

import 'package:abtxt/model/NewUnitModel.dart';
import 'package:abtxt/view/basics/costing_entry_list/costing_entry_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keymap/keymap.dart';

import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class CostingEntryBottomSheet extends StatefulWidget {
  const CostingEntryBottomSheet({Key? key}) : super(key: key);

  @override
  State<CostingEntryBottomSheet> createState() => _State();
}

class _State extends State<CostingEntryBottomSheet> {
  TextEditingController header = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  Rxn<NewUnitModel> unit = Rxn<NewUnitModel>();
  TextEditingController unitController = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController rateWages = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController runningTotal = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  FocusNode _rateWagesFocusNode = FocusNode();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CostingEntryController>(builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
            () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
            backgroundColor: Colors.white,
          //backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(title: const Text('Add item to Costing Entry')),
          body: SingleChildScrollView(
            child: Container(

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(

                      decoration: BoxDecoration(
                        // color: Colors.white,
                        border: Border.all(color: Color(0xFFF9F3FF), width: 12),
                      ),
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
                                Container(
                                    child: Wrap(
                                  children: [
                                    Row(
                                      children: [
                                        MyTextField(
                                          controller: header,
                                          hintText: 'Header',
                                          validate: 'string',
                                        ),
                                        MyTextField(
                                          controller: details,
                                          hintText: 'Details',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        MyTextField(
                                          controller: quantityController,
                                          hintText: 'Quantity',
                                          validate: 'double',
                                          onChanged: (value) =>
                                              _sumQuantityRate(),
                                        ),
                                        MyAutoComplete(
                                          label: 'Unit',
                                          items: controller.unitDropdown,
                                          selectedItem: unit.value,
                                          onChanged: (NewUnitModel item) {
                                            unit.value = item;
                                          },
                                        ),
                                      ],
                                    ),
                                    MyTextField(
                                      focusNode: _rateWagesFocusNode,
                                      controller: rateWages,
                                      hintText: 'Rate/Wages (Rs)',
                                      validate: 'double',
                                      onChanged: (value) => _sumQuantityRate(),
                                    ),
                                    MyTextField(
                                      controller: amountController,
                                      hintText: 'Amount (Rs)',
                                      readonly: true,
                                    ),
                                  ],
                                )),
                                const SizedBox(
                                  height: 48,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // MyCloseButton(
                                    //   onPressed: () => Get.back(),
                                    //   child: const Text('Close'),
                                    // ),
                                    // const SizedBox(width: 16),
                                    SizedBox(
                                      width: 200,
                                      child: MyElevatedButton(
                                        onPressed: () => submit(),
                                        child: const Text('ADD'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _sumQuantityRate() {
    double quantity = double.tryParse(quantityController.text) ?? 0;
    double rate = double.tryParse(rateWages.text) ?? 0;
    double amount = 0;
    amount = quantity * rate;
    amountController.text =
        formatAsRupees(double.tryParse(amount.toStringAsFixed(2)) ?? 0);
  }

  String formatAsRupees(double value) {
    var formatter = NumberFormat.currency(locale: 'en_IN', symbol: '');
    return formatter.format(value);
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "header": header.text,
        "details": details.text,
        "quantity": double.tryParse(quantityController.text),
        "unitName": unit.value?.unitName,
        "unit": unit.value?.id,
        "unit_name": unit.value?.unitName,
        "rate": double.tryParse(rateWages.text),
        "amount": double.tryParse(amountController.text.replaceAll(",", "")),
        "running_total": 0
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    CostingEntryController controller = Get.find();
    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      print('SANTHOSH: ${jsonEncode(item)}');
      header.text = "${item["header"]}";
      details.text = item["details"] ?? '';
      quantityController.text = "${item["quantity"]}";
      rateWages.text = "${item["rate"]}";
      amountController.text = "${item["amount"]}";

      var unitList = controller.unitDropdown
          .where((element) => '${element.id}' == '${item['unit']}')
          .toList();
      if (unitList.isNotEmpty) {
        unit.value = unitList.first;
        unitController.text = '${unitList.first.unitName}';
      }
    }
  }
}
