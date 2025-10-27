import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/trasaction/warp_purchase/warp_purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyFilterTextField.dart';

class WarpPurchaseFilter extends StatelessWidget {
  const WarpPurchaseFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool firmC = RxBool(false);
    RxBool supplierC = RxBool(false);
    RxBool warpTypeC = RxBool(false);
    RxBool warpIdC = RxBool(false);

    Rxn<FirmModel> firm = Rxn<FirmModel>();
    Rxn<LedgerModel> supplier = Rxn<LedgerModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController warpTypeController =
        TextEditingController(text: "Main Warp");
    TextEditingController warpIdController = TextEditingController();
    int? firmId;
    int? supplierId;
    final formKey = GlobalKey<FormState>();
    return GetX<WarpPurchaseController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 580,
            height: 330,
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
                        items: controller.Firm,
                        isValidate: firmC.value,
                        selectedItem: firm.value,
                        onChanged: (FirmModel item) {
                          firm.value = item;
                          firmId = item.id;
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
                        items: controller.supplierName,
                        isValidate: supplierC.value,
                        selectedItem: supplier.value,
                        onChanged: (LedgerModel item) {
                          supplier.value = item;
                          supplierId = item.id;
                          supplierC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: warpIdC.value,
                          onChanged: (value) => warpIdC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: warpIdController,
                          hintText: 'Warp ID No',
                          validate: warpIdC.value ? 'string' : '',
                          onChanged: (value) {
                            warpIdC.value = warpIdController.text.isNotEmpty;
                          },
                        )),
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
              if (warpTypeC.value == true) {
                request['warp_type'] = warpTypeController.text;
              }
              if (warpIdC.value == true) {
                request['warp_id'] = warpIdController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
