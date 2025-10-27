import 'package:abtxt/view/production/loom_declaration/loom_declaration_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownSearch.dart';

class LoomDeclarationFilter extends StatelessWidget {
  const LoomDeclarationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool weaverNameC = RxBool(true);
    RxBool isActiveC = RxBool(false);

    Rxn<LedgerModel> weaver = Rxn<LedgerModel>();

    TextEditingController isActiveController =
        TextEditingController(text: "Yes");
    int? weaverId;
    final formKey = GlobalKey<FormState>();

    return GetX<LoomDeclarationController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 450,
            height: 200,
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
                      items: controller.Weaver,
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
                      value: isActiveC.value,
                      onChanged: (value) => isActiveC.value = value!,
                    ),
                    subtitle: MyDropdownButtonFormField(
                      controller: isActiveController,
                      hintText: "Is Active",
                      autofocus: false,
                      items: const ["Yes", "No", "Virtual Loom"],
                      onChanged: (value) {
                        isActiveC.value = true;
                      },
                    ),
                  ),
                ),
              ],
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
              if (isActiveC.value == true) {
                request['is_active'] = isActiveController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
