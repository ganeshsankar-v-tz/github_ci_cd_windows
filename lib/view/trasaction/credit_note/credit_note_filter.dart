import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyFilterTextField.dart';
import 'credit_note_controller.dart';

class CreditNoteFilter extends StatefulWidget {
  const CreditNoteFilter({super.key});

  @override
  State<CreditNoteFilter> createState() => _CreditNoteFilterState();
}

class _CreditNoteFilterState extends State<CreditNoteFilter> {
  CreditNoteController controller = Get.find<CreditNoteController>();
  final formKey = GlobalKey<FormState>();

  RxBool dateC = RxBool(true);
  RxBool firmC = RxBool(false);
  RxBool supplierC = RxBool(false);
  RxBool sliNoC = RxBool(false);
  RxBool debitNoteTypeC = RxBool(false);

  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<LedgerModel> supplier = Rxn<LedgerModel>();

  var today = DateTime.now();
  var dateFormat = DateFormat('yyyy-MM-dd');
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController debitNoteTypeController =
      TextEditingController(text: "Yarn sale return");
  TextEditingController slipNo = TextEditingController();
  int? firmId;
  int? supplierId;

  @override
  void initState() {
    super.initState();
    fromDateController.text = dateFormat.format(today);
    toDateController.text = dateFormat.format(today);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditNoteController>(
      builder: (controller) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return ListTile(
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
                              // SizedBox(width: 4),
                              MyDateFilter(
                                controller: toDateController,
                                labelText: "To Date",
                                required: dateC.value,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    return SizedBox(
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
                            firmId = item.id;
                            firmName.value = item;
                            firmC.value = true;
                          },
                        ),
                      ),
                    );
                  }),
                  Obx(() {
                    return SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: debitNoteTypeC.value,
                          onChanged: (value) => debitNoteTypeC.value = value!,
                        ),
                        subtitle: MyDropdownButtonFormField(
                          controller: debitNoteTypeController,
                          hintText: "Select Return Type",
                          items: const [
                            "Product sale return",
                            "Yarn sale return",
                            "Warp sale return",
                          ],
                        ),
                      ),
                    );
                  }),
                  Obx(() {
                    return SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: supplierC.value,
                          onChanged: (value) => supplierC.value = value!,
                        ),
                        subtitle: MyAutoComplete(
                          label: 'Supplier Name',
                          items: controller.ledgerDropdown,
                          selectedItem: supplier.value,
                          isValidate: supplierC.value,
                          onChanged: (LedgerModel item) {
                            supplierId = item.id;
                            supplier.value = item;
                            supplierC.value = true;
                          },
                        ),
                      ),
                    );
                  }),
                  Obx(() {
                    return SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: sliNoC.value,
                          onChanged: (value) => sliNoC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: slipNo,
                          hintText: 'Slip No',
                          validate: sliNoC.value ? 'number' : '',
                          onChanged: (value) {
                            sliNoC.value = slipNo.text.isNotEmpty;
                          },
                        ),
                      ),
                    );
                  }),
                ],
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
                if (debitNoteTypeC.value) {
                  request['debit_note_type'] = debitNoteTypeController.text;
                }
                if (supplierC.value == true) {
                  request['supplier_id'] = supplierId;
                }
                if (sliNoC.value == true) {
                  request['challan_no'] = slipNo.text;
                }
                Get.back(result: controller.filterData = request);
              },
            ),
          ],
        );
      },
    );
  }
}
