import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import 'loom_account_controller.dart';

class LoomAccountFilter extends StatelessWidget {
  const LoomAccountFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool weaverNameC = RxBool(true);
    RxBool branchC = RxBool(false);
    RxBool bankC = RxBool(false);

    Rxn<LedgerModel> weaver = Rxn<LedgerModel>();

    TextEditingController branchController = TextEditingController();
    TextEditingController bankController = TextEditingController();
    int? weaverId;
    final formKey = GlobalKey<FormState>();

    return GetX<LoomAccountController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 450,
            height: 250,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: weaverNameC.value,
                        onChanged: (value) => weaverNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Name',
                        items: controller.weaverDetails,
                        selectedItem: weaver.value,
                        isValidate: weaverNameC.value,
                        onChanged: (LedgerModel item) {
                          weaver.value = item;
                          weaverId = item.id;
                          weaverNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: branchC.value,
                        onChanged: (value) => branchC.value = value!,
                      ),
                      subtitle: MyTextField(
                        controller: branchController,
                        hintText: "Branch",
                        validate: branchC.value ? 'string' : '',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: bankC.value,
                        onChanged: (value) => bankC.value = value!,
                      ),
                      subtitle: MyTextField(
                        controller: bankController,
                        hintText: "Bank",
                        validate: bankC.value ? 'string' : '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('APPLY'),
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (weaverNameC.value == true) {
                request['weaver_id'] = weaverId;
              }
              if (branchC.value == true) {
                request['branch'] = branchController.text;
              }
              if (bankC.value == true) {
                request['bank_name'] = bankController.text;
              }
              Get.back(result: request);
            },
          ),
        ],
      );
    });
  }
}
