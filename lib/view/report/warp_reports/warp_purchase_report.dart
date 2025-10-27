import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/report/warp_reports/warp_report_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyFilterTextField.dart';

class WarpPurchaseReport extends StatefulWidget {
  const WarpPurchaseReport({super.key});

  @override
  State<WarpPurchaseReport> createState() => _WarpPurchaseReportState();
}

class _WarpPurchaseReportState extends State<WarpPurchaseReport> {
  WarpReportController controller = Get.put(WarpReportController());
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool supplierC = RxBool(false);
    RxBool firmC = RxBool(false);
    RxBool detailsC = RxBool(false);
    Rxn<LedgerModel> supplier = Rxn<LedgerModel>();
    Rxn<FirmModel> firm = Rxn<FirmModel>();
    var supplierId;
    var firmId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<WarpReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Warp Purchase Report'),
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
                            value: supplierC.value,
                            onChanged: (value) => supplierC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Supplier Name',
                            items: controller.ledgerDropdown,
                            selectedItem: supplier.value,
                            isValidate: supplierC.value,
                            onChanged: (LedgerModel item) {
                              supplier.value = item;
                              supplierId = item.id;
                              supplierC.value = true;
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
                            value: detailsC.value,
                            onChanged: (value) => detailsC.value = value!,
                          ),
                          subtitle: MyFilterTextField(
                            controller: detailsController,
                            hintText: "Details",
                            validate: detailsC.value ? 'string' : '',
                            onChanged: (value) {
                              detailsC.value = detailsController.text.isNotEmpty;
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
                if (supplierC.value == true) {
                  request['supplier_id'] = supplierId;
                }
                if (firmC.value == true) {
                  request['firm_id'] = firmId;
                }
                if (detailsC.value == true) {
                  request['details'] = detailsController.text;
                }
                // Get.back();
                String? response =
                    await controller.warpPurchaseReport(request: request);
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
