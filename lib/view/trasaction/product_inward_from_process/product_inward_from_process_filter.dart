import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/trasaction/product_inward_from_process/product_inward_from_process_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class ProductInwardFromProcessFilter extends StatelessWidget {
  const ProductInwardFromProcessFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool firmC = RxBool(false);
    RxBool processorC = RxBool(false);

    Rxn<LedgerModel> process = Rxn<LedgerModel>();
    Rxn<FirmModel> firmName = Rxn<FirmModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController slipNo = TextEditingController();
    int? firmId;
    int? processorId;
    final formKey = GlobalKey<FormState>();
    return GetX<ProductInwardFromProcessController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 570,
            height: 270,
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
                        Row(
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
                        value: processorC.value,
                        onChanged: (value) => processorC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Processor',
                        selectedItem: process.value,
                        items: controller.processorName,
                        isValidate: processorC.value,
                        onChanged: (LedgerModel item) {
                          processorId = item.id;
                          process.value = item;
                          processorC.value = true;
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
              if (processorC.value == true) {
                request['processor_id'] = processorId;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
