//empty_beam_bobbin_delivery_inward_additem

import 'dart:convert';

import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
import 'package:abtxt/view/basics/yarn/add_yarn.dart';
//import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import 'empty_beam_bobbin_delivery_inward_controller.dart';

class empty_beam_bobbin_delivery_inward_additem extends StatefulWidget {
  const empty_beam_bobbin_delivery_inward_additem({Key? key}) : super(key: key);

  @override
  State<empty_beam_bobbin_delivery_inward_additem> createState() => _State();
}

class _State extends State<empty_beam_bobbin_delivery_inward_additem> {
  EmptyBeamBobbinDeliveryInwardController controller = Get.find();

  TextEditingController copsReelNameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmptyBeamBobbinDeliveryInwardController>(
        builder: (controller) {
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
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(title: const Text('Add item to Empty Beam Bobbin Delivery Inward')),
          body: SingleChildScrollView(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
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
                                Column(
                                  children: [
                                    MyDropdownButtonFormField(
                                        controller: typeController,
                                        hintText: "Type",
                                        items: Constants.TYPE),
                                    MyTextField(
                                      controller: copsReelNameController,
                                      hintText: 'Cops / Reel Name',
                                      validate: 'string',
                                    ),
                                    MyTextField(
                                      controller: qtyController,
                                      hintText: 'Quantity',
                                      validate: 'number',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyCloseButton(
                                onPressed: () => Get.back(),
                                child: const Text('Close'),
                              ),
                              const SizedBox(width: 16),
                              MyElevatedButton(
                                onPressed: () => submit(),
                                child: const Text('ADD'),
                              ),
                            ],
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

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "type": typeController.text,
        "cops_reel": copsReelNameController.text,
        "quantity": double.tryParse(qtyController.text) ?? 0.0,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    EmptyBeamBobbinDeliveryInwardController controller = Get.find();
    typeController.text = Constants.TYPE[0];

    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      typeController.text='${item['type']}';
      copsReelNameController.text='${item['cops_reel']}';
      qtyController.text='${item['quantity']}';
    }
  }

  // void _sumQuantityRate() {}
}
