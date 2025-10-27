import 'package:abtxt/view/report/report_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../model/FirmModel.dart';
import '../../model/YarnModel.dart';

class YarnPurchaseReport extends StatefulWidget {
  const YarnPurchaseReport({super.key});

  @override
  State<YarnPurchaseReport> createState() => _YarnPurchaseReportState();
}

class _YarnPurchaseReportState extends State<YarnPurchaseReport> {
  ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool firmC = RxBool(false);
    RxBool supplierC = RxBool(false);
    RxBool yarnC = RxBool(false);

    Rxn<FirmModel> firm = Rxn<FirmModel>();
    Rxn<LedgerModel> supplier = Rxn<LedgerModel>();
    Rxn<YarnModel> yarnName = Rxn<YarnModel>();
    var firmId;
    var supplierId;
    var yarnId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    final _formKey = GlobalKey<FormState>();

    return GetBuilder<ReportController>(builder: (controller) {
      return AlertDialog(
        title: const Text('Yarn Purchase Order Report'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
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
                          MyDateFilter(
                            controller: fromDateController,
                            labelText: "FROM DATE",
                          ),
                          MyDateFilter(
                            controller: toDateController,
                            labelText: "TO DATE",
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
                          value: firmC.value,
                          onChanged: (value) => firmC.value = value!,
                        ),
                        subtitle: MyAutoComplete(
                          label: 'Firm Name',
                          items: controller.firmName,
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
                          value: supplierC.value,
                          onChanged: (value) => supplierC.value = value!,
                        ),
                        subtitle: MyAutoComplete(
                          label: 'Supplier',
                          items: controller.supplierList,
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
                          value: yarnC.value,
                          onChanged: (value) => yarnC.value = value!,
                        ),
                        subtitle: MyAutoComplete(
                          label: 'Yarn',
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
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('SUBMIT'),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (dateC.value == true) {
                request['from_date'] = fromDateController.text;
                request['to_date'] = toDateController.text;
              }
              if (firmC.value == true) {
                request['firm_id'] = firmId;
              }
              if (supplierC.value == true) {
                request['supplier_id'] = supplierId;
              }
              if (yarnC.value == true) {
                request['yarn_id'] = yarnId;
              }
              Get.back();
              String? response =
                  await controller.yarnPurchaseReport(request: request);
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
