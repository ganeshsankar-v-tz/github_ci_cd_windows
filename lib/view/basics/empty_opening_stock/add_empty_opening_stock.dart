//addempty

import 'dart:io';

import 'package:abtxt/model/empty_opening_stock_model.dart';
import 'package:abtxt/view/basics/empty_opening_stock/empty_opening_stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class AddEmptyOpeningStock extends StatefulWidget {
  const AddEmptyOpeningStock({super.key});
  static const String routeName = '/add_emptyopeningstock';

  @override
  State<AddEmptyOpeningStock> createState() => _State();
}

class _State extends State<AddEmptyOpeningStock> {
  TextEditingController idController = TextEditingController();
  TextEditingController recordNo = TextEditingController();
  TextEditingController beam = TextEditingController();
  TextEditingController bobbin = TextEditingController();
  TextEditingController sheet = TextEditingController();
  TextEditingController details = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late EmptyOpeningStockController controller;
  File? image;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmptyOpeningStockController>(builder: (controller) {
      this.controller = controller;

      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Empty Opening Stock"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              //height: Get.height,
              margin: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        //color: Colors.green,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Visibility(
                                  visible: false,
                                  child: MyTextField(
                                    controller: idController,
                                    hintText: "ID",
                                    validate: "",
                                    enabled: false,
                                  ),
                                ),
                                MyTextField(
                                  controller: beam,
                                  hintText: " Beam",
                                  validate: "number",
                                ),
                                MyTextField(
                                  controller: bobbin,
                                  hintText: "Bobbin",
                                  validate: "number",
                                ),
                                MyTextField(
                                  controller: sheet,
                                  hintText: "Sheet",
                                  validate: "number",
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 200,
                                  child: MyElevatedButton(
                                    onPressed: () {
                                      submit();
                                    },
                                    child: Text(
                                        Get.arguments == null ? 'Save' : 'Update'),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "beam": beam.text,
        "babbin": bobbin.text,
        "sheet": sheet.text,
      };
      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        controller.addEmpty(request);
      } else {
        request['id'] = id;
        controller.updateEmpty(request, id);
      }

      print(request);
    }
  }

  void _initValue() {

    if (Get.arguments != null) {
      EmptyOpeningStockModel emptybeam = Get.arguments['item'];
      idController.text = '${emptybeam.id}';
      beam.text = '${emptybeam.beam}';
      bobbin.text = '${emptybeam.babbin}';
      sheet.text = '${emptybeam.sheet}';
    }
  }
}
