import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/view/report/warp_reports/warp_report_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class WarpStockReport extends StatefulWidget {
  const WarpStockReport({super.key});

  @override
  State<WarpStockReport> createState() => _WarpStockReportState();
}

class _WarpStockReportState extends State<WarpStockReport> {
  WarpReportController controller = Get.put(WarpReportController());
  static var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final formKey = GlobalKey<FormState>();

  RxBool supplierC = RxBool(false);
  RxBool warpDesignC = RxBool(false);
  RxBool productNameC = RxBool(false);
  RxBool warpTypeC = RxBool(false);
  RxBool warpIDC = RxBool(false);

  Rxn<LedgerModel> supplier = Rxn<LedgerModel>();

  int? supplierId;
  int? warpDesignId;
  int? productNameId;
  String? selectedWarpType;

  TextEditingController stockUpToController =
      TextEditingController(text: today);
  TextEditingController reportTypeController =
      TextEditingController(text: 'Detailed-Group');
  TextEditingController warpTypeController =
      TextEditingController(text: 'Other');
  TextEditingController warpIdNoController = TextEditingController();
  TextEditingController warpDesignNameController = TextEditingController();
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController warpConditionController =
      TextEditingController(text: "All");

  final FocusNode _warpDesignNameFocus = FocusNode();
  final FocusNode _supplierNameFocus = FocusNode();
  final FocusNode _submitFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Warp Stock Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 480,
              height: 520,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 60),
                        MyDateFilter(
                          autofocus: false,
                          controller: stockUpToController,
                          labelText: "Stock Upto",
                        ),
                      ],
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: warpDesignC.value,
                            onChanged: (value) => warpDesignC.value = value!,
                          ),
                          subtitle: MySearchField(
                            isValidate: warpDesignC.value,
                            label: "Warp Desig-n Name",
                            items: controller.warpDesignDropdown,
                            textController: warpDesignNameController,
                            focusNode: _warpDesignNameFocus,
                            requestFocus: _submitFocus,
                            onChanged: (NewWarpModel item) {
                              selectedWarpType = item.warpType;
                              warpDesignC.value = true;
                              warpDesignId = item.id;
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
                          subtitle: MySearchField(
                            isValidate: supplierC.value,
                            label: "Supplier Name",
                            items: controller.ledgerDropdown,
                            textController: supplierNameController,
                            focusNode: _supplierNameFocus,
                            requestFocus: _submitFocus,
                            onChanged: (item) {
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
                            value: warpIDC.value,
                            onChanged: (value) => warpIDC.value = value!,
                          ),
                          subtitle: MyFilterTextField(
                            controller: warpIdNoController,
                            hintText: 'Warp ID No',
                            validate: warpIDC.value ? "string" : '',
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_submitFocus);
                            },
                            onChanged: (value) {
                              warpIDC.value = true;
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
                                'Main Warp',
                              ],
                              onChanged: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_submitFocus);
                                warpTypeC.value = true;
                              },
                            )),
                      ),
                    ),
                    Visibility(
                      visible: reportTypeController.text != "Detailed",
                      child: Row(
                        children: [
                          const SizedBox(width: 60),
                          MyDropdownButtonFormField(
                            controller: warpConditionController,
                            hintText: 'Warp Condition',
                            items: const [
                              "All",
                              "White Warps",
                              "Dyed",
                              "Dyed + Rolled",
                              "Purchase Warps",
                              "Drop-Out Warps",
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 60),
                        MyDropdownButtonFormField(
                          controller: reportTypeController,
                          hintText: 'Report Type',
                          items: const [
                            // 'Brief',
                            'Detailed',
                            'Detailed-Group',
                          ],
                          onChanged: (value) {
                            FocusScope.of(context).requestFocus(_submitFocus);
                          },
                        ),
                      ],
                    )
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

                if (warpDesignC.value == true && warpTypeC.value == true) {
                  if (selectedWarpType != warpTypeController.text) {
                    return AppUtils.infoAlert(
                        message:
                            "Selected warp design type and warp type is mismatch");
                  }
                }

                var warpCategory = "All";
                if (warpConditionController.text == "Dyed + Rolled") {
                  warpCategory = "Dyed_Rolled";
                } else {
                  warpCategory = warpConditionController.text;
                }
                request['upto_date'] = stockUpToController.text;

                if (warpDesignC.value == true) {
                  request['warp_design_id'] = warpDesignId;
                }
                if (supplierC.value == true) {
                  request['supplier_id'] = supplierId;
                }
                if (productNameC.value == true) {
                  request['product_id'] = productNameId;
                }
                if (warpIDC.value == true) {
                  request['warp_id'] = warpIdNoController.text;
                }

                request['report_type'] = reportTypeController.text;

                if (warpTypeC.value == true) {
                  request['warp_type'] = warpTypeController.text;
                }

                if (request.isEmpty) {
                  return AppUtils.infoAlert(message: "Select any one field");
                }

                if (reportTypeController.text != "Detailed") {
                  request["warp_category"] = warpCategory;
                }

                String? response =
                    await controller.warpStockReport(request: request);
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
