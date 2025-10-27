import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/report/warp_reports/warp_report_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
//import '../../../widgets/MyDropdownButtonFormField.dart';

class WarpSaleReport extends StatefulWidget {
  const WarpSaleReport({super.key});

  @override
  State<WarpSaleReport> createState() => _WarpSaleReportState();
}

class _WarpSaleReportState extends State<WarpSaleReport> {
  WarpReportController controller = Get.put(WarpReportController());
  TextEditingController reportTypeController =
      TextEditingController(text: 'Brief');

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool customerC = RxBool(false);
    RxBool firmC = RxBool(false);
   // RxBool reportTypeC = RxBool(false);

    Rxn<LedgerModel> customer = Rxn<LedgerModel>();
    Rxn<FirmModel> firm = Rxn<FirmModel>();
    var customerId;
    var firmId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController = TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<WarpReportController>(builder: (controller) {
      return AlertDialog(
        title: const Text('Warp Sales Report'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                          value: customerC.value,
                          onChanged: (value) => customerC.value = value!,
                        ),
                        subtitle: MyAutoComplete(
                          label: 'Customer Name',
                          items: controller.ledgerlistCustomers,
                          selectedItem: customer.value,
                          isValidate: customerC.value,
                          onChanged: (LedgerModel item) {
                            customer.value = item;
                            customerId = item.id;
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
                  /*Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                          leading: Checkbox(
                            value: reportTypeC.value,
                            onChanged: (value) => reportTypeC.value = value!,
                          ),
                          subtitle: MyDropdownButtonFormField(
                            controller: reportTypeController,
                            hintText: 'Report Type',
                            items: const [
                              "Brief",
                              "Brief-M2",
                              "Detailed",
                              "Detailed-M2",
                              "Detailed-SPL",
                              "Summary",
                              "Summary-Monthwise"
                            ],
                            onChanged: (Value) {
                              reportTypeC.value = true;
                            },
                          )),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
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
                request['customer_id'] = customerId;
              }
              if (firmC.value == true) {
                request['firm_id'] = firmId;
              }
              // Get.back();
              String? response =
                  await controller.warpSaleReport(request: request);
              if (response != null) {
                final Uri url = Uri.parse(response);
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $response');
                }
              }
            },
          ),
        ],
      );
    });
  }
}
