import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/report/warping_reports/warping_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/YarnModel.dart';
import '../../../widgets/MyAutoComp.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class WarpingYarnDeliveryReport extends StatefulWidget {
  const WarpingYarnDeliveryReport({super.key});

  @override
  State<WarpingYarnDeliveryReport> createState() =>
      _WarpingYarnDeliveryReportState();
}

class _WarpingYarnDeliveryReportState extends State<WarpingYarnDeliveryReport> {
  WarpingReportsController controller = Get.put(WarpingReportsController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool warperC = RxBool(false);
    RxBool firmC = RxBool(false);
    RxBool yarnC = RxBool(false);
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    Rxn<LedgerModel> warperName = Rxn<LedgerModel>();
    int? warperNameId;
    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    int? firmNameId;
    Rxn<YarnModel> yarnName = Rxn<YarnModel>();
    int? yarnNameId;
    return GetBuilder<WarpingReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Warping - Yarn Delivery Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 360,
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
                            value: warperC.value,
                            onChanged: (value) => warperC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Warper Name',
                            items: controller.warperName,
                            selectedItem: warperName.value,
                            isValidate: warperC.value,
                            onChanged: (LedgerModel item) {
                              warperName.value = item;
                              warperNameId = item.id;
                              warperC.value = true;
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
                            value: yarnC.value,
                            onChanged: (value) => yarnC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Yarn Name',
                            items: controller.yarnName,
                            selectedItem: yarnName.value,
                            isValidate: yarnC.value,
                            onChanged: (YarnModel item) {
                              yarnName.value = item;
                              yarnNameId = item.id;
                              yarnC.value = true;
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
                    request['from_date'] = fromDateController.text;
                    request['to_date'] = toDateController.text;
                  } else {
                    return AppUtils.infoAlert(
                        message: "From date and To date required");
                  }
                  if (warperC.value == true) {
                    request['warper_id'] = warperNameId;
                  }
                  if (firmC.value == true) {
                    request['firm_id'] = firmNameId;
                  }
                  if (yarnC.value == true) {
                    request['yarn_id'] = yarnNameId;
                  }
                  // Get.back();
                  String? response = await controller.warpingYarnDeliveryReport(
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
