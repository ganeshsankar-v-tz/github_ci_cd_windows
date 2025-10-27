import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/AccountModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/view/production/wages_bill/wages_bill_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/app_utils.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class WagesBillBottomSheet extends StatefulWidget {
  const WagesBillBottomSheet({Key? key}) : super(key: key);

  @override
  State<WagesBillBottomSheet> createState() => _State();
}

class _State extends State<WagesBillBottomSheet> {
  TextEditingController dateController = TextEditingController();
  TextEditingController entryTypeController = TextEditingController();
  final _selectedEntryType = Constants.Wagesbill_Entrytype[0].obs;

  /// Payment Controllers
  Rxn<AccountModel> paymentTo = Rxn<AccountModel>();
  TextEditingController paymentAmountController = TextEditingController();
  TextEditingController paymentDetailsController = TextEditingController();

  /// Debit Controllers
  Rxn<LedgerModel> debitTo = Rxn<LedgerModel>();
  TextEditingController debitAmountController = TextEditingController();
  TextEditingController debitDetailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  WagesbillController controller = Get.find();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WagesbillController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(title: const Text('Weaving..')),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
              submit(),
        },
        loadingStatus: controller.status.isLoading,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Row(
                            children: [
                              MyDateField(
                                controller: dateController,
                                hintText: "Date",
                                readonly: true,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              MyDropdownButtonFormField(
                                controller: entryTypeController,
                                hintText: "Entry Type",
                                items: Constants.Wagesbill_Entrytype,
                                onChanged: (value) {
                                  _selectedEntryType.value = value;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Obx(() => updateWidget(_selectedEntryType.value)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: MyElevatedButton(
                              onPressed: () => submit(),
                              child: const Text('ADD'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget updateWidget(String option) {
    return GetBuilder<WagesbillController>(builder: (controller) {
      if (option == 'Payment') {
        return Wrap(
          children: [
            Row(
              children: [
                MyAutoComplete(
                  label: 'To',
                  items: controller.accountTypeList,
                  selectedItem: paymentTo.value,
                  onChanged: (AccountModel item) async {
                    paymentTo.value = item;
                  },
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: paymentAmountController,
                  hintText: 'Amount (Rs)',
                  validate: 'double',
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: paymentDetailsController,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        );
      } else if (option == "Debit") {
        return Wrap(
          children: [
            Row(
              children: [
                MyAutoComplete(
                  label: 'To',
                  items: controller.debitAccountTypeList,
                  selectedItem: debitTo.value,
                  onChanged: (LedgerModel item) async {
                    debitTo.value = item;
                  },
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: debitAmountController,
                  hintText: 'Amount (Rs)',
                  validate: 'double',
                ),
              ],
            ),
            Row(
              children: [
                MyTextField(
                  controller: debitDetailsController,
                  hintText: 'Details',
                ),
              ],
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var entryType = _selectedEntryType.value.toString();
      Map<String, dynamic> request = {
        "entry_type": entryType,
        'e_date': dateController.text,
      };
      if (entryType == "Payment") {
        var payment = double.tryParse(paymentAmountController.text) ?? 0.0;
        if (payment <= controller.balanceAmount) {
          request["pr_ledger_id"] = paymentTo.value?.id;
          request["pr_ledger_name"] = paymentTo.value?.name;
          request["debit"] = payment;
          request["product_details"] = paymentDetailsController.text;
          Get.back(result: request);
        } else {
          //error
        }
      } else {
        var debit = double.tryParse(debitAmountController.text) ?? 0;
        if (debit <= controller.balanceAmount) {
          request["pr_ledger_id"] = debitTo.value?.id;
          request["pr_ledger_name"] = debitTo.value?.ledgerName;
          request["debit"] = debit;
          request["product_details"] = debitDetailsController.text;
          Get.back(result: request);
        } else {
          //error
        }
      }
    }
  }

//
  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    entryTypeController.text = Constants.Wagesbill_Entrytype[0];

    var amount = controller.balanceAmount;
    paymentAmountController.text = "$amount";
    debitAmountController.text = "$amount";
  }
}
