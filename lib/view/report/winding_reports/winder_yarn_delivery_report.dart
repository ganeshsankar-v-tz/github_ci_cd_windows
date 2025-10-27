import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/winding_reports/winding_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAutoComp.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class WinderYarnDeliverReport extends StatefulWidget {
  const WinderYarnDeliverReport({super.key});

  @override
  State<WinderYarnDeliverReport> createState() =>
      _WinderYarnDeliverReportState();
}

class _WinderYarnDeliverReportState extends State<WinderYarnDeliverReport> {
  WindingReportsController controller = Get.put(WindingReportsController());
  static var today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final formKey = GlobalKey<FormState>();

  RxBool dateC = RxBool(true);
  RxBool winderC = RxBool(false);


  TextEditingController fromDateController = TextEditingController(text: today);
  TextEditingController toDateController = TextEditingController(text: today);
  var winderId;
  Rxn<LedgerModel> winderName = Rxn<LedgerModel>();


  final FocusNode _winderFocus = FocusNode();
  final FocusNode _submitFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WindingReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Winding - Yarn Delivery Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 200,
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
                          subtitle: MyAutoComp(
                            label: 'Winder Name',
                            items: controller.ledgerDropdown,
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
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            ExcludeFocus(
              child: TextButton(
                  onPressed: () => Get.back(), child: const Text('CANCEL')),
            ),
            TextButton(
              focusNode: _submitFocus,
              child: const Text('SUBMIT'),
              onPressed: () async {
                var request = {};

                if (!formKey.currentState!.validate()) {
                  return;
                }

                if (dateC.value == true) {
                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;
                }
                if (winderC.value == true) {
                  request['winder_id'] = winderId;
                }

                if (request.isEmpty) {
                  return AppUtils.infoAlert(message: "Select any one field");
                }

                String? response =
                    await controller.winderYarnDeliverReport(request: request);
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
