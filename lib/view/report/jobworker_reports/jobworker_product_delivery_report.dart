import 'package:abtxt/flutter_core_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComp.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import 'jobworker_reports_controller.dart';

class JobworkerProductDeliveryReport extends StatefulWidget {
  const JobworkerProductDeliveryReport({super.key});

  @override
  State<JobworkerProductDeliveryReport> createState() =>
      _JobworkerProductDeliveryReportState();
}

class _JobworkerProductDeliveryReportState
    extends State<JobworkerProductDeliveryReport> {
  JobworkerReportsController controller = Get.put(JobworkerReportsController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool jobworkC = RxBool(false);
    RxBool firmC = RxBool(false);
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    Rxn<LedgerModel> jobWorkerName = Rxn<LedgerModel>();
    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    var jobWorkerNameId;
    var firmNameId;
    return GetBuilder<JobworkerReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: Text('Jobworker - Product Delivery Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 250,
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
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              children: [
                                MyDateFilter(
                                  controller: fromDateController,
                                  labelText: "From Date",
                                  required: dateC.value,
                                ),
                                MyDateFilter(
                                  controller: toDateController,
                                  labelText: "To Date",
                                  required: dateC.value,
                                ),
                              ],
                            )
                          ],
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
                          subtitle: MyAutoComp(
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
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Get.back(), child: Text('CANCEL')),
            TextButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  var request = {};
                  if (dateC.value == true) {
                    request['from_date'] = fromDateController.text;
                    request['to_date'] = toDateController.text;
                  }
                  if (jobworkC.value == true) {
                    request['job_worker_id'] = jobWorkerNameId;
                  }
                  if (firmC.value == true) {
                    request['firm_id'] = firmNameId;
                  }
                  // Get.back();
                  String? response = await controller
                      .jobworkerProductDeliveryReport(request: request);
                  if (response != null) {
                    final Uri url = Uri.parse(response);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $response');
                    }
                  }
                },
                child: Text('SUBMIT'))
          ],
        ),
      );
    });
  }
}
