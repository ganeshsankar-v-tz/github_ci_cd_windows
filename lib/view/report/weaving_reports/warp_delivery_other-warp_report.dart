import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/weaving_reports/weaving_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../widgets/MyAutoComplete.dart';

class WarpDeliveryOtherWarpReport extends StatefulWidget {
  const WarpDeliveryOtherWarpReport({super.key});

  @override
  State<WarpDeliveryOtherWarpReport> createState() =>
      _WarpDeliveryOtherWarpReportState();
}

class _WarpDeliveryOtherWarpReportState
    extends State<WarpDeliveryOtherWarpReport> {
  WeavingReportController controller = Get.put(WeavingReportController());
  TextEditingController warpIdNoController = TextEditingController();
  TextEditingController warpDesignController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool weaverC = RxBool(false);
    RxBool loomC = RxBool(false);
    RxBool groupC = RxBool(false);
    RxBool productNameC = RxBool(false);
    RxBool warpDesignC = RxBool(false);
    RxBool warpIDC = RxBool(false);
    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
    Rxn<ProductGroupModel> groupName = Rxn<ProductGroupModel>();
    TextEditingController loomcontroller = TextEditingController();

    var weaverId;
    var groupId;
    var productNameId;

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    final formKey = GlobalKey<FormState>();
    return GetBuilder<WeavingReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Weaving...(Other) Warp Delivery Report'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 550,
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
                            value: groupC.value,
                            onChanged: (value) => groupC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Product Group',
                            items: controller.groups,
                            selectedItem: groupName.value,
                            isValidate: groupC.value,
                            onChanged: (ProductGroupModel item) {
                              groupName.value = item;
                              groupId = item.id;
                              groupC.value = true;
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
                            value: productNameC.value,
                            onChanged: (value) => productNameC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Product Name',
                            items: controller.ProductNameList,
                            selectedItem: productName.value,
                            isValidate: productNameC.value,
                            onChanged: (ProductInfoModel item) {
                              productName.value = item;
                              productNameId = item.id;
                              productNameC.value = true;
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
                          subtitle: MyTextField(
                            controller: warpDesignController,
                            hintText: 'Warp Design',
                            onChanged: (value) {
                              warpDesignC.value = warpDesignController.text.isNotEmpty;
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
                            subtitle: MyTextField(
                              controller: warpIdNoController,
                              hintText: 'Warp Id No',
                              onChanged: (value) {
                                warpIDC.value = warpIdNoController.text.isNotEmpty;
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
                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;
                }
                if (groupC.value == true) {
                  request['winder_id'] = groupId;
                }
                if (productNameC.value == true) {
                  request['product_id'] = productNameId;
                }
                if (weaverC.value == true) {
                  request['weaver_id'] = weaverId;
                }
                if (loomC.value == true) {
                  request['loom'] = loomcontroller.text;
                }
                /*if (warpDesignC.value == true) {
                  request['dyer_id'] = warpDesignController.text;
                }*/
                if (warpIDC.value == true) {
                  request['warp_id'] = warpIdNoController.text;
                }
                // Get.back();
                String? response =
                await controller.warpDeliveryOtherWarpReport(request: request);
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
