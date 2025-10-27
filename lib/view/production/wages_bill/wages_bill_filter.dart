import 'package:abtxt/view/production/wages_bill/wages_bill_controller.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class WagesBillFilter extends StatelessWidget {
  const WagesBillFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool weaverName = RxBool(false);
    RxBool challanNo = RxBool(false);

    Rxn<LedgerModel> weaver = Rxn<LedgerModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController challanNoFromController = TextEditingController(text: "0");
    TextEditingController challanNoToController = TextEditingController(text: "0");

    var weaverId;
    final _formKey = GlobalKey<FormState>();
    return GetX<WagesbillController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: SizedBox(
            width: 570,
            height: 280,
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
                          ),
                          const SizedBox(
                            width: 5,
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
                      value: weaverName.value,
                      onChanged: (value) => weaverName.value = value!,
                    ),
                    subtitle: MyAutoComplete(
                      label: 'Weaver Name',
                      items: controller.weaverList,
                      isValidate: weaverName.value,
                      selectedItem: weaver.value,
                      onChanged: (LedgerModel item) {
                        weaver.value = item;
                        weaverId = item.id;
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: Checkbox(
                    value: challanNo.value,
                    onChanged: (value) => challanNo.value = value!,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTextField(
                        controller: challanNoFromController,
                        hintText: "Challan No",
                        validate: "number",
                      ),
                      MyTextField(
                        controller: challanNoToController,
                        hintText: "To",
                        validate: "number",
                      ),
                    ],
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
              if (!_formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (dateC.value == true) {
                request['from_date'] = fromDateController.text;
                request['to_date'] = toDateController.text;
              }
              if (weaverName.value == true) {
                request['weaver_id'] = weaverId;
              }
              if (challanNo.value == true) {
                request['challan_no_from'] = challanNoFromController.text;
                request['challan_no_to'] = challanNoToController.text;

              }
              Get.back(result: request);
            },
          ),
        ],
      );
    });
  }
}
