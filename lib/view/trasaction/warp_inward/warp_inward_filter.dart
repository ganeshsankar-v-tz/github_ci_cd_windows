import 'package:abtxt/view/trasaction/warp_inward/warp_inward_controller.dart';
import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class WarpInwardFilter extends StatelessWidget {
  const WarpInwardFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool NameC = RxBool(false);
    RxBool warpDesignC = RxBool(false);
    RxBool warpIdnoC = RxBool(false);

    Rxn<LedgerModel> warperName = Rxn<LedgerModel>();
    Rxn<NewWarpModel> newWarp = Rxn<NewWarpModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController warpID = TextEditingController();
    int? NameId;
    int? warpdesignId;
    final formKey = GlobalKey<FormState>();
    return GetX<WarpInwardController>(builder: (controller) {
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
                        value: NameC.value,
                        onChanged: (value) => NameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Warper',
                        items: controller.ledgerDropdown,
                        selectedItem: warperName.value,
                        isValidate: NameC.value,
                        onChanged: (LedgerModel item) {
                          NameId = item.id;
                          warperName.value = item;
                          NameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: warpDesignC.value,
                        onChanged: (value) => warpDesignC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Warp Design',
                        items: controller.newWarpDropDown,
                        selectedItem: newWarp.value,
                        isValidate: warpDesignC.value,
                        onChanged: (NewWarpModel item) {
                          warpdesignId = item.id;
                          newWarp.value = item;
                          warpDesignC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: warpIdnoC.value,
                          onChanged: (value) => warpIdnoC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: warpID,
                          hintText: 'Warp Id No',
                          validate: warpIdnoC.value ? 'string' : '',
                          onChanged: (value) {
                            warpIdnoC.value = warpID.text.isNotEmpty;
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
              if (NameC.value == true) {
                request['warper_id'] = NameId;
              }
              if (warpDesignC.value == true) {
                request['warp_design_id'] = warpdesignId;
              }
              if (warpIdnoC.value == true) {
                request['warp_id'] = warpID.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
