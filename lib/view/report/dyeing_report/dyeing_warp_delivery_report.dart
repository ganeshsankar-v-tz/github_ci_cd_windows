//dyeing_warp_delivery_report.dart
import 'package:abtxt/flutter_core_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import 'dyeing_reports_controller.dart';

class DyeingWarpDeliveryReport extends StatefulWidget {
  const DyeingWarpDeliveryReport({super.key});

  @override
  State<DyeingWarpDeliveryReport> createState() =>
      _DyeingWarpInwardReportState();
}

class _DyeingWarpInwardReportState extends State<DyeingWarpDeliveryReport> {
  DyeingReportsController controller = Get.put(DyeingReportsController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool dyerC = RxBool(false);
    Rxn<LedgerModel> dyer = Rxn<LedgerModel>();
    var dyerId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    return GetBuilder<DyeingReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: Text('Dyeing - Warp Delivery Report'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                                  controller: fromDateController,
                                  labelText: "From Date",
                                  required: dateC.value,
                                ),
                                MyDateFilter(
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
                            value: dyerC.value,
                            onChanged: (value) => dyerC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Dyer',
                            items: controller.ledgerDropdown,
                            selectedItem: dyer.value,
                            isValidate: dyerC.value,
                            onChanged: (LedgerModel item) {
                              dyer.value = item;
                              dyerId = item.id;
                              dyerC.value = true;
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
                onPressed: () => Get.back(),
                child: Text('CANCEL')),
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
                  if (dyerC.value == true) {
                    request['dyer_id'] = dyerId;
                  }
                  // Get.back();
                  String? response =
                      await controller.dyeingWarpDeliveryReport(request: request);
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
