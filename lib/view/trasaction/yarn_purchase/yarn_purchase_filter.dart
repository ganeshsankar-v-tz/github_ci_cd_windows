import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyFilterTextField.dart';

class YarnPurchaseFilter extends StatelessWidget {
  const YarnPurchaseFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool firmC = RxBool(false);
    RxBool supplierC = RxBool(false);
    RxBool sliNoC = RxBool(false);

    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    Rxn<LedgerModel> supplier = Rxn<LedgerModel>();

    var today = DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd');
    TextEditingController fromDateController = TextEditingController(text: dateFormat.format(today));
    TextEditingController toDateController = TextEditingController(text: dateFormat.format(today));
    TextEditingController slipNo = TextEditingController();
    int? firmId;
    int? supplierId;
    final formKey = GlobalKey<FormState>();
    return GetX<YarnPurchaseController>(builder: (controller) {
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
                          firmId = item.id;
                          firmName.value = item;
                          firmC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: supplierC.value,
                        onChanged: (value) => supplierC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Supplier',
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
                  ),
                  SizedBox(
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
                        onChanged: (value){
                          sliNoC.value = slipNo.text.isNotEmpty;
                        },
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
              if (supplierC.value == true) {
                request['supplier_id'] = supplierId;
              }
              if (sliNoC.value == true) {
                request['slip_no'] = slipNo.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
