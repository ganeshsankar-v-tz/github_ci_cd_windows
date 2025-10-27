import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/trasaction/payment/payment_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';

class PaymentFilter extends StatelessWidget {
  const PaymentFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool firmC = RxBool(false);
    RxBool byLedgerC = RxBool(false);
    RxBool toLedgerC = RxBool(false);
    RxBool sliNoC = RxBool(false);
    RxBool againstC = RxBool(false);

    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    Rxn<LedgerModel> ledger = Rxn<LedgerModel>();
   Rxn<LedgerModel> toLedger = Rxn<LedgerModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController againstcontroller = TextEditingController(text: "on Account");
    TextEditingController slipNoController = TextEditingController();

    var firmId;
    var ledgerId;
    var toledgerId;
    final _formKey = GlobalKey<FormState>();
    return GetX<PaymentController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 570,
            height: 400,
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
                            /*SizedBox(
                              width: 5,
                            ),*/
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
                        value: byLedgerC.value,
                        onChanged: (value) => byLedgerC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'By Ledger',
                        items: controller.ledgerDropdown,
                        selectedItem: ledger.value,
                        isValidate: byLedgerC.value,
                        onChanged: (LedgerModel item) {
                          ledger.value = item;
                          ledgerId = item.id;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: firmC.value,
                        onChanged: (value) => firmC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Firm',
                        items: controller.firmDropdown,
                        selectedItem: firmName.value,
                        isValidate: firmC.value,
                        onChanged: (FirmModel item) {
                          firmName.value = item;
                          firmId = item.id;
                        },
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 325,
                  //   child: ListTile(
                  //     leading: Checkbox(
                  //       value: sliNoC.value,
                  //       onChanged: (value) => sliNoC.value = value!,
                  //     ),
                  //     subtitle: MyTextField(
                  //       controller: slipNoController,
                  //       hintText: 'Slip No',
                  //       validate: sliNoC.value ? 'string' : '',
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: toLedgerC.value,
                        onChanged: (value) => toLedgerC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'To Ledger',
                        items: controller.toledgerDropdown,
                        selectedItem: toLedger.value,
                        isValidate: toLedgerC.value,
                        onChanged: (LedgerModel item) {
                          toLedger.value = item;
                          toledgerId = item.id;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: againstC.value,
                        onChanged: (value) => againstC.value = value!,
                      ),
                      subtitle: Container(
                        child: MyDropdownButtonFormField(
                          controller: againstcontroller,
                          hintText: 'Against',
                          items: ["on Account", "Bill/Ref Nos"],)
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
              if (byLedgerC.value == true) {
                request['ledger_id'] = ledgerId;
              }
              if (firmC.value == true) {
                request['firm_id'] = firmId;
              }
              if (sliNoC.value == true) {
                request['slip_char'] = slipNoController;
              }

             if (toLedgerC.value == true) {
                request['to_ledger'] = toledgerId;
              }
              if (againstC.value == true) {
                request['against'] = againstcontroller.text;
              }
              Get.back(result: request);
            },
          ),
        ],
      );
    });
  }
}
