import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/report/finance/payment_report_controller.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/DropModel.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyFilterTextField.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class PaymentReport extends StatefulWidget {
  const PaymentReport({super.key});

  @override
  State<PaymentReport> createState() => _PaymentReportState();
}

class _PaymentReportState extends State<PaymentReport> {
  PaymentReportController controller = Get.put(PaymentReportController());

  final formKey = GlobalKey<FormState>();
  RxBool dateC = RxBool(true);
  RxBool splitAmountC = RxBool(false);
  RxBool ledgerNameC = RxBool(false);
  RxBool firmC = RxBool(false);
  RxBool challanNoC = RxBool(false);
  RxBool paymentType = RxBool(false);
  RxBool belowAmountC = RxBool(false);

  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<DropModel> ledgerNameController = Rxn<DropModel>();
  Rxn<String> payTypeController = Rxn<String>();

  TextEditingController splitAmountController =
      TextEditingController(text: "0");
  var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController challanNoFromController =
      TextEditingController(text: "0");
  TextEditingController challanNoToController =
      TextEditingController(text: "0");
  TextEditingController paymentTypeController =
      TextEditingController(text: "Dyer Amount");
  TextEditingController ledgerTextController = TextEditingController();
  TextEditingController firmTextController = TextEditingController();
  TextEditingController belowAmountController =
      TextEditingController(text: "0");
  TextEditingController formatController = TextEditingController(text: "Excel");
  int? firmId;
  int? ledgerId;

