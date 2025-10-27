import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/value_reports/value_report_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MyAutoComplete.dart';

class WeaverOtherWarpStockValueReport extends StatefulWidget {
  const WeaverOtherWarpStockValueReport({super.key});

  @override
  State<WeaverOtherWarpStockValueReport> createState() =>
      _WeaverOtherWarpStockValueReportState();
}

class _WeaverOtherWarpStockValueReportState
    extends State<WeaverOtherWarpStockValueReport> {
  ValueReportController controller = Get.put(ValueReportController());
  TextEditingController loomcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool warpDesignC = RxBool(false);
    RxBool weaverC = RxBool(false);
    RxBool loomC = RxBool(false);

    Rxn<NewWarpModel> warpDesignName = Rxn<NewWarpModel>();
    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();

    var warpDesignId;
    var weaverId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController stockUptoController =
        TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<ValueReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Weaver - (Other) Warp Stock - Value Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 480,
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
                  request['warpDesign_idx'] = warpDesignId;
                }
                if (weaverC.value == true) {
                  request['weaver_id'] = weaverId;
                }
                if (loomC.value == true) {
                  request['loom'] = loomcontroller.text;
                }
                Get.back();
                String? response =
                await controller.WeaverOtherWarpStockValueReport(request: request);
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
