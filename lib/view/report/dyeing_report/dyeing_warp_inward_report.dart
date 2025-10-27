import 'package:abtxt/flutter_core_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyFilterTextField.dart';
import 'dyeing_reports_controller.dart';

class DyeingWarpInwardReport extends StatefulWidget {
  const DyeingWarpInwardReport({super.key});

  @override
  State<DyeingWarpInwardReport> createState() => _DyeingWarpInwardReportState();
}

class _DyeingWarpInwardReportState extends State<DyeingWarpInwardReport> {
  DyeingReportsController controller = Get.put(DyeingReportsController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool dyerC = RxBool(false);
    RxBool warpDesignC = RxBool(false);
    RxBool warpIdC = RxBool(false);
    Rxn<LedgerModel> dyer = Rxn<LedgerModel>();
    Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();
    int? dyerId;
    int? warpDesignId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController warpIdController = TextEditingController();
    TextEditingController formatController = TextEditingController(text: "Pdf");
    return GetBuilder<DyeingReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Dyeing - Warp Inward Report'),
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
                                  autofocus: true,
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
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: warpIdC.value,
                            onChanged: (value) => warpIdC.value = value!,
                          ),
                          subtitle: MyFilterTextField(
                            controller: warpIdController,
                            hintText: "Warp Id",
                            validate: warpIdC.value ? 'string' : '',
                            onChanged: (value) {
                              warpIdC.value = warpIdController.text.isNotEmpty;
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 325,
                      child: Row(
                        children: [
                          const SizedBox(width: 60),
                          MyDropdownButtonFormField(
                            controller: formatController,
                            hintText: "Format",
                            items: const ["Pdf", "Excel"],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Get.back(), child: const Text('CANCEL')),
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
                  if (warpDesignC.value == true) {
                    request['warp_design_id'] = warpDesignId;
                  }
                  if (warpIdC.value == true) {
                    request['new_warp_id'] = warpIdController.text;
                  }
                  request["format"] = formatController.text.toLowerCase();

                  // Get.back();
                  String? response =
                      await controller.dyeingWarpInwardReport(request: request);
                  if (response != null) {
                    final Uri url = Uri.parse(response);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $response');
                    }
                  }
                },
                child: const Text('SUBMIT'))
          ],
        ),
      );
    });
  }
}
