import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/warping_reports/warping_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/YarnModel.dart';
import '../../../widgets/MyAutoComp.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class WarpingYarnBalanceReport extends StatefulWidget {
  const WarpingYarnBalanceReport({super.key});

  @override
  State<WarpingYarnBalanceReport> createState() =>
      _WarpingYarnBalanceReportState();
}

class _WarpingYarnBalanceReportState extends State<WarpingYarnBalanceReport> {
  WarpingReportsController controller = Get.put(WarpingReportsController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool warperC = RxBool(false);
    RxBool yarnC = RxBool(false);
    RxBool colorC = RxBool(false);
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController stockUpToController =
        TextEditingController(text: today);
    Rxn<LedgerModel> warperName = Rxn<LedgerModel>();
    int? warperNameId;
    Rxn<YarnModel> yarnName = Rxn<YarnModel>();
    int? yarnNameId;
    Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
    int? colorNameId;
    return GetBuilder<WarpingReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Warping - Yarn Balance Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 350,
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
                                  controller: stockUpToController,
                                  labelText: "Stock Upto",
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
                            value: colorC.value,
                            onChanged: (value) => colorC.value = value!,
                          ),
                          subtitle: MyAutoComp(
                            label: 'Color Name',
                            items: controller.colorName,
                            selectedItem: colorName.value,
                            isValidate: colorC.value,
                            onChanged: (NewColorModel item) {
                              colorName.value = item;
                              colorNameId = item.id;
                              colorC.value = true;
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
                    request['stock_upto'] = stockUpToController.text;
                  }
                  if (warperC.value == true) {
                    request['warper_id'] = warperNameId;
                  }
                  if (yarnC.value == true) {
                    request['yarn_id'] = yarnNameId;
                  }
                  if (colorC.value == true) {
                    request['color_id'] = colorNameId;
                  }
                  // Get.back();
                  String? response = await controller.warpingYarnBalanceReport(
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
