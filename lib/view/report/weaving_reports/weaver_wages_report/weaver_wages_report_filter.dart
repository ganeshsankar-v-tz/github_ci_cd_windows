import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/weaving_reports/weaver_wages_report/weaver_wages_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../model/FirmModel.dart';
import '../../../../model/LedgerModel.dart';
import '../../../../widgets/MyAutoComplete.dart';
import '../../../../widgets/MyTextField.dart';

class WeaverWagesReport extends StatefulWidget {
  const WeaverWagesReport({super.key});

  @override
  State<WeaverWagesReport> createState() => _WeaverWagesReportState();
}

class _WeaverWagesReportState extends State<WeaverWagesReport> {
  WeaverWagesListReportController controller =
      Get.put(WeaverWagesListReportController());

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool weaverC = RxBool(false);
    RxBool loomC = RxBool(false);
    RxBool firmC = RxBool(false);
    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    Rxn<FirmModel> firmName = Rxn<FirmModel>();

    TextEditingController loomcontroller = TextEditingController();

    var weaverId;
    var firmId;

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);

    final formKey = GlobalKey<FormState>();
    return GetX<WeaverWagesListReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Weaving... Wages Reports'),
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
                                labelText: "Record From Date",
                                required: dateC.value,
                              ),
                              MyDateFilter(
                                controller: toDateController,
                                labelText: "Record To Date",
                                required: dateC.value,
                              ),
                            ],
                          )
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
                            firmName.value = item;
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
                          value: weaverC.value,
                          onChanged: (value) => weaverC.value = value!,
                        ),
                        subtitle: MyAutoComplete(
                          label: 'Weaver Name',
                          items: controller.ledgerlistweavers,
                          selectedItem: weaverName.value,
                          isValidate: weaverC.value,
                          onChanged: (LedgerModel item) {
                            weaverName.value = item;
                            weaverId = item.id;
                            weaverC.value = true;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 325,
                      child: ListTile(
                          leading: Checkbox(
                            value: loomC.value,
                            onChanged: (value) => loomC.value = value!,
                          ),
                          subtitle: MyTextField(
                            controller: loomcontroller,
                            hintText: 'Loom',
                            onChanged: (value) {
                              loomC.value = loomcontroller.text.isNotEmpty;
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
                onPressed: () => Get.back(),
                child: Text('CANCEL')),
            TextButton(
              child: const Text('SUBMIT'),
              onPressed: () async {
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

                if (weaverC.value == true) {
                  request['weaver_id'] = weaverId;
                }
                if (loomC.value == true) {
                  request['loom'] = loomcontroller.text;
                }
                Get.back();
                String? response =
                    await controller.weaverWagesReport(request: request);
                if (response != null) {
                  final Uri url = Uri.parse(response);
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $response');
                  }
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
