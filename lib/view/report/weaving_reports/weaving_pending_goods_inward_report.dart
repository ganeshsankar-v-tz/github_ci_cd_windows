import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/report/weaving_reports/weaving_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../flutter_core_widget.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';

class WeavingPendingGoodsInwardReport extends StatefulWidget {
  const WeavingPendingGoodsInwardReport({super.key});

  @override
  State<WeavingPendingGoodsInwardReport> createState() =>
      _WeavingPendingGoodsInwardReportState();
}

class _WeavingPendingGoodsInwardReportState
    extends State<WeavingPendingGoodsInwardReport> {
  WeavingReportController controller = Get.put(WeavingReportController());

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool weaverC = RxBool(false);
    RxBool loomC = RxBool(false);
    RxBool damagedC = RxBool(false);
    RxBool productNameC = RxBool(false);
    RxBool newC = RxBool(false);
    RxBool runningC = RxBool(false);
    RxBool completedC = RxBool(false);
    RxBool warpStatusC = RxBool(false);

    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();

    TextEditingController loomController = TextEditingController();
    TextEditingController isDamagedController =
        TextEditingController(text: 'Yes');
    var reportTypeController = TextEditingController(text: "PDF");

    int? weaverId;
    int? productNameId;

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
          title: const Text('Weaving...Pending Goods Inward Report'),
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
                              // SizedBox(width: 4),
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
                  ),
                  // const SizedBox(height: 20),
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
                  Row(
                    children: [
                      const SizedBox(width: 60),
                      MyDropdownButtonFormField(
                        controller: reportTypeController,
                        hintText: 'Report Type',
                        items: const ['PDF', 'EXCEL'],
                      ),
                    ],
                  ),
                  /*Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                          leading: Checkbox(
                            value: loomC.value,
                            onChanged: (value) => loomC.value = value!,
                          ),
                          subtitle: MyFilterTextField(
                            controller: loomController,
                            hintText: 'Loom',
                            onChanged: (value) {
                              loomC.value = loomController.text.isNotEmpty;
                            },
                          )),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                          leading: Checkbox(
                            value: damagedC.value,
                            onChanged: (value) => damagedC.value = value!,
                          ),
                          subtitle: MyDropdownButtonFormField(
                            controller: isDamagedController,
                            hintText: 'Is Damaged?',
                            items: const ['Yes', 'No'],
                            onChanged: (items) {
                              isDamagedController.text = items;
                              damagedC.value = true;
                            },
                          )),
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Text('Warp Status :')),
                  Obx(
                    () => SizedBox(
                      width: 430,
                      child: ListTile(
                        leading: Checkbox(
                          value: warpStatusC.value,
                          onChanged: (value) => warpStatusC.value = value!,
                        ),
                        subtitle: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 0.1)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(
                                () => LabeledCheckbox(
                                  label: "New",
                                  value: newC.value,
                                  onChanged: (value) {
                                    newC.value = value;
                                    warpStatusC.value = true;
                                  },
                                ),
                              ),
                              Obx(
                                () => LabeledCheckbox(
                                  label: "Running",
                                  value: runningC.value,
                                  onChanged: (value) {
                                    runningC.value = value;
                                    warpStatusC.value = true;
                                  },
                                ),
                              ),
                              Obx(
                                () => LabeledCheckbox(
                                  label: "Completed",
                                  value: completedC.value,
                                  onChanged: (value) {
                                    completedC.value = value;
                                    warpStatusC.value = true;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
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

                request["report_type"] =
                    reportTypeController.text.toLowerCase();

                if (dateC.value == true) {
                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;
                }
                if (weaverC.value == true) {
                  request['weaver_id'] = weaverId;
                }
                if (loomC.value == true) {
                  request['sub_weaver_no'] = loomController.text;
                }
                if (damagedC.value == true) {
                  request['damaged'] = isDamagedController.text;
                }
                if (productNameC.value == true) {
                  request['product_id'] = productNameId;
                }
                if (warpStatusC.value == true) {
                  var warpStatus = [];

                  if (newC.value == true) {
                    var data = {};
                    data["status"] = "New";
                    warpStatus.add(data);
                  }

                  if (runningC.value == true) {
                    var data = {};
                    data["status"] = "Running";
                    warpStatus.add(data);
                  }

                  if (completedC.value == true) {
                    var data = {};
                    data["status"] = "Completed";
                    warpStatus.add(data);
                  }

                  if (warpStatus.isEmpty) {
                    return AppUtils.infoAlert(
                        message: "Select any one of the warp statuses");
                  }

                  for (int i = 0; i < warpStatus.length; i++) {
                    request["current_status[$i]"] = warpStatus[i]["status"];
                  }
                }
                String? response = await controller
                    .weavingPendingGoodsInwardReport(request: request);
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
