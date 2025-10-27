import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/warp_delivery_to_roller_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyFilterTextField.dart';

class WarpDeliverToRollerFilter extends StatelessWidget {
  const WarpDeliverToRollerFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool rollerNameC = RxBool(false);
    RxBool warpIdC = RxBool(false);
    RxBool warpDesignC = RxBool(false);

    Rxn<LedgerModel> rollerName = Rxn<LedgerModel>();
    Rxn<WarpDesignModel> warpDesignName = Rxn<WarpDesignModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController warpIdController = TextEditingController();
    int? rollerId;
    int? warpDesignId;
    final formKey = GlobalKey<FormState>();
    return GetX<WarpDeliveryToRollerController>(builder: (controller) {
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
                        value: rollerNameC.value,
                        onChanged: (value) => rollerNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Roller',
                        selectedItem: rollerName.value,
                        items: controller.ledgerDropdown,
                        isValidate: rollerNameC.value,
                        onChanged: (LedgerModel item) {
                          rollerId = item.id;
                          rollerName.value = item;
                          rollerNameC.value = true;
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
                        items: controller.warpDesignDropdown,
                        selectedItem: warpDesignName.value,
                        isValidate: warpDesignC.value,
                        onChanged: (WarpDesignModel item) {
                          warpDesignId = item.warpDesignId;
                          warpDesignName.value = item;
                          warpDesignC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: warpIdC.value,
                        onChanged: (value) => warpIdC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: warpIdController,
                        hintText: "Warp Id",
                        validate: warpIdC.value ? "string" : '',
                        onChanged: (value) {
                          warpIdC.value = warpIdController.text.isNotEmpty;
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
              if (rollerNameC.value == true) {
                request['roller_id'] = rollerId;
              }
              if (warpDesignC.value == true) {
                request['warp_design_id'] = warpDesignId;
              }
              if (warpIdC.value == true) {
                request['warp_id'] = warpIdController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
