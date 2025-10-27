import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/product_deliver_to_jobworker_controller.dart';
import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class ProductDeliverytoJobWorkerFilter extends StatelessWidget {
  const ProductDeliverytoJobWorkerFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool firmC = RxBool(false);
    RxBool jobWorkerC = RxBool(false);
    RxBool dcNoC = RxBool(false);

    Rxn<FirmModel> firmname = Rxn<FirmModel>();
    Rxn<LedgerModel> jobWorker = Rxn<LedgerModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController dcNo = TextEditingController();
    int? firmId;
    int? jobWorkerId;
    final formKey = GlobalKey<FormState>();
    return GetX<ProductDeliverToJobWorkerController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 580,
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
                        value: firmC.value,
                        onChanged: (value) => firmC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Firm',
                        selectedItem: firmname.value,
                        items: controller.firmName,
                        isValidate: firmC.value,
                        onChanged: (FirmModel item) {
                          firmId = item.id;
                          firmname.value = item;
                          firmC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: jobWorkerC.value,
                        onChanged: (value) => jobWorkerC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'JobWorker',
                        selectedItem: jobWorker.value,
                        items: controller.jobWorkerName,
                        isValidate: jobWorkerC.value,
                        onChanged: (LedgerModel item) {
                          jobWorkerId = item.id;
                          jobWorker.value = item;
                          jobWorkerC.value = true;
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
                        controller: dcNo,
                        hintText: "D.C No",
                        validate: dcNoC.value ? 'number' : '',
                        onChanged: (value) {
                          dcNoC.value = dcNo.text.isNotEmpty;
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
              if (jobWorkerC.value == true) {
                request['job_worker_id'] = jobWorkerId;
              }
              if (dcNoC.value == true) {
                request['dc_no'] = dcNo.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
