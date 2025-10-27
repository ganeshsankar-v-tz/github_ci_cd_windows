import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/report/yarn__reports/yarn_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyFilterTextField.dart';

class YarnSaleReport extends StatefulWidget {
  const YarnSaleReport({super.key});

  @override
  State<YarnSaleReport> createState() => _YarnSaleReportState();
}

class _YarnSaleReportState extends State<YarnSaleReport> {
  YarnReportController controller = Get.put(YarnReportController());
  TextEditingController billNoController = TextEditingController();
  TextEditingController lrNoController = TextEditingController();
  TextEditingController netTotalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool customerC = RxBool(false);
    RxBool firmC = RxBool(false);
    RxBool billnoC = RxBool(false);
    RxBool lrnoC = RxBool(false);
    RxBool netTotalC = RxBool(false);
    Rxn<LedgerModel> winder = Rxn<LedgerModel>();
    Rxn<FirmModel> firm = Rxn<FirmModel>();
    var supplierId;
    var firmId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<YarnReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Yarn Sale Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 480,
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
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: customerC.value,
                            onChanged: (value) => customerC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Customer Name',
                            items: controller.ledgerDropdown,
                            selectedItem: winder.value,
                            isValidate: customerC.value,
                            onChanged: (LedgerModel item) {
                              winder.value = item;
                              supplierId = item.id;
                              customerC.value = true;
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
                            value: billnoC.value,
                            onChanged: (value) => billnoC.value = value!,
                          ),
                          subtitle: MyFilterTextField(
                            controller: billNoController,
                            hintText: "Bill No",
                            validate: billnoC.value ? 'string' : '',
                            onChanged: (value) {
                               billnoC.value = billNoController.text.isNotEmpty;
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
                            value: lrnoC.value,
                            onChanged: (value) => lrnoC.value = value!,
                          ),
                          subtitle: MyFilterTextField(
                            controller: lrNoController,
                            hintText: "L.R. No",
                            validate: lrnoC.value ? 'string' : '',
                            onChanged: (value) {
                               lrnoC.value = lrNoController.text.isNotEmpty;
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
                            value: netTotalC.value,
                            onChanged: (value) => netTotalC.value = value!,
                          ),
                          subtitle: MyFilterTextField(
                            controller: netTotalController,
                            hintText: "Net.total",
                            validate: netTotalC.value ? 'string' : '',
                            onChanged: (value) {
                              netTotalC.value = netTotalController.text.isNotEmpty;
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
                if (customerC.value == true) {
                  request['customer_id'] = supplierId;
                }
                if (firmC.value == true) {
                  request['firm_id'] = firmId;
                }
                if (billnoC.value == true) {
                  request['bill_no'] = billNoController.text;
                }
                if (lrnoC.value == true) {
                  request['lr_no'] = lrNoController.text;
                }
                if (netTotalC.value == true) {
                  request['net_total'] = netTotalController.text;
                }
                // Get.back();
                String? response =
                    await controller.yarnSaleReport(request: request);
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
