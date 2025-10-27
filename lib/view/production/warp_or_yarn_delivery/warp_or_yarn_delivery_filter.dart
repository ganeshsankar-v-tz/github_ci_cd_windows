import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/production/warp_or_yarn_delivery/warp_or_yarn_delivery_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';


class WarpOrYarnDeliveryFilter extends StatelessWidget {
  const WarpOrYarnDeliveryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool weaverNameC = RxBool(false);
    RxBool challanNoC = RxBool(false);
    RxBool entryTypeC = RxBool(false);

    Rxn<LedgerModel> weaver = Rxn<LedgerModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController challanNoFromController =
        TextEditingController(text: "0");
    TextEditingController challanNoToController =
        TextEditingController(text: "0");
    TextEditingController entryTypeController =
        TextEditingController(text: "Yarn Delivery");

    int? weaverId;
    final formKey = GlobalKey<FormState>();
    return GetX<WarpOrYarnDeliveryController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 570,
            height: 350,
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

                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: entryTypeC.value,
                        onChanged: (value) => entryTypeC.value = value!,
                      ),
                      subtitle: MyDropdownButtonFormField(
                        controller: entryTypeController,
                        hintText: "Entry Type",
                        autofocus: false,
                        items: Constants.ENTRY_TYPES_PRODUCTION,
                        onChanged: (value) {
                          entryTypeController.text = value;
                          entryTypeC.value = true;
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
                          controller: challanNoFromController,
                          hintText: "Challan No",
                          validate: "number",
                          onChanged: (value) {
                            challanNoC.value =
                                challanNoFromController.text.isNotEmpty;
                          },
                        ),
                        MyFilterTextField(
                          controller: challanNoToController,
                          hintText: "To",
                          validate: "number",
                          onChanged: (value) {
                            challanNoC.value =
                                challanNoToController.text.isNotEmpty;
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
              if (entryTypeC.value == true) {
                request['entry_type'] = entryTypeController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
