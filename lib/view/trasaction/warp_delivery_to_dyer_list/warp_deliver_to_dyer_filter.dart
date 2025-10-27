import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyFilterTextField.dart';

class WarpDeliverToDyerFilter extends StatelessWidget {
  const WarpDeliverToDyerFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool dyerNameC = RxBool(false);
    RxBool warpIdC = RxBool(false);
    RxBool warpDesignC = RxBool(false);

    Rxn<LedgerModel> dyerName = Rxn<LedgerModel>();
    Rxn<WarpDesignModel> warpDesignName = Rxn<WarpDesignModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController warpIdController = TextEditingController();

    int? dyerId;
    int? warpDesignId;
    final formKey = GlobalKey<FormState>();
    return GetX<WarpDeliveryToDyerController>(builder: (controller) {
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
                        value: dyerNameC.value,
                        onChanged: (value) => dyerNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Dyer',
                        items: controller.ledgerDropdown,
                        selectedItem: dyerName.value,
                        isValidate: dyerNameC.value,
                        onChanged: (LedgerModel item) {
                          dyerId = item.id;
                          dyerName.value = item;
                          dyerNameC.value = true;
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
                        isValidate: warpDesignC.value,
                        selectedItem: warpDesignName.value,
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
                        onChanged: (value){
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
              if (dyerNameC.value == true) {
                request['dyer_id'] = dyerId;
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
