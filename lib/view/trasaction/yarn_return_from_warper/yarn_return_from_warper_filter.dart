import 'package:abtxt/view/trasaction/yarn_return_from_warper/yarn_return_from_warper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class YarnReturnFromWarperFilter extends StatelessWidget {
  const YarnReturnFromWarperFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool warperNameC = RxBool(false);
    RxBool firmNameC = RxBool(false);

    Rxn<LedgerModel> warperName = Rxn<LedgerModel>();
    Rxn<FirmModel> firmName = Rxn<FirmModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    int? warperId;
    int? firmId;
    final formKey = GlobalKey<FormState>();
    return GetX<YarnReturnFromWarperController>(builder: (controller) {
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
                        value: warperNameC.value,
                        onChanged: (value) => warperNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Warper Name',
                        items: controller.Warper,
                        selectedItem: warperName.value,
                        isValidate: warperNameC.value,
                        onChanged: (LedgerModel item) {
                          warperId = item.id;
                          warperName.value = item;
                          warperNameC.value = true;
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
                        label: 'Firm Name',
                        items: controller.firmDropdown,
                        selectedItem: firmName.value,
                        isValidate: firmNameC.value,
                        onChanged: (FirmModel item) {
                          firmId = item.id;
                          firmName.value = item;
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
              if (warperNameC.value == true) {
                request['warper_id'] = warperId;
              }
              if (firmNameC.value == true) {
                request['firm_id'] = firmId;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