  final FocusNode ledgerNameFocusNode = FocusNode();
  final FocusNode firmFocusNode = FocusNode();
  final FocusNode firmFocusCheckFocusNode = FocusNode();
  final FocusNode challanFocusNode = FocusNode();
  final FocusNode challanCheckFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.ledgerInfo("all");
    fromDateController.text = today;
    toDateController.text = today;
  }

  @override
  Widget build(BuildContext context) {
    void ledgerDropdownList(String item, {int? ledgerId}) async {
      ledgerNameController.value = null;
      controller.payType = item;
      controller.ledgerDropdown.clear();

      var roll = "";
      payTypeController.value = item;

      if (item == "Advance Amount" || item == "Mid Amount") {
        roll = "all";
      } else if (item == "JobWorker Amount") {
        roll = "job_worker";
      } else {
        roll = item.split(" ").first.toLowerCase();
      }

      var result = await controller.ledgerInfo(roll);
      var ledgerList =
          result.where((element) => '${element.id}' == '$ledgerId').toList();
      if (ledgerList.isNotEmpty) {
        ledgerNameController.value = DropModel(
            id: ledgerList.first.id, name: ledgerList.first.ledgerName);
      }
    }

    return GetBuilder<PaymentReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Finance - Payment Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 570,
              height: 620,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ListTile(
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
                                  enabled: dateC.value,
                                  controller: fromDateController,
                                  labelText: "From Date",
                                  required: dateC.value,
                                  autofocus: true,
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
                      () => ListTile(
                        leading: Checkbox(
                          value: splitAmountC.value,
                          onChanged: (value) => splitAmountC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: splitAmountController,
                          hintText: "Split Amount",
                          validate: splitAmountC.value == true ? "number" : "",
                          onChanged: (value) {
                            splitAmountC.value = true;
                          },
                        ),
                      ),
                    ),
                    Obx(
                      () => ListTile(
                        leading: Checkbox(
                          value: belowAmountC.value,
                          onChanged: (value) => belowAmountC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: belowAmountController,
                          hintText: "Below Amount",
                          validate: belowAmountC.value == true ? "number" : "",
                          onChanged: (value) {
                            belowAmountC.value = true;
                          },
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: paymentType.value,
                            onChanged: (value) => paymentType.value = value!,
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
                              "Advance Amount",
                              "Mid Amount",
                            ],
                            onChanged: (value) {
                              paymentTypeController.text = value;
                              paymentType.value = true;
                              ledgerDropdownList(value);
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
                            value: ledgerNameC.value,
                            onChanged: (value) => ledgerNameC.value = value!,
                          ),
                          subtitle: MySearchField(
                            setInitialValue: false,
                            label: 'Ledger Name',
                            items: controller.ledgerDropdown,
                            textController: ledgerTextController,
                            focusNode: ledgerNameFocusNode,
                            requestFocus: firmFocusCheckFocusNode,
                            isValidate: ledgerNameC.value,
                            onChanged: (LedgerModel item) {
                              ledgerId = item.id;
                              ledgerNameController.value =
                                  DropModel(id: item.id, name: item.ledgerName);
                              ledgerNameC.value = true;
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
                            focusNode: firmFocusCheckFocusNode,
                            value: firmC.value,
                            onChanged: (value) => firmC.value = value!,
                          ),
                          subtitle: MySearchField(
                            label: 'Firm',
                            items: controller.firmDropdown,
                            textController: firmTextController,
                            focusNode: firmFocusNode,
                            requestFocus: challanCheckFocusNode,
                            isValidate: firmC.value,
                            onChanged: (FirmModel item) {
                              firmId = item.id;
                              firmName.value = item;
                              firmC.value = true;
                            },
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        child: ListTile(
                          leading: Checkbox(
                            focusNode: challanCheckFocusNode,
                            value: challanNoC.value,
                            onChanged: (value) => challanNoC.value = value!,
                          ),
                          subtitle: Row(
                            children: [
                              MyFilterTextField(
                                focusNode: challanFocusNode,
                                controller: challanNoFromController,
                                hintText: "Challan No",
                                validate: "number",
                                onChanged: (value) {
                                  challanNoC.value =
                                      challanNoFromController.text.isNotEmpty;
                                },
                              ),
                              MyFilterTextField(
                                controller: challanNoToController,
                                hintText: "To",
                                validate: "number",
                                onChanged: (value) {
                                  challanNoC.value =
                                      challanNoToController.text.isNotEmpty;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 60),
                        MyDropdownButtonFormField(
                          controller: formatController,
                          hintText: 'Format',
                          items: const [
                            'PDF',
                            'Excel',
                          ],
                          onChanged: (value) {},
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
                onPressed: () => Get.back(), child: const Text('CANCEL')),
            TextButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  if (splitAmountC.value == true &&
                      formatController.text == "PDF") {
                    return AppUtils.infoAlert(
                        message: "Spit amount  only for Excel Format");
                  }

                  int amount = int.tryParse(splitAmountController.text) ?? 0;

                  if (amount < 10000 && splitAmountC.value == true) {
                    return AppUtils.infoAlert(
                        message: "Minimum split amount is 10000");
                  }

                  var request = {};

                  request['amount'] = amount;

                  if (belowAmountC.value == true) {
                    request["gross_amount_limit"] =
                        double.tryParse(belowAmountController.text) ?? 0;
                  }

                  if (dateC.value == true) {
                    request['from_date'] = fromDateController.text;
                    request['to_date'] = toDateController.text;
                  }
                  if (firmC.value == true) {
                    request['firm_id'] = firmId;
                  }
                  if (ledgerNameC.value == true) {
                    request['ledger_id'] = ledgerId;
                  }
                  if (challanNoC.value == true) {
                    request['challan_no_from'] = challanNoFromController.text;
                    request['challan_no_to'] = challanNoToController.text;
                  }
                  if (paymentType.value == true) {
                    request['payment_type'] = paymentTypeController.text;
                  }
                  request["format"] = formatController.text.toLowerCase();

                  if (splitAmountC.value == true) {
                    String? response =
                        await controller.paymentReportSplit(request: request);
                    if (response != null) {
                      final Uri url = Uri.parse(response);
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $response');
                      }
                    }
                  } else {
                    String? response =
                        await controller.paymentReport(request: request);
                    if (response != null) {
                      final Uri url = Uri.parse(response);
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $response');
                      }
                    }
                  }
                },
                child: const Text('SUBMIT'))
          ],
        ),
      );
    });
  }
}
