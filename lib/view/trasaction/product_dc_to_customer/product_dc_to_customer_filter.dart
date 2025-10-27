import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/trasaction/product_dc_to_customer/product_dc_to_customer_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyFilterTextField.dart';

class ProductDcToCustomerFilter extends StatelessWidget {
  const ProductDcToCustomerFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool customerC = RxBool(false);
    RxBool firmC = RxBool(false);
    RxBool dcNoC = RxBool(false);

    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    Rxn<LedgerModel> customerName = Rxn<LedgerModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController dcNoController = TextEditingController();
    int? firmId;
    int? customerId;
    final formKey = GlobalKey<FormState>();
    return GetX<ProductDcToCustomerController>(builder: (controller) {
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
                        value: customerC.value,
                        onChanged: (value) => customerC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Customer Name',
                        items: controller.Customer,
                        selectedItem: customerName.value,
                        isValidate: customerC.value,
                        onChanged: (LedgerModel item) {
                          customerId = item.id;
                          customerName.value = item;
                          customerC.value = true;
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
                        items: controller.firmName,
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
                        value: dcNoC.value,
                        onChanged: (value) => dcNoC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: dcNoController,
                        hintText: "D.C No",
                        validate: dcNoC.value ? 'number' : '',
                        onChanged: (value) {
                          dcNoC.value = dcNoController.text.isNotEmpty;
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
              if (customerC.value == true) {
                request['customer_id'] = customerId;
              }
              if (dcNoC.value == true) {
                request['dc_no'] = dcNoController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
