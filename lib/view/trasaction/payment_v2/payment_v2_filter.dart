import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyFilterTextField.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class PaymentV2Filter extends StatefulWidget {
  const PaymentV2Filter({super.key});

  @override
  State<PaymentV2Filter> createState() => _PaymentV2FilterState();
}

class _PaymentV2FilterState extends State<PaymentV2Filter> {
  PaymentV2Controller controller = Get.find();
  final formKey = GlobalKey<FormState>();

  RxBool dateC = RxBool(true);
  RxBool ledgerNameC = RxBool(false);
  RxBool firmC = RxBool(false);
  RxBool challanNo = RxBool(false);
  RxBool paymentType = RxBool(false);

  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<LedgerModel> ledgerName = Rxn<LedgerModel>();

  var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController challanNoController = TextEditingController();
  TextEditingController paymentTypeController =
      TextEditingController(text: "Dyer Amount");
  TextEditingController ledgerTextController = TextEditingController();
  TextEditingController firmTextController = TextEditingController();

  final FocusNode ledgerNameFocusNode = FocusNode();
  final FocusNode firmFocusNode = FocusNode();
  final FocusNode challanFocusNode = FocusNode();

  int? firmId;
  int? ledgerId;

  @override
  void initState() {
    super.initState();
    fromDateController.text = today;
    toDateController.text = today;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentV2Controller>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 570,
            height: 450,
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
                            "Others"
                          ],
                          onChanged: (value) {
                            paymentTypeController.text = value;
                            paymentType.value = true;
                            ledgerNameC.value = false;
                            ledgerTextController.text = "";
                            ledgerName.value = null;

                            var roll = "";
                            if (value == "Advance Amount" ||
                                value == "Mid Amount") {
                              roll = "all";
                            } else if (value == "JobWorker Amount") {
                              roll = "job_worker";
                            } else {
                              roll = value.split(" ").first.toLowerCase();
                            }

                            if (paymentType.value == true) {
                              controller.ledgerInfo(roll);
                            }
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
                          requestFocus: firmFocusNode,
                          isValidate: ledgerNameC.value,
                          onChanged: (LedgerModel item) {
                            ledgerId = item.id;
                            ledgerName.value = item;
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
                          value: firmC.value,
                          onChanged: (value) => firmC.value = value!,
                        ),
                        subtitle: MySearchField(
                          label: 'Firm',
                          items: controller.firmDropdown,
                          textController: firmTextController,
                          focusNode: firmFocusNode,
                          requestFocus: challanFocusNode,
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
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: challanNo.value,
                          onChanged: (value) => challanNo.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          focusNode: challanFocusNode,
                          controller: challanNoController,
                          hintText: "Challan No",
                          validate: challanNo.value ? 'number' : '',
                          onChanged: (value) {
                            challanNo.value =
                                challanNoController.text.isNotEmpty;
                          },
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
              if (firmC.value == true) {
                request['firm_id'] = firmId;
              }
              if (ledgerNameC.value == true) {
                request['ledger_id'] = ledgerId;
              }
              if (challanNo.value == true) {
                request['challan_no'] = challanNoController.text;
              }
              if (paymentType.value == true) {
                request['payment_type'] = paymentTypeController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
