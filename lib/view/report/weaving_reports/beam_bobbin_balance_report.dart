import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/weaving_reports/weaving_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/LoomGroup.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDateFilter.dart';

class BeamBobbinBalanceReport extends StatefulWidget {
  const BeamBobbinBalanceReport({super.key});

  @override
  State<BeamBobbinBalanceReport> createState() =>
      _BeamBobbinBalanceReportState();
}

class _BeamBobbinBalanceReportState extends State<BeamBobbinBalanceReport> {
  WeavingReportController controller = Get.put(WeavingReportController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool weaverC = RxBool(false);
    RxBool loomC = RxBool(false);
    RxBool groupC = RxBool(false);
    RxBool productNameC = RxBool(false);
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);

    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    var weaverNameId;
    Rxn<LoomGroup> loomName = Rxn<LoomGroup>();
    var loomNameId;

    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
    var productNameId;
    Rxn<ProductGroupModel> groupName = Rxn<ProductGroupModel>();
    var groupId;

    return GetBuilder<WeavingReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: Text('Weaving - Beam / Bobbin Balance Report'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                            value: weaverC.value,
                            onChanged: (value) => weaverC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            label: 'Weaver Name',
                            items: controller.weaver,
                            selectedItem: weaverName.value,
                            isValidate: weaverC.value,
                            onChanged: (LedgerModel item) {
                              var id = item.id;
                              controller.weaverId = id;
                              controller.loomList.clear();
                              weaverName.value = item;
                              controller.loomInfo(id);
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
                          subtitle: MyAutoComplete(
                            label: 'Loom Name',
                            items: controller.loomList,
                            selectedItem: loomName.value,
                            isValidate: loomC.value,
                            onChanged: (LoomGroup item) {
                              loomName.value = item;
                              controller.request['loom_id'] = item.loomNo;
                              loomC.value = true;
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
                  if (weaverC.value == true) {
                    request['weaver_id'] = weaverNameId;
                  }
                  if (loomC.value == true) {
                    request['loom'] = loomNameId;
                  }
                  if (groupC.value == true) {
                    request['group_id'] = groupId;
                  }
                  if (productNameC.value == true) {
                    request['product_id'] = productNameId;
                  }

                  // Get.back();
                  String? response =
                      await controller.beamBalanceReport(request: request);
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
