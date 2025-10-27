import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../flutter_core_widget.dart';
import '../../../../model/LedgerModel.dart';
import '../../../../model/LoomGroup.dart';
import '../../../../model/ProductInfoModel.dart';
import '../../../../widgets/MyAutoComplete.dart';
import '../../../../widgets/MyDateFilter.dart';
import 'finished_warp_list_controller.dart';

class FinishedWarpReport extends StatefulWidget {
  const FinishedWarpReport({super.key}); //

  @override
  State<FinishedWarpReport> createState() => _FinishedWarpReportState();
}

class _FinishedWarpReportState extends State<FinishedWarpReport> {
  FinishedWarpListReportController controller =
      Get.put(FinishedWarpListReportController());

  @override
  void initState() {
    controller.loomList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(false);
    RxBool weaverC = RxBool(false);
    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    RxBool loomC = RxBool(false);
    RxBool productNameC = RxBool(false);
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
    Rxn<LoomGroup> loomController = Rxn<LoomGroup>();

    int? weaverId;
    int? productNameId;

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController loomTextController = TextEditingController();

    final FocusNode loomFocusNode = FocusNode();
    final FocusNode submitFocusNode = FocusNode();

    final formKey = GlobalKey<FormState>();
    return GetBuilder<FinishedWarpListReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Finished Warps Reports'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 320,
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
                            items: controller.weaverNameList,
                            selectedItem: weaverName.value,
                            isValidate: weaverC.value,
                            onChanged: (LedgerModel item) {
                              loomTextController.text = "";
                              loomController.value = null;
                              weaverName.value = item;
                              weaverId = item.id;
                              weaverC.value = true;
                              controller.loomInfo(item.id);
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
                            items: controller.productNameList,
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
                            value: loomC.value,
                            onChanged: (value) => loomC.value = value!,
                          ),
                          subtitle: MySearchField(
                            label: 'Loom No',
                            items: controller.loomList,
                            enabled: controller.loomList.isNotEmpty,
                            textController: loomTextController,
                            focusNode: loomFocusNode,
                            requestFocus: submitFocusNode,
                            isValidate: loomC.value,
                            onChanged: (LoomGroup item) async {
                              loomController.value = item;
                              loomC.value = true;
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
              focusNode: submitFocusNode,
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
                if (weaverC.value == true) {
                  request['weaver_id'] = weaverId;
                }
                if (loomC.value == true) {
                  request['loom_no'] = loomController.value?.loomNo;
                }
                if (productNameC.value == true) {
                  request['product_id'] = productNameId;
                }
                Get.back(result: controller.filterData = request);
              },
            ),
          ],
        ),
      );
    });
  }
}
