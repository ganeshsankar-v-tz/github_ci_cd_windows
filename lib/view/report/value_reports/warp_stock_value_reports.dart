import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/value_reports/value_report_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MyAutoComplete.dart';

class WarpStockValueReport extends StatefulWidget {
  const WarpStockValueReport({super.key});

  @override
  State<WarpStockValueReport> createState() => _WarpStockValueReportState();
}

class _WarpStockValueReportState extends State<WarpStockValueReport> {
  ValueReportController controller = Get.put(ValueReportController());
  TextEditingController warpTypeController =
      TextEditingController(text: 'Other');

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool warpDesignC = RxBool(false);
    RxBool warpTypeC = RxBool(false);

    Rxn<NewWarpModel> warpDesignName = Rxn<NewWarpModel>();

    var warpDesignId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController stockUptoController =
        TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<ValueReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Warp Stock - Value Report'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 480,
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
                            value: warpDesignC.value,
                            onChanged: (value) => warpDesignC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Warp Design Name',
                            items: controller.warpDesignDropdown,
                            selectedItem: warpDesignName.value,
                            isValidate: warpDesignC.value,
                            onChanged: (NewWarpModel item) {
                              warpDesignName.value = item;
                              warpDesignId = item.id;
                              warpDesignC.value = true;
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
                if (warpDesignC.value == true) {
                  request['dyer_id'] = warpDesignId;
                }
                if (warpTypeC.value == true) {
                  request['winder_id'] = warpTypeController.text;
                }
                Get.back();
                String? response =
                await controller.warpStockValueReport(request: request);
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
