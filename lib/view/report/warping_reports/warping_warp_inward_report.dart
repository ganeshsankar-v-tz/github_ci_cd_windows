import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/warping_reports/warping_reports_controller.dart';
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
import '../../../widgets/my_dropdowns/MyMultiSelectDropdown.dart';

class WarpingWarpInwardReport extends StatefulWidget {
  const WarpingWarpInwardReport({super.key});

  @override
  State<WarpingWarpInwardReport> createState() =>
      _WarpingWarpInwardReportState();
}

class _WarpingWarpInwardReportState extends State<WarpingWarpInwardReport> {
  WarpingReportsController controller = Get.put(WarpingReportsController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool warperC = RxBool(false);
    RxBool firmC = RxBool(false);
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    Rxn<FirmModel> firmName = Rxn<FirmModel>();

    RxList<LedgerModel> selectedWarperName = <LedgerModel>[].obs;
    var firmNameId;

    return GetBuilder<WarpingReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Warping - Warp Inward Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
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
                        subtitle: MyMultiSelectDropdown(
                          items: controller.warperName,
                          label: "Warper Name",
                          isValidate: warperC.value,
                          onConfirm: (item) {
                            var res = item.cast<LedgerModel>();
                            warperC.value = true;
                            selectedWarperName.value = res.toList();
                            controller.update();
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
                }
                if (warperC.value == true) {
                  for (int i = 0; i < selectedWarperName.length; i++) {
                    request['warper_id[$i]'] = selectedWarperName[i].id;
                  }
                }
                if (firmC.value == true) {
                  request['firm_id'] = firmNameId;
                }

                // Get.back();
                String? response =
                    await controller.warpingWarpInwardReport(request: request);
                if (response != null) {
                  final Uri url = Uri.parse(response);
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $response');
                  }
                }
              },
              child: const Text('SUBMIT'),
            )
          ],
        ),
      );
    });
  }
}
