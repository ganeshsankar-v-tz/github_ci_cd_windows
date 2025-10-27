import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import 'empty_in_out_controller.dart';

class EmptyInOutFilter extends StatelessWidget {
  const EmptyInOutFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool weaverNameC = RxBool(false);
    RxBool challanNoC = RxBool(false);

    Rxn<LedgerModel> weaver = Rxn<LedgerModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController challanNoFromController =
        TextEditingController(text: "0");
    TextEditingController challanNoToController =
        TextEditingController(text: "0");

    int? weaverId;
    final formKey = GlobalKey<FormState>();
    return GetX<EmptyInOutController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 570,
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
                            ),
                            const SizedBox(width: 5),
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
                        value: weaverNameC.value,
                        onChanged: (value) => weaverNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Weaver Name',
                        items: controller.WeaverName,
                        isValidate: weaverNameC.value,
                        selectedItem: weaver.value,
                        onChanged: (LedgerModel item) {
                          weaver.value = item;
                          weaverId = item.id;
                          weaverNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Checkbox(
                      value: challanNoC.value,
                      onChanged: (value) => challanNoC.value = value!,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyFilterTextField(
                          validate: "number",
                          hintText: "From Challan No",
                          controller: challanNoFromController,
                          onChanged: (value) {
                            challanNoC.value = true;
                          },
                        ),
                        MyFilterTextField(
                          validate: "number",
                          hintText: "To Challan No",
                          controller: challanNoToController,
                          onChanged: (value) {
                            challanNoC.value = true;
                          },
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
              if (dateC.value == true) {
                request['from_date'] = fromDateController.text;
                request['to_date'] = toDateController.text;
              }
              if (weaverNameC.value == true) {
                request['weaver_id'] = weaverId;
              }
              if (challanNoC.value == true) {
                request['challan_no_from'] = challanNoFromController.text;
                request['challan_no_to'] = challanNoToController.text;
              }
              request["entry_type"] = "Empty - (In / Out)";
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
