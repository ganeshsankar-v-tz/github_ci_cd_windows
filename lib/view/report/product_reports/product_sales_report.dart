import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/product_reports/product_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComp.dart';
import '../../../widgets/MyAutoComplete.dart';

class ProductSalesReport extends StatefulWidget {
  const ProductSalesReport({super.key});

  @override
  State<ProductSalesReport> createState() => _ProductSalesReportState();
}

class _ProductSalesReportState extends State<ProductSalesReport> {
  ProductReportController controller = Get.put(ProductReportController());

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool customerC = RxBool(false);
    RxBool firmC = RxBool(false);
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController reportTypeController =
        TextEditingController(text: "Detailed");

    Rxn<LedgerModel> customer = Rxn<LedgerModel>();
    Rxn<FirmModel> firm = Rxn<FirmModel>();
    int? customerId;
    int? firmId;

    final formKey = GlobalKey<FormState>();
    return GetBuilder<ProductReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Product Sales Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 340,
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
                          subtitle: MyAutoComp(
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
                    Row(
                      children: [
                        const SizedBox(width: 60),
                        MyDropdownButtonFormField(
                          controller: reportTypeController,
                          hintText: "Report Type",
                          items: const ["Detailed", "Summary"],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
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
                request["report_type"] = reportTypeController.text;
                // Get.back();
                String? response =
                    await controller.productSaleReport(request: request);
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
