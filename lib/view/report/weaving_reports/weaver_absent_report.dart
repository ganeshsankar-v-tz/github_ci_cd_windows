import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/weaving_reports/weaving_reports_controller.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';

class WeaverAbsentReport extends StatefulWidget {
  const WeaverAbsentReport({super.key});

  @override
  State<WeaverAbsentReport> createState() => _WeaverAbsentReportState();
}

class _WeaverAbsentReportState extends State<WeaverAbsentReport> {
  WeavingReportController controller = Get.put(WeavingReportController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool productNameC = RxBool(false);
    RxBool weaverNameC = RxBool(false);
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    int? productNameId;
    int? weaverId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController productController = TextEditingController();
    TextEditingController formatController =
        TextEditingController(text: "Excel");
    final FocusNode productFocusNode = FocusNode();
    final FocusNode formatFocusNode = FocusNode();

    return GetBuilder<WeavingReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Weaver Absent Report(Goods Inward)'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 320,
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
                                  enabled: dateC.value,
                                  controller: fromDateController,
                                  labelText: "From Date",
                                  required: dateC.value,
                                ),
                                MyDateFilter(
                                  enabled: dateC.value,
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
                            value: weaverNameC.value,
                            onChanged: (value) => weaverNameC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Weaver Name',
                            items: controller.weaver,
                            selectedItem: weaverName.value,
                            isValidate: weaverNameC.value,
                            onChanged: (LedgerModel item) {
                              weaverName.value = item;
                              weaverId = item.id;
                              weaverNameC.value = true;
                            },
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 400,
                        child: ListTile(
                          leading: Checkbox(
                            value: productNameC.value,
                            onChanged: (value) => productNameC.value = value!,
                          ),
                          subtitle: MySearchField(
                            textController: productController,
                            focusNode: productFocusNode,
                            requestFocus: formatFocusNode,
                            label: 'Product Name',
                            items: controller.ProductNameList,
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
                          focusNode: formatFocusNode,
                          controller: formatController,
                          hintText: 'Format',
                          items: const [
                            'Pdf',
                            'Excel',
                          ],
                        ),
                      ],
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
                    request['from_date'] = fromDateController.text;
                    request['to_date'] = toDateController.text;
                  }
                  if (weaverNameC.value == true) {
                    request['weaver_id'] = weaverId;
                  }

                  if (productNameC.value == true) {
                    request['product_id'] = productNameId;
                  }
                  request["format"] = formatController.text.toLowerCase();

                  // Get.back();
                  String? response =
                      await controller.weaverAbsentReport(request: request);
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
