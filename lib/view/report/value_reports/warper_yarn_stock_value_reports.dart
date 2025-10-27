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

class WarperYarnStockValueReport extends StatefulWidget {
  const WarperYarnStockValueReport({super.key});

  @override
  State<WarperYarnStockValueReport> createState() =>
      _WarperYarnStockValueReportState();
}

class _WarperYarnStockValueReportState
    extends State<WarperYarnStockValueReport> {
  ValueReportController controller = Get.put(ValueReportController());
  TextEditingController qtyTypeController = TextEditingController(text: 'ALL');

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool warperC = RxBool(false);
    RxBool qtyC = RxBool(false);

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController stockUptoController =
        TextEditingController(text: today);
    Rxn<LedgerModel> warperName = Rxn<LedgerModel>();

    var warperNameId;
    return GetBuilder<ValueReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: Text('Warper -Yarn Stock - Value Report'),
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
                            value: warperC.value,
                            onChanged: (value) => warperC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Warper Name',
                            items: controller.ledgerDropdownWarper,
                            selectedItem: warperName.value,
                            isValidate: warperC.value,
                            onChanged: (LedgerModel item) {
                              warperName.value = item;
                              warperNameId = item.id;
                              warperC.value = true;
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
                  if (warperC.value == true) {
                    request['warper_id'] = warperNameId;
                  }
                  if (qtyC.value == true) {
                    request['warper_id'] = qtyTypeController.text;
                  }
                  Get.back();
                  String? response =
                  await controller.warperYarnStockValueReport(request: request);
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
