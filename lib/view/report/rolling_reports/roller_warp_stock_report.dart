import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/rolling_reports/rolling_report_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyFilterTextField.dart';

class RollerWarpStockReport extends StatefulWidget {
  const RollerWarpStockReport({super.key});

  @override
  State<RollerWarpStockReport> createState() => _RollerWarpStockReportState();
}

class _RollerWarpStockReportState extends State<RollerWarpStockReport> {
  RollingReportsController controller = Get.put(RollingReportsController());

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool rollerC = RxBool(false);
    RxBool warpDesignC = RxBool(false);
    RxBool detailsC = RxBool(false);
    Rxn<LedgerModel> roller = Rxn<LedgerModel>();
    Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();
    int? rollerId;
    int? warpDesignId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController stockUptoController =
        TextEditingController(text: today);
    TextEditingController detailsController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return GetBuilder<RollingReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Roller - Warp Stock Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 480,
              height: 330,
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
                                  controller: stockUptoController,
                                  labelText: "Stock Upto",
                                  required: dateC.value,
                                ),
                                // SizedBox(width: 4),
                              ],
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
                            value: rollerC.value,
                            onChanged: (value) => rollerC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Roller',
                            items: controller.ledgerDropdown,
                            selectedItem: roller.value,
                            isValidate: rollerC.value,
                            onChanged: (LedgerModel item) {
                              roller.value = item;
                              rollerId = item.id;
                              rollerC.value = true;
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
                            value: warpDesignC.value,
                            onChanged: (value) => warpDesignC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Warp Design',
                            items: controller.warpDesignDropdown,
                            selectedItem: warpDesign.value,
                            isValidate: warpDesignC.value,
                            onChanged: (NewWarpModel item) {
                              warpDesignId = item.id;
                              warpDesign.value = item;
                              warpDesignC.value = true;
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
                            value: detailsC.value,
                            onChanged: (value) => detailsC.value = value!,
                          ),
                          subtitle: MyFilterTextField(
                            controller: detailsController,
                            hintText: "Details",
                            validate: detailsC.value ? 'string' : '',
                            onChanged: (value) {
                              detailsC.value =
                                  detailsController.text.isNotEmpty;
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
              child: const Text('SUBMIT'),
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                var request = {};
                if (dateC.value == true) {
                  request['upto_date'] = stockUptoController.text;
                }
                if (rollerC.value == true) {
                  request['roller_id'] = rollerId;
                }
                if (warpDesignC.value == true) {
                  request['warp_design_id'] = warpDesignId;
                }
                if (detailsC.value == true) {
                  request['details'] = detailsController.text;
                }
                String? response = await controller
                    .rollingWarpInwardStockReport(request: request);
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
