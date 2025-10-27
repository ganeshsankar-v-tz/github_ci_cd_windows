import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/process_reports/process_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComp.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class ProcessorProductBalance extends StatefulWidget {
  const ProcessorProductBalance({super.key});

  @override
  State<ProcessorProductBalance> createState() => _ProductDeliveryReportState();
}

class _ProductDeliveryReportState extends State<ProcessorProductBalance> {
  ProcessReportsController controller = Get.put(ProcessReportsController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool processorC = RxBool(false);
    RxBool firmC = RxBool(false);
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController upToDate = TextEditingController(text: today);
    Rxn<LedgerModel> processorName = Rxn<LedgerModel>();
    int? processorNameId;
    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    int? firmNameId;

    return GetBuilder<ProcessReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Process - Processor Product Balance'),
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
                        subtitle: Wrap(
                          children: [
                            MyDateFilter(
                              controller: upToDate,
                              labelText: "UpTo Date",
                              required: dateC.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: processorC.value,
                            onChanged: (value) => processorC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Process Name',
                            items: controller.processName,
                            selectedItem: processorName.value,
                            isValidate: processorC.value,
                            onChanged: (LedgerModel item) {
                              processorName.value = item;
                              processorNameId = item.id;
                              processorC.value = true;
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
                  if (processorC.value == true) {
                    request['processor_id'] = processorNameId;
                  }
                  if (firmC.value == true) {
                    request['firm_id'] = firmNameId;
                  }
                  // Get.back();
                  String? response = await controller.processorProductBalance(
                      request: request);
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
