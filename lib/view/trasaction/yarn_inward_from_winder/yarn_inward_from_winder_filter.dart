import 'package:abtxt/view/trasaction/yarn_inward_from_winder/yarn_inward_from_winder_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyFilterTextField.dart';


class YarnInwardFromWinderFilter extends StatelessWidget {
  const YarnInwardFromWinderFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool winderNameC = RxBool(false);
    RxBool dcNoC = RxBool(false);
    Rxn<LedgerModel> winderName = Rxn<LedgerModel>();
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController dcNoController = TextEditingController();
    int? winderId;
    final formKey = GlobalKey<FormState>();
    return GetX<YarnInwardFromWinderController>(builder: (controller) {
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
                        value: winderNameC.value,
                        onChanged: (value) => winderNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Winder',
                        selectedItem: winderName.value,
                        items: controller.ledger_dropdown,
                        isValidate: winderNameC.value,
                        onChanged: (LedgerModel item) {
                          winderName.value = item;
                          winderId = item.id;
                          winderNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: dcNoC.value,
                        onChanged: (value) => dcNoC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: dcNoController,
                        hintText: "Dc No",
                        validate: dcNoC.value ? 'number' : '',
                        onChanged: (value){
                          dcNoC.value = dcNoController.text.isNotEmpty;
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
              if (winderNameC.value == true) {
                request['winder_id'] = winderId;
              }
              if (dcNoC.value == true) {
                request['dc_no'] = dcNoController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
