import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/JariTwistingModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import 'jari_twisting_yarn_inward_controller.dart';

class JariTwistingYarnInwardFilter extends StatelessWidget {
  const JariTwistingYarnInwardFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool yarnC = RxBool(false);
    RxBool warperC = RxBool(false);
    RxBool copsreelC = RxBool(false);

    Rxn<LedgerModel> warper = Rxn<LedgerModel>();
    Rxn<JariTwistingModel> yarnName = Rxn<JariTwistingModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController copsreel = TextEditingController(text: "Nothing");
    int? yarnId;
    int? warperId;
    final formKey = GlobalKey<FormState>();
    return GetX<JariTwistingYarnInwardController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 570,
            height: 270,
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
                        value: yarnC.value,
                        onChanged: (value) => yarnC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Yarn',
                        selectedItem: yarnName.value,
                        items: controller.Yarn,
                        isValidate: yarnC.value,
                        onChanged: (JariTwistingModel item) {
                          yarnId = item.yarnId;
                          yarnName.value = item;
                          yarnC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: warperC.value,
                        onChanged: (value) => warperC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Warper',
                        items: controller.warperList,
                        selectedItem: warper.value,
                        isValidate: warperC.value,
                        onChanged: (LedgerModel item) {
                          warperId = item.id;
                          warper.value = item;
                          warperC.value = true;
                        },
                      ),
                    ),
                  ),
                  /*SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: copsreelC.value,
                        onChanged: (value) => copsreelC.value = value!,
                      ),
                      subtitle:MyDropdownButtonFormField(
                        controller: copsreel,
                        hintText: 'Cops/Reel',
                        items: ["Nothing"],

                      )
                    ),
                  ),*/
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
              if (yarnC.value == true) {
                request['yarn_id'] = yarnId;
              }
              if (warperC.value == true) {
                request['warper_id'] = warperId;
              }
              /*if (copsreelC.value == true) {
                request['cr_no'] =copsreel.text;
              }*/
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
