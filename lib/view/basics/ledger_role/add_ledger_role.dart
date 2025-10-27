import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/LedgerRole.dart';
import '../../../widgets/MyTextField.dart';
import 'ledger_role_controller.dart';

class AddLedgerRole extends StatefulWidget {
  const AddLedgerRole({Key? key}) : super(key: key);
  static const String routeName = '/addledgerrole';

  @override
  State<AddLedgerRole> createState() => _State();
}

class _State extends State<AddLedgerRole> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late LedgerRoleController controller;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LedgerRoleController>(builder: (controller) {
      this.controller = controller;
      return Scaffold(
        backgroundColor: Color(0xFFF9F3FF),
        appBar: AppBar(
          elevation: 0,
          title:
              Text("${idController.text == '' ? 'Add' : 'Update'} Ledger Role"),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
            ),
            //height: Get.height,
            margin: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        MyTextField(
                          controller: idController,
                          hintText: "ID",
                          validate: "",
                          enabled: false,
                        ),
                        MyTextField(
                          controller: nameController,
                          hintText: "Name",
                          validate: "string",
                        ),
                      ],
                    ),
                    SizedBox(height: 48),
                    Container(
                      width: 200,
                      child: MyElevatedButton(
                        onPressed: () => submit(),
                        child: Text('Add'),
                      ),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "name": nameController.text,
      };
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = '$id';
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      LedgerRole item = Get.arguments['item'];
      idController.text = '${item.id}';
      nameController.text = '${item.name}';
    }
  }
}
