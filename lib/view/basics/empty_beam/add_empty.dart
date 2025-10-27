//addempty

import 'dart:io';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/view/basics/empty_beam/empty_beam_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../model/EmptyBeamModel.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class add_empty extends StatefulWidget {
  const add_empty({super.key});

  static const String routeName = '/addempty';

  @override
  State<add_empty> createState() => _State();
}

class _State extends State<add_empty> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> nameDropdown = Rxn<LedgerModel>();
  TextEditingController nameDropdownController = TextEditingController();
  TextEditingController recordNo = TextEditingController();
  TextEditingController beam = TextEditingController();
  TextEditingController bobbin = TextEditingController();
  TextEditingController sheet = TextEditingController();

  TextEditingController details = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late EmptyBeamController controller;
  File? image;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmptyBeamController>(builder: (controller) {
      this.controller = controller;

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
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Empty Beam,Bobbin,Sheet Balance from Warper,Customer Supplier"),
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
                                MyDialogList(
                                  labelText: 'Name',
                                  controller: nameDropdownController,
                                  list: controller.ledger_dropdown,
                                  showCreateNew: false,
                                  onItemSelected: (LedgerModel item) {
                                    nameDropdownController.text =
                                        '${item.ledgerName}';
                                    nameDropdown.value = item;
                                    // controller.request['group_name'] = item.id;
                                  },
                                  onCreateNew: (value) async {},
                                ),
                                MyTextField(
                                  controller: recordNo,
                                  hintText: "Record No",
                                  validate: "String",
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
                                MyTextField(
                                  controller: details,
                                  hintText: "Details",
                                  validate: "string",
                                ),
                              ],
                            ),
                            const SizedBox(height: 48),
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
                                    onPressed: () => submit(),
                                    child: Text(Get.arguments == null
                                        ? 'Save'
                                        : 'Update'),
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
        "ledger_id": nameDropdown.value?.id,
        "record_no": recordNo.text,
        "beam": beam.text,
        "bobbin": bobbin.text,
        "sheet": sheet.text,
        "details": details.text,
      };
      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        controller.addEmpty(request);
      } else {
        request['id'] = '$id';

        controller.updateEmpty(request, id);
      }

      print(request);
    }
  }

  void _initValue() {
    EmptyBeamController controller = Get.find();

    if (Get.arguments != null) {
      EmptyBeamController controller = Get.find();
      EmptyBeamModel emptybeam = Get.arguments['item'];
      idController.text = '${emptybeam.id}';

      var ledgerId = controller.ledger_dropdown
          .where((element) => '${element.id}' == '${emptybeam.ledgerId}')
          .toList();
      if (ledgerId.isNotEmpty) {
        nameDropdown.value = ledgerId.first;
        nameDropdownController.text = '${ledgerId.first.ledgerName}';
      }

      recordNo.text = '${emptybeam.recordNo}';
      beam.text = '${emptybeam.beam}';
      bobbin.text = '${emptybeam.bobbin}';
      sheet.text = '${emptybeam.sheet}';
      details.text = '${emptybeam.details}';
    }
  }
}
