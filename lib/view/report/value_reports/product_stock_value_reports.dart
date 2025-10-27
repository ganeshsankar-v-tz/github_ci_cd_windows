import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/value_reports/value_report_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../widgets/MyAutoComplete.dart';

class ProductStockValueReport extends StatefulWidget {
  const ProductStockValueReport({super.key});

  @override
  State<ProductStockValueReport> createState() =>
      _ProductStockValueReportState();
}

class _ProductStockValueReportState extends State<ProductStockValueReport> {
  ValueReportController controller = Get.put(ValueReportController());
  TextEditingController reportTypeController =
      TextEditingController(text: 'Detailed');

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool productNameC = RxBool(false);
    RxBool groupC = RxBool(false);
    RxBool reportTypeC = RxBool(false);
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
    Rxn<ProductGroupModel> groupName = Rxn<ProductGroupModel>();
    var productNameId;
    var groupId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController stockUptoController =
        TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<ValueReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Product Stock Report - Value Reports'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 480,
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
                                  controller: stockUptoController,
                                  labelText: "Stock Up To",
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
                              value: reportTypeC.value,
                              onChanged: (value) => reportTypeC.value = value!,
                            ),
                            subtitle: MyDropdownButtonFormField(
                              controller: reportTypeController,
                              hintText: 'Report Type',
                              items: const [
                                'Detailed',
                                'Summary',
                                'Detailed-Last Pur.Rate',
                              ],
                              onChanged: (value) {
                                reportTypeC.value = true;
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
                  request['from_date'] = stockUptoController.text;
                }
                if (productNameC.value == true) {
                  request['product_id'] = productNameId;
                }
                if (groupC.value == true) {
                  request['winder_id'] = groupId;
                }
                if (reportTypeC.value == true) {
                  request['winder_id'] = reportTypeController.text;
                }
                Get.back();
                String? response =
                await controller.productStockValueReport(request: request);
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
