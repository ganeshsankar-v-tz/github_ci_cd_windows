import 'package:abtxt/view/basics/tax_fix/tax_fix_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/MyDropdownButtonFormField.dart';

class TaxFixFilter extends StatelessWidget {
  const TaxFixFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool entryC = RxBool(true);

    TextEditingController entryController =
        TextEditingController(text: 'Product Sales');

    final formKey = GlobalKey<FormState>();
    return GetX<TaxFixController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 570,
            height: 150,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Checkbox(
                      value: entryC.value,
                      onChanged: (value) => entryC.value = value!,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          children: [
                            MyDropdownButtonFormField(
                              controller: entryController,
                              hintText: "Entry",
                              items: const [
                                "Product Sales",
                                "JobWork Delivery",
                                "Warp Purchase",
                                "Yarn Purchase",
                                "Yarn Purchase Return",
                                "Process Delivery",
                                "Warp Sales",
                                "Yarn Sales"
                              ],
                            )
                          ],
                        ),
                      ],
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
              if (entryC.value == true) {
                request['entry_type'] = entryController.text;
              }

              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
