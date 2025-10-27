
import 'package:abtxt/view/trasaction/yarn_delivery_to_twister/yarn_delivery_to_twister_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/MyDateFilter.dart';


class YarndeliverytTotwisterFilter extends StatelessWidget {
  const YarndeliverytTotwisterFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);



    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController = TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);


    final formKey = GlobalKey<FormState>();
    return GetX<YarnDeliveryToTwisterController>(builder: (controller) {
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
                  Wrap(
                    //crossAxisAlignment: CrossAxisAlignment.start,
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
                                    autofocus: true),
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

                    ],
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

              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}

