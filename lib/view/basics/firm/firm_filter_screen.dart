import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/trasaction/payment/payment_controller.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MyDateFilter.dart';
import 'firm_controller.dart';

class FirmFilter extends StatelessWidget {
  const FirmFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool firmC = RxBool(false);
    RxBool cityC = RxBool(false);

    TextEditingController firmNameComtroller = TextEditingController();
    TextEditingController cityController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    return GetX<FirmController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 570,
            height: 420,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 325,
                  child: ListTile(
                      leading: Checkbox(
                        value: firmC.value,
                        onChanged: (value) => firmC.value = value!,
                      ),
                      subtitle: MyTextField(
                        controller: firmNameComtroller,
                        hintText: 'Firm Name',
                      )),
                ),
                SizedBox(
                  width: 325,
                  child: ListTile(
                      leading: Checkbox(
                        value: cityC.value,
                        onChanged: (value) => cityC.value = value!,
                      ),
                      subtitle: MyTextField(
                        controller: cityController,
                        hintText: 'City',
                      )),
                ),
              ],
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
              if (firmC.value == true) {
                request['firm_name'] = firmNameComtroller.text;
              }

              if (cityC.value == true) {
                request['city'] = cityController.text;
              }
              Get.back(result: request);
            },
          ),
        ],
      );
    });
  }
}
