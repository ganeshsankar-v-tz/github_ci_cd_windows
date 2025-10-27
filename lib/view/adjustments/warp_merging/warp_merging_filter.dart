//import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/adjustments/warp_merging/warp_merging_controller.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_controller.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MyDateFilter.dart';

class WarpMergingFilter extends StatelessWidget {
  const WarpMergingFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool warpDesignC = RxBool(false);
    RxBool warpIdC = RxBool(false);

    Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController warpIdController = TextEditingController();

    var warpDesignId;

    final _formKey = GlobalKey<FormState>();
    return GetX<WarpMergingController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 580,
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
                        value: warpDesignC.value,
                        onChanged: (value) => warpDesignC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Design Name',
                        items: controller.newWarp,
                        selectedItem: warpDesign.value,
                        isValidate: warpDesignC.value,
                        onChanged: (NewWarpModel item) {
                          warpDesign.value = item;
                          warpDesignId = item.id;
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
                        subtitle: MyTextField(
                          controller: warpIdController,
                          hintText: 'Warp Id No',
                          validate: warpIdC.value ? 'string' : '',
                          onChanged: (value) {
                            warpIdC.value = warpIdController.text.isNotEmpty;
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
              if (!_formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (dateC.value == true) {
                request['from_date'] = fromDateController.text;
                request['to_date'] = toDateController.text;
              }
              if (warpDesignC.value == true) {
                request['warp_design_id'] = warpDesignId;
              }
              if (warpIdC.value == true) {
                request['warp_id_no'] = warpIdController.text;
              }
              Get.back(result: request);
            },
          ),
        ],
      );
    });
  }
}
