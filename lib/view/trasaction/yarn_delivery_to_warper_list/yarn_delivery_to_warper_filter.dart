import 'package:abtxt/view/trasaction/yarn_delivery_to_warper_list/yarn_delivery_to_warper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/YarnModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class YarnDeliveryToWarperFilter extends StatelessWidget {
  const YarnDeliveryToWarperFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool warperNameC = RxBool(false);
    RxBool firmNameC = RxBool(false);
    RxBool yarnC = RxBool(false);

    Rxn<LedgerModel> warper = Rxn<LedgerModel>();
    Rxn<FirmModel> firm = Rxn<FirmModel>();
    Rxn<YarnModel> yarnName = Rxn<YarnModel>();
    int? yarnNameId;

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    int? warperId;
    int? firmId;
    final formKey = GlobalKey<FormState>();
    return GetX<YarnDeliveryToWarperController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 580,
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
                        value: warperNameC.value,
                        onChanged: (value) => warperNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Warper',
                        items: controller.ledgerDropdown,
                        isValidate: warperNameC.value,
                        selectedItem: warper.value,
                        onChanged: (LedgerModel item) {
                          warper.value = item;
                          warperId = item.id;
                          warperNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: yarnC.value,
                        onChanged: (value) => yarnC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Yarn Name',
                        items: controller.yarnDropdown,
                        selectedItem: yarnName.value,
                        isValidate: yarnC.value,
                        onChanged: (YarnModel item) {
                          yarnName.value = item;
                          yarnNameId = item.id;
                          yarnC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: firmNameC.value,
                        onChanged: (value) => firmNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Firm',
                        items: controller.firmDropdown,
                        isValidate: firmNameC.value,
                        selectedItem: firm.value,
                        onChanged: (FirmModel item) {
                          firm.value = item;
                          firmId = item.id;
                          firmNameC.value = true;
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
              if (warperNameC.value == true) {
                request['warper_id'] = warperId;
              }
              if (firmNameC.value == true) {
                request['firm_id'] = firmId;
              }
              if (yarnC.value == true) {
                request['yarn_id'] = yarnNameId;
              }

              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
