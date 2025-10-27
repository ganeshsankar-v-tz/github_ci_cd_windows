import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/finance/tds_report/tds_amount_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../model/DropModel.dart';
import '../../../../model/FirmModel.dart';
import '../../../../model/LedgerModel.dart';
import '../../../../widgets/MyDateFilter.dart';
import '../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../widgets/MyFilterTextField.dart';
import '../../../../widgets/my_search_field/my_search_field.dart';

class TdsAmountFilter extends StatefulWidget {
  const TdsAmountFilter({super.key});

  @override
  State<TdsAmountFilter> createState() => _TdsAmountFilterState();
}

class _TdsAmountFilterState extends State<TdsAmountFilter> {
  TdsAmountReportController controller = Get.put(TdsAmountReportController());

  final formKey = GlobalKey<FormState>();
  RxBool dateC = RxBool(true);
  RxBool ledgerNameC = RxBool(false);
  RxBool firmC = RxBool(false);
  RxBool challanNoC = RxBool(false);
  RxBool paymentType = RxBool(false);

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
  int? firmId;
  int? ledgerId;

  final FocusNode ledgerNameFocusNode = FocusNode();
  final FocusNode firmFocusNode = FocusNode();
  final FocusNode firmFocusCheckFocusNode = FocusNode();
  final FocusNode challanCheckFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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

    return GetBuilder<TdsAmountReportController>(
      builder: (controller) {
        return CoreWidget(
          loadingStatus: controller.status.isLoading,
          backgroundColor: Colors.transparent,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Form(
              key: formKey,
              child: SizedBox(
                width: 570,
                height: 400,
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
                        () => SizedBox(
                          width: 325,
                          child: ListTile(
                            leading: Checkbox(
                              value: paymentType.value,
                              onChanged: (value) => paymentType.value = value!,
                            ),
                            subtitle: MyDropdownButtonFormField(
                              enabled: paymentType.value,
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
                              enabled: ledgerNameC.value,
                              setInitialValue: false,
                              label: 'Ledger Name',
                              items: controller.ledgerDropdown,
                              textController: ledgerTextController,
                              focusNode: ledgerNameFocusNode,
                              requestFocus: firmFocusCheckFocusNode,
                              isValidate: ledgerNameC.value,
                              onChanged: (LedgerModel item) {
                                ledgerId = item.id;
                                ledgerNameController.value = DropModel(
                                    id: item.id, name: item.ledgerName);
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
                              enabled: firmC.value,
                              label: 'Firm',
                              items: controller.firmDropdown,
                              textController: firmTextController,
                              focusNode: firmFocusNode,
                              requestFocus: challanCheckFocusNode,
                              isValidate: firmC.value,
                              onChanged: (FirmModel item) {
                                firmId = item.id;
                                firmName.value = item;
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
                                  width: 160,
                                  enabled: challanNoC.value,
                                  controller: challanNoFromController,
                                  hintText: "From Challan No",
                                  validate: challanNoC.value ? "number" : "",
                                ),
                                MyFilterTextField(
                                  width: 160,
                                  enabled: challanNoC.value,
                                  controller: challanNoToController,
                                  hintText: "To Challan No",
                                  validate: challanNoC.value ? "number" : "",
                                ),
                              ],
                            ),
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
                  onPressed: () => Get.back(), child: const Text('CANCEL')),
              TextButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  var request = {};

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

                  Get.back(
                      result: controller.paymentDetailsFilterData = request);
                },
                child: const Text('SUBMIT'),
              )
            ],
          ),
        );
      },
    );
  }
}
