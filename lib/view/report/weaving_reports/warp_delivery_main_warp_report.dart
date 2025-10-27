import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/value_reports/value_report_controller.dart';
import 'package:abtxt/view/report/weaving_reports/weaving_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';

class WeavingMainWarpDeliveryReport extends StatefulWidget {
  const WeavingMainWarpDeliveryReport({super.key});

  @override
  State<WeavingMainWarpDeliveryReport> createState() =>
      _WeavingMainWarpDeliveryReportState();
}

class _WeavingMainWarpDeliveryReportState
    extends State<WeavingMainWarpDeliveryReport> {
  WeavingReportController controller = Get.put(WeavingReportController());

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool firmC = RxBool(false);
    RxBool groupC = RxBool(false);
    RxBool weaverC = RxBool(false);
    RxBool loomC = RxBool(false);
    RxBool showC = RxBool(false);
    Rxn<FirmModel> firm = Rxn<FirmModel>();
    Rxn<ProductGroupModel> groupName = Rxn<ProductGroupModel>();
    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    TextEditingController showController =
        TextEditingController(text: 'Detailed');
    TextEditingController loomcontroller = TextEditingController();

    var firmId;
    var groupId;
    var weaverId;

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);

    final formKey = GlobalKey<FormState>();
    return GetBuilder<WeavingReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Weaving...(Main) Warp Delivery Report'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                            value: firmC.value,
                            onChanged: (value) => firmC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Firm',
                            items: controller.firmDropdown,
                            selectedItem: firm.value,
                            isValidate: firmC.value,
                            onChanged: (FirmModel item) {
                              firm.value = item;
                              firmId = item.id;
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
                            value: groupC.value,
                            onChanged: (value) => groupC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Group',
                            items: controller.groups,
                            selectedItem: groupName.value,
                            isValidate: groupC.value,
                            onChanged: (ProductGroupModel item) {
                              groupName.value = item;
                              groupId = item.id;
                              groupC.value = true;
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
                    ),
                    Obx(
                      () => SizedBox(
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
               /* if (groupC.value == true) {
                  request['winder_id'] = groupId;
                }*/
                if (weaverC.value == true) {
                  request['weaver_id'] = weaverId;
                }
               /* if (showC.value == true) {
                  request['winder_id'] = showController.text;
                }*/
                if (loomC.value == true) {
                  request['loom'] = loomcontroller.text;
                }
                // Get.back();
                String? response =
                await controller.warpDeliveryMainWarpReport(request: request);
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
