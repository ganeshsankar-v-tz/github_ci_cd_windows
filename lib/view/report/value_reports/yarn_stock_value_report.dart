import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/view/report/value_reports/value_report_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/YarnModel.dart';
import '../../../widgets/MyAutoComplete.dart';

class YarnStockValueReport extends StatefulWidget {
  const YarnStockValueReport({super.key});

  @override
  State<YarnStockValueReport> createState() => _YarnStockValueReportState();
}

class _YarnStockValueReportState extends State<YarnStockValueReport> {
  ValueReportController controller = Get.put(ValueReportController());

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool colorC = RxBool(false);
    RxBool firmC = RxBool(false);
    RxBool yarnC = RxBool(false);
    RxBool reportTypeC = RxBool(false);

    Rxn<FirmModel> firm = Rxn<FirmModel>();
    Rxn<YarnModel> yarnName = Rxn<YarnModel>();
    Rxn<NewColorModel> colourName = Rxn<NewColorModel>();

    var colorId;
    var firmId;
    var yarnId;

    TextEditingController reportTypeController =
        TextEditingController(text: 'Detailed');
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<ValueReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Yarn Stock - Value Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 400,
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
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: colorC.value,
                            onChanged: (value) => colorC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Color',
                            items: controller.colorList,
                            selectedItem: colourName.value,
                            isValidate: colorC.value,
                            onChanged: (NewColorModel item) {
                              colourName.value = item;
                              colorId = item.id;
                              colorC.value = true;
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
                if (firmC.value == true) {
                  request['firm_id'] = firmId;
                }
                if (yarnC.value == true) {
                  request['yarn_id'] = yarnId;
                }
                if (colorC.value == true) {
                  request['colour_id'] = colorId;
                }
                if (reportTypeC.value == true) {
                  request['colour_id'] = reportTypeController.text;
                }
                Get.back();
                String? response =
                await controller.yarnStockValueReport(request: request);
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
