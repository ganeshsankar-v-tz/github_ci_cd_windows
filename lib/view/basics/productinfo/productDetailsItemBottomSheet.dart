

import 'dart:convert';

import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/basics/productinfo/product_info_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class productDetailsItemBottomSheet extends StatefulWidget {
  const productDetailsItemBottomSheet({Key? key}) : super(key: key);

  @override
  State<productDetailsItemBottomSheet> createState() => _State();
}

class _State extends State<productDetailsItemBottomSheet> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController workName = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController unitController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductInfoController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text(
            'Add Item (Product List)',
          ),
        ),
        loadingStatus: controller.status.isLoading,
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ,control: true): GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS,control: true): SaveIntent(),
        },
        child:Actions(
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Wrap(
                              children: [
                                MyTextField(
                                  controller: productNameController,
                                  hintText: "Product Name",
                                  validate: 'String',
                                ),
                                MyTextField(
                                  controller: designNoController,
                                  hintText: "Design No",
                                  validate: 'String',
                                ),
                                MyTextField(
                                  controller: workName,
                                  hintText: 'Work Name',
                                  validate: 'String',
                                ),
                                MyTextField(
                                  controller: quantity,
                                  hintText: 'Quantity',
                                  validate: 'number',
                                ),
                                MyDropdownButtonFormField(
                                  controller: unitController,
                                  hintText: "Unit",
                                  items: Constants.productInfoUnits,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /*MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                const SizedBox(width: 16),*/
                                MyAddButton(
                                  onPressed: () => submit(),
                                  //child: const Text('ADD'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(flex: 1, child: Container(color: Colors.grey[400])),
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
        "p_product_name": productNameController.text,
        "p_work_name": workName.text,
        "p_quantity": quantity.text,
        "p_design_no": designNoController.text,
        "p_unit": unitController.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    unitController.text = Constants.productInfoUnits[0];
    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      print(' ${jsonEncode(item)}');

      productNameController.text = '${item['p_product_name']}';
      workName.text = '${item['p_work_name']}';
      quantity.text = '${item['p_quantity']}';
      designNoController.text = '${item['p_design_no']}';
      unitController.text = '${item['p_unit']}';
    }
  }
}
