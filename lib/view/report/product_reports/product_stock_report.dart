import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/product_reports/product_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../widgets/MyAutoComplete.dart';

class ProductStockReport extends StatefulWidget {
  const ProductStockReport({super.key});

  @override
  State<ProductStockReport> createState() => _ProductStockReportState();
}

class _ProductStockReportState extends State<ProductStockReport> {
  ProductReportController controller = Get.put(ProductReportController());
  TextEditingController reportTypeController =
      TextEditingController(text: 'Complete Stock');
  TextEditingController warpTypeController =
      TextEditingController(text: 'Other');
  TextEditingController designNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool groupC = RxBool(false);
    RxBool productNameC = RxBool(false);
    RxBool reportTypeC = RxBool(false);
    RxBool warpTypeC = RxBool(false);
    RxBool warpIDC = RxBool(false);
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
    Rxn<ProductGroupModel> groupName = Rxn<ProductGroupModel>();

    var groupId;
    var productNameId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<ProductReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Product Stock Report'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 550,
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
                              value: warpIDC.value,
                              onChanged: (value) => warpIDC.value = value!,
                            ),
                            subtitle: MyTextField(
                              controller: designNoController,
                              hintText: 'Design No',
                              onChanged: (value) {
                                warpIDC.value =
                                    designNoController.text.isNotEmpty;
                              },
                            )),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                            leading: Checkbox(
                              value: warpTypeC.value,
                              onChanged: (value) => warpTypeC.value = value!,
                            ),
                            subtitle: MyDropdownButtonFormField(
                              controller: warpTypeController,
                              hintText: 'Warp Type',
                              items: const [
                                'Other',
                                'Main',
                              ],
                              onChanged: (value) {
                                warpTypeC.value = true;
                              },
                            )),
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
                                'Complete Stock',
                                'Hand Stock Only',
                                'Hand Stock Only - Last Pur.Rate',
                                'Total Inward',
                                'Total OutWard',
                                'Group Stock',
                                'Category Stock',
                                'Hand Stock -Product Only',
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
                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;
                }
                if (groupC.value == true) {
                  request['winder_id'] = groupId;
                }
                if (productNameC.value == true) {
                  request['product_id'] = productNameId;
                }
                if (warpIDC.value == true) {
                  request['warp_id'] = designNoController.text;
                }
                if (reportTypeC.value == true) {
                  request['winder_id'] = reportTypeController.text;
                }
                if (warpTypeC.value == true) {
                  request['winder_id'] = warpTypeController.text;
                }
                // Get.back();
                String? response =
                await controller.producStockReport(request: request);
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
