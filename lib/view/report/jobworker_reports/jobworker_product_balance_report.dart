import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/jobworker_reports/jobworker_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/ProductJobWork.dart';
import '../../../widgets/MyAutoComp.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class JobworkerProductBalanceReport extends StatefulWidget {
  const JobworkerProductBalanceReport({super.key});

  @override
  State<JobworkerProductBalanceReport> createState() =>
      _JobworkerProductBalanceReportState();
}

class _JobworkerProductBalanceReportState
    extends State<JobworkerProductBalanceReport> {
  JobworkerReportsController controller = Get.put(JobworkerReportsController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool jobworkC = RxBool(false);
    RxBool firmC = RxBool(false);
    RxBool productNameC = RxBool(false);
    RxBool orderWorkC = RxBool(false);
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController upToDate = TextEditingController(text: today);
    Rxn<LedgerModel> jobWorkerName = Rxn<LedgerModel>();
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
    Rxn<ProductJobWork> orderWork = Rxn<ProductJobWork>();
    int? jobWorkerNameId;
    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    int? firmNameId;
    int? productNameId;
    int? orderedWorkId;

    return GetBuilder<JobworkerReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Jobworker - Product Balance Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ListTile(
                        leading: Checkbox(
                          value: dateC.value,
                          onChanged: (value) {
                            dateC.value = value!;
                          },
                        ),
                        subtitle: MyDateFilter(
                          controller: upToDate,
                          labelText: "UpTo Date",
                          required: dateC.value,
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: jobworkC.value,
                            onChanged: (value) => jobworkC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'JobWorker Name',
                            items: controller.jobWorkerName,
                            selectedItem: jobWorkerName.value,
                            isValidate: jobworkC.value,
                            onChanged: (LedgerModel item) {
                              jobWorkerName.value = item;
                              jobWorkerNameId = item.id;
                              jobworkC.value = true;
                            },
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: firmC.value,
                            onChanged: (value) => firmC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Firm Name',
                            items: controller.firmName,
                            selectedItem: firmName.value,
                            isValidate: firmC.value,
                            onChanged: (FirmModel item) {
                              firmName.value = item;
                              firmNameId = item.id;
                              firmC.value = true;
                            },
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: productNameC.value,
                            onChanged: (value) => productNameC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Product Name',
                            items: controller.ProductNameList,
                            selectedItem: productName.value,
                            isValidate: productNameC.value,
                            onChanged: (ProductInfoModel item) {
                              productName.value = item;
                              productNameId = item.id;
                              productNameC.value = true;
                            },
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: orderWorkC.value,
                            onChanged: (value) => orderWorkC.value = value!,
                          ),
                          subtitle: MyAutoComp(
                            label: 'Ordered Work',
                            items: controller.orderedWork,
                            selectedItem: orderWork.value,
                            isValidate: orderWorkC.value,
                            onChanged: (ProductJobWork item) {
                              orderWork.value = item;
                              orderedWorkId = item.id;
                              orderWorkC.value = true;
                            },
                          ),
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
                onPressed: () => Get.back(), child: const Text('CANCEL')),
            TextButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  var request = {};
                  if (dateC.value == true) {
                    request['upto_date'] = upToDate.text;
                  }
                  if (jobworkC.value == true) {
                    request['job_worker_id'] = jobWorkerNameId;
                  }
                  if (firmC.value == true) {
                    request['firm_id'] = firmNameId;
                  }
                  if (productNameC.value == true) {
                    request['product_id'] = productNameId;
                  }
                  if (orderWorkC.value == true) {
                    request['order_work_id'] = orderedWorkId;
                  }
                  // Get.back();
                  String? response = await controller
                      .jobworkerProductBalanceReport(request: request);
                  if (response != null) {
                    final Uri url = Uri.parse(response);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $response');
                    }
                  }
                },
                child: const Text('SUBMIT'))
          ],
        ),
      );
    });
  }
}
