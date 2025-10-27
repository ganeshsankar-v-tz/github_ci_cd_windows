import 'package:abtxt/view/report/cheque_leaf_print/cheque_leaf_controller.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';

class ChequeLeafFilter extends StatelessWidget {
  const ChequeLeafFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool chequeNoC = RxBool(false);
    RxBool templateC = RxBool(false);
    RxBool detailsC = RxBool(false);

    var today = DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd');
    TextEditingController fromDateController =
        TextEditingController(text: dateFormat.format(today));
    TextEditingController toDateController =
        TextEditingController(text: dateFormat.format(today));
    TextEditingController chequeNoController = TextEditingController();
    TextEditingController templateController =
        TextEditingController(text: "TMB");
    TextEditingController detailsController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    return GetX<ChequeLeafController>(
      builder: (controller) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 570,
              height: 330,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Checkbox(
                        value: dateC.value,
                        onChanged: (value) => dateC.value = value!,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            children: [
                              MyDateFilter(
                                controller: fromDateController,
                                labelText: "From Date",
                                required: dateC.value,
                                autofocus: true,
                              ),
                              // SizedBox(width: 4),
                              MyDateFilter(
                                controller: toDateController,
                                labelText: "To Date",
                                required: dateC.value,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: chequeNoC.value,
                          onChanged: (value) => chequeNoC.value = value!,
                        ),
                        subtitle: MyTextField(
                          controller: chequeNoController,
                          hintText: "Cheque No",
                          validate: chequeNoC.value ? "number" : "",
                          onChanged: (value) {
                            chequeNoC.value = true;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: templateC.value,
                          onChanged: (value) => templateC.value = value!,
                        ),
                        subtitle: MyDropdownButtonFormField(
                          controller: templateController,
                          hintText: "Template",
                          items: const [
                            "TMB",
                            "ICICI",
                            "CANARA",
                            "AXIS",
                          ],
                          onChanged: (value) {
                            templateC.value = true;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: detailsC.value,
                          onChanged: (value) => detailsC.value = value!,
                        ),
                        subtitle: MyTextField(
                          controller: detailsController,
                          validate: detailsC.value ? "string" : "",
                          hintText: "Details",
                          onChanged: (value) {
                            detailsC.value = true;
                          },
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
                if (dateC.value == true) {
                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;
                }

                if (chequeNoC.value == true) {
                  request["cheque_no"] = int.tryParse(chequeNoController.text);
                }

                if (templateC.value == true) {
                  request["template"] = templateController.text;
                }

                if (detailsC.value == true) {
                  request["details"] = detailsController.text;
                }

                Get.back(result: controller.filterData = request);
              },
            ),
          ],
        );
      },
    );
  }
}
