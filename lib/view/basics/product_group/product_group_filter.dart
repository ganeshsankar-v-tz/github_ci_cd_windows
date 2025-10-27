import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/ProductUnitModel.dart';
import 'package:abtxt/view/basics/product_group/product_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyFilterTextField.dart';

class ProductGroupFilter extends StatelessWidget {
  const ProductGroupFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool supplierC = RxBool(false);
    RxBool designNoC = RxBool(false);
    RxBool unitC = RxBool(false);
    RxBool dateC = RxBool(true);


    Rxn<LedgerModel> supplierName = Rxn<LedgerModel>();
    Rxn<ProductUnitModel> unitName = Rxn<ProductUnitModel>();


    TextEditingController designNoController = TextEditingController();
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
    TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);


    var supplier;
    var unit;

    final _formKey = GlobalKey<FormState>();
    return GetX<ProductGroupController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 570,
            height: 380,
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
                        value: supplierC.value,
                        onChanged: (value) => supplierC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Supplier',
                        items: controller.suplier_name,
                        isValidate: supplierC.value,
                        selectedItem: supplierName.value,
                        onChanged: (LedgerModel item) {
                          supplierName.value = item;
                          supplier = item.ledgerName;
                          supplierC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: unitC.value,
                        onChanged: (value) => unitC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Unit',
                        items: controller.productUnit,
                        isValidate: unitC.value,
                        selectedItem: unitName.value,
                        onChanged: (ProductUnitModel item) {
                          unitName.value =item;
                          unit = item.unitName;
                          unitC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: designNoC.value,
                        onChanged: (value) => designNoC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: designNoController,
                        hintText: 'Design No',
                        validate: designNoC.value ? 'string' : '',
                        onChanged: (value){
                          designNoC.value = designNoController.text.isNotEmpty;
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
              if (!_formKey.currentState!.validate()) {
                return;
              }
              var request = {};

              if (supplierC.value == true) {
                request['suplier'] = supplier;
              }
              if (designNoC.value == true) {
                request['design_no'] = designNoController.text;
              }
              if (unitC.value == true) {
                request['unit'] = unit;
              }
              if (dateC.value == true) {
                request['from_date'] = fromDateController.text;
                request['to_date'] = toDateController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
