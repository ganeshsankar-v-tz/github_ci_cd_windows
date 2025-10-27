import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/view/trasaction/product_order/product_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class ProductOrderFilter extends StatelessWidget {
  const ProductOrderFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool firmC = RxBool(false);
    RxBool customerNameC = RxBool(false);
    RxBool productC = RxBool(false);

    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    Rxn<LedgerModel> customerName = Rxn<LedgerModel>();
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController productNameController = TextEditingController();

    final FocusNode submitFocusNode = FocusNode();
    final FocusNode productFocusNode = FocusNode();

    int? firmId;
    int? customerId;
    int? productId;
    final formKey = GlobalKey<FormState>();
    return GetX<ProductOrderController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 570,
            height: 370,
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
                        value: customerNameC.value,
                        onChanged: (value) => customerNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Customer',
                        items: controller.customerName,
                        selectedItem: customerName.value,
                        isValidate: customerNameC.value,
                        onChanged: (LedgerModel item) {
                          customerId = item.id;
                          customerName.value = item;
                          customerNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 425,
                    child: ListTile(
                      leading: Checkbox(
                        value: productC.value,
                        onChanged: (value) => productC.value = value!,
                      ),
                      subtitle: MySearchField(
                        width: 350,
                        label: "Product Name",
                        items: controller.productName,
                        textController: productNameController,
                        focusNode: productFocusNode,
                        requestFocus: submitFocusNode,
                        onChanged: (ProductInfoModel item) {
                          productId = item.id;
                          productName.value = item;
                          productC.value = true;
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
            focusNode: submitFocusNode,
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
              if (customerNameC.value == true) {
                request['customer_id'] = customerId;
              }
              if (productC.value == true) {
                request['product_id'] = productId;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
