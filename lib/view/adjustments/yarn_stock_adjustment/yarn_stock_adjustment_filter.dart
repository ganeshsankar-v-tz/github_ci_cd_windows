import 'package:abtxt/view/adjustments/yarn_stock_adjustment/yarn_stock_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widgets/MyDateFilter.dart';

class YarnStockAdjustmentFilter extends StatelessWidget {
  const YarnStockAdjustmentFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool detailsC = RxBool(false);
    RxBool reasonC = RxBool(false);

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController details = TextEditingController();
    TextEditingController reasonController =
        TextEditingController(text: "Other");
    final formKey = GlobalKey<FormState>();
    return GetX<YarnStockController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 580,
            height: 250,
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
                              onChanged: (value) {
                                dateC.value =
                                    fromDateController.text.isNotEmpty;
                              },
                            ),
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
                          value: detailsC.value,
                          onChanged: (value) => detailsC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: details,
                          hintText: 'Details',
                          validate: detailsC.value ? 'string' : '',
                          onChanged: (value) {
                            detailsC.value = details.text.isNotEmpty;
                          },
                        )),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: reasonC.value,
                          onChanged: (value) => reasonC.value = value!,
                        ),
                        subtitle: MyDropdownButtonFormField(
                          controller: reasonController,
                          hintText: 'Reason',
                          autofocus: false,
                          items: ["Other", "Nothing"],
                          onChanged: (value) {
                            reasonController.text = value;
                            reasonC.value = true;
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('APPLY'),
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (dateC.value == true) {
                request['from_date'] = fromDateController.text;
                request['to_date'] = toDateController.text;
              }
              if (detailsC.value == true) {
                request['details'] = details.text;
              }
              if (reasonC.value == true) {
                request['reason'] = reasonController.text;
              }

              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
