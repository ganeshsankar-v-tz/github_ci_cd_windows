import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/weaving_reports/weaving_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/YarnModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';

class YarnDeliveryBalanceReportWeaving extends StatefulWidget {
  const YarnDeliveryBalanceReportWeaving({super.key});

  @override
  State<YarnDeliveryBalanceReportWeaving> createState() =>
      _YarnDeliveryBalanceReportWeavingState();
}

class _YarnDeliveryBalanceReportWeavingState
    extends State<YarnDeliveryBalanceReportWeaving> {
  WeavingReportController controller = Get.put(WeavingReportController());
  TextEditingController loomcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool yarnC = RxBool(false);
    RxBool weaverC = RxBool(false);
    RxBool loomC = RxBool(false);
    RxBool productNameC = RxBool(false);
    RxBool reportTypeC = RxBool(false);
    RxBool valueTypeC = RxBool(false);

    Rxn<YarnModel> yarnName = Rxn<YarnModel>();
    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();

    var yarnId;
    var weaverId;
    var productNameId;

    TextEditingController reportTypeController =
        TextEditingController(text: 'Detailed');
    TextEditingController valueTypeController =
        TextEditingController(text: 'ALL');
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController stockUptoController =
        TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<WeavingReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Weaving - Weft Delivery Balance Report'),
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
                              value: loomC.value,
                              onChanged: (value) => loomC.value = value!,
                            ),
                            subtitle: MyTextField(
                              controller: loomcontroller,
                              hintText: 'Loom',
                              onChanged: (value) {
                                loomC.value = loomcontroller.text.isNotEmpty;
                              },
                            )),
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
                            items: controller.yarnDropdown,
                            selectedItem: yarnName.value,
                            isValidate: yarnC.value,
                            onChanged: (YarnModel item) {
                              yarnName.value = item;
                              yarnId = item.id;
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
                              value: reportTypeC.value,
                              onChanged: (value) => reportTypeC.value = value!,
                            ),
                            subtitle: MyDropdownButtonFormField(
                              controller: reportTypeController,
                              hintText: 'Report Type',
                              items: const [
                                'Detailed',
                                'Brief',
                                'Brief-Warp Colour',
                              ],
                              onChanged: (value) {
                                reportTypeC.value =
                                    reportTypeController.text.isNotEmpty;
                              },
                            )),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                            leading: Checkbox(
                              value: valueTypeC.value,
                              onChanged: (value) => valueTypeC.value = value!,
                            ),
                            subtitle: MyDropdownButtonFormField(
                              controller: valueTypeController,
                              hintText: 'Value Type',
                              items: const [
                                'ALL',
                                'Plus',
                                'Minus',
                              ],
                              onChanged: (value) {
                                valueTypeC.value = true;
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
                if (weaverC.value == true) {
                  request['weaver_id'] = weaverId;
                }
                if (yarnC.value == true) {
                  request['yarn_id'] = yarnId;
                }
                if (loomC.value == true) {
                  request['loom'] = loomcontroller.text;
                }
                /*if (reportTypeC.value == true) {
                  request['colour_id'] = reportTypeController.text;
                }*/
                if (productNameC.value == true) {
                  request['product_id'] = productNameId;
                }
                // Get.back();
                String? response =
                await controller.yarnDeliveryBalanceReport(request: request);
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
