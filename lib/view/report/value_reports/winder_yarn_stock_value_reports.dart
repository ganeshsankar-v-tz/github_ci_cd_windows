import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/value_reports/value_report_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class WinderYarnStockValueReport extends StatefulWidget {
  const WinderYarnStockValueReport({super.key});

  @override
  State<WinderYarnStockValueReport> createState() =>
      _WinderYarnStockValueReportState();
}

class _WinderYarnStockValueReportState
    extends State<WinderYarnStockValueReport> {
  ValueReportController controller = Get.put(ValueReportController());
  TextEditingController qtyTypeController = TextEditingController(text: 'ALL');

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool winderC = RxBool(false);
    RxBool qtyC = RxBool(false);

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController stockUptoController =
        TextEditingController(text: today);
    Rxn<LedgerModel> winderName = Rxn<LedgerModel>();

    var winderId;
    return GetBuilder<ValueReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: Text('Winder -Yarn Stock - Value Report'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 500,
              height: 250,
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
                            value: winderC.value,
                            onChanged: (value) => winderC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Winder',
                            items: controller.windersList,
                            selectedItem: winderName.value,
                            isValidate: winderC.value,
                            onChanged: (LedgerModel item) {
                              winderName.value = item;
                              winderId = item.id;
                              winderC.value = true;
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
                              value: qtyC.value,
                              onChanged: (value) => qtyC.value = value!,
                            ),
                            subtitle: MyDropdownButtonFormField(
                              controller: qtyTypeController,
                              hintText: 'Quantity-Type',
                              items: ['ALL', 'Plus', 'Minus'],
                              onChanged: (value) {
                                qtyC.value = true;
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
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  var request = {};
                  if (dateC.value == true) {
                    request['from_date'] = stockUptoController.text;
                  }
                  if (winderC.value == true) {
                    request['warper_id'] = winderId;
                  }
                  if (qtyC.value == true) {
                    request['warper_id'] = qtyTypeController.text;
                  }
                  Get.back();
                  String? response =
                  await controller.winderYarnStockValueReport(request: request);
                  if (response != null) {
                    final Uri url = Uri.parse(response);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $response');
                    }
                  }
                },
                child: Text('SUBMIT'))
          ],
        ),
      );
    });
  }
}
