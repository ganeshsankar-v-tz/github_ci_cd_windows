import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../flutter_core_widget.dart';
import '../../../../../widgets/MyDateFilter.dart';
import '../../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../../widgets/MyFilterTextField.dart';
import '../baking_report_controller.dart';

class UpcomingFilter extends StatefulWidget {
  const UpcomingFilter({super.key});

  @override
  State<UpcomingFilter> createState() => _UpcomingFilterState();
}

class _UpcomingFilterState extends State<UpcomingFilter> {
  BankingReportController controller = Get.put(BankingReportController());
  static var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final formKey = GlobalKey<FormState>();
  RxBool dateC = RxBool(true);
  RxBool paymentTypeC = RxBool(false);
  RxBool belowAmountC = RxBool(false);
  RxBool rangeAmountC = RxBool(false);

  TextEditingController fromDateController = TextEditingController(text: today);
  TextEditingController toDateController = TextEditingController(text: today);
  TextEditingController paymentTypeController =
      TextEditingController(text: "Dyer Amount");
  TextEditingController belowAmountController =
      TextEditingController(text: "0.00");
  var amountTypeController = TextEditingController(text: "Below");
  var bankingTypeController = TextEditingController(text: "Bank");
  var rangeController = TextEditingController(text: "0.00");

  @override
  void initState() {
    super.initState();
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankingReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ListTile(
                        leading: Checkbox(
                          value: dateC.value,
                          onChanged: (value) {
                            dateC.value = value!;
                          },
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              children: [
                                MyDateFilter(
                                  enabled: dateC.value,
                                  controller: fromDateController,
                                  labelText: "From Date",
                                  required: dateC.value,
                                ),
                                MyDateFilter(
                                  enabled: dateC.value,
                                  controller: toDateController,
                                  labelText: "To Date",
                                  required: dateC.value,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: paymentTypeC.value,
                            onChanged: (value) => paymentTypeC.value = value!,
                          ),
                          subtitle: MyDropdownButtonFormField(
                            controller: paymentTypeController,
                            hintText: "Payment Type",
                            autofocus: false,
                            items: const [
                              "Dyer Amount",
                              "Roller Amount",
                              "Weaver Amount",
                              "JobWorker Amount",
                              "Processor Amount",
                            ],
                            onChanged: (value) {
                              paymentTypeController.text = value;
                              paymentTypeC.value = true;
                            },
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: rangeAmountC.value,
                            onChanged: (value) => rangeAmountC.value = value!,
                          ),
                          subtitle: MyFilterTextField(
                            controller: rangeController,
                            hintText: "Range Amount(Rs)",
                            validate: rangeAmountC.value ? 'double' : '',
                            onChanged: (value) {
                              rangeAmountC.value = true;
                            },
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 400,
                        child: ListTile(
                          leading: Checkbox(
                            value: belowAmountC.value,
                            onChanged: (value) => belowAmountC.value = value!,
                          ),
                          subtitle: Row(
                            children: [
                              MyDropdownButtonFormField(
                                width: 150,
                                controller: amountTypeController,
                                hintText: "Amount Type",
                                items: const ["Below", "Above"],
                                onChanged: (value) {
                                  belowAmountC.value = true;
                                },
                              ),
                              MyFilterTextField(
                                width: 150,
                                controller: belowAmountController,
                                hintText: "Amount(Rs)",
                                validate: belowAmountC.value ? 'double' : '',
                                onChanged: (value) {
                                  belowAmountC.value = true;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 325,
                      child: Row(
                        children: [
                          const SizedBox(width: 60),
                          MyDropdownButtonFormField(
                            controller: bankingTypeController,
                            hintText: "Payment To",
                            items: const ["Bank", "GST"],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
          actions: <Widget>[
            TextButton(onPressed: () => Get.back(), child: const Text("Close")),
            TextButton(
              child: const Text('Apply'),
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                var request = {};
                if (dateC.value == true) {
                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;
                }

                if (paymentTypeC.value == true) {
                  request["payment_type"] = paymentTypeController.text;
                }

                if (rangeAmountC.value == true) {
                  request["range"] = rangeController.text;
                }

                if (bankingTypeController.text == "Bank") {
                  controller.isPaymentTo.value = false;
                } else {
                  controller.isPaymentTo.value = true;
                }

                request["banking_type"] = bankingTypeController.text;

                if (belowAmountC.value == true) {
                  if (amountTypeController.text == "Below") {
                    request["below_amount"] =
                        double.tryParse(belowAmountController.text) ?? 0.0;
                  } else {
                    request["above_amount"] =
                        double.tryParse(belowAmountController.text) ?? 0.0;
                  }
                }

                Get.back(result: controller.filterData = request);
              },
            ),
          ],
        ),
      );
    });
  }

  void _initValue() {
    if (controller.filterData != null) {
      var data = controller.filterData;

      data.forEach((key, value) {
        if (key == "from_date") {
          fromDateController.text = value;
          dateC.value = true;
        } else if (key == "to_date") {
          toDateController.text = value;
        } else if (key == "payment_type") {
          paymentTypeController.text = value;
          paymentTypeC.value = true;
        } else if (key == "range") {
          rangeController.text = value;
          rangeAmountC.value = true;
        } else if (key == "below_amount") {
          belowAmountController.text = value.toString();
          belowAmountC.value = true;
        } else if (key == "above_amount") {
          belowAmountController.text = value.toString();
          belowAmountC.value = true;
        } else if (key == "banking_type") {
          bankingTypeController.text = value;
        }
      });
    }
  }
}
