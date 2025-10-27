import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import 'dyeing_reports_controller.dart';

class DyerWarpStockReport extends StatefulWidget {
  const DyerWarpStockReport({super.key});

  @override
  State<DyerWarpStockReport> createState() => _DyerWarpStockReportState();
}

class _DyerWarpStockReportState extends State<DyerWarpStockReport> {
  DyeingReportsController controller = Get.put(DyeingReportsController());

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool dyerC = RxBool(false);
    RxBool warpDesignC = RxBool(false);

    Rxn<LedgerModel> dyer = Rxn<LedgerModel>();
    int? dyerId;
    int? warpDesignId;

    Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController stockUptoController =
        TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<DyeingReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Dyer - Warp Stock Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              children: [
                                MyDateFilter(
                                  controller: stockUptoController,
                                  labelText: "Stock Upto",
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
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: warpDesignC.value,
                            onChanged: (value) => warpDesignC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Warp Design',
                            items: controller.warpDesignList,
                            selectedItem: warpDesign.value,
                            isValidate: warpDesignC.value,
                            onChanged: (NewWarpModel item) {
                              warpDesignId = item.id;
                              warpDesign.value = item;
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
                onPressed: () => Get.back(), child: const Text('CANCEL')),
            TextButton(
              child: const Text('SUBMIT'),
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                var request = {};
                if (dateC.value == true) {
                  request['upto_date'] = stockUptoController.text;
                }
                if (dyerC.value == true) {
                  request['dyer_id'] = dyerId;
                }
                if (warpDesignC.value == true) {
                  request['warp_design_id'] = warpDesignId;
                }
                String? response =
                    await controller.dyerWarpStockReport(request: request);
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
