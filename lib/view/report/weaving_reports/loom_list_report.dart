import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/report/weaving_reports/weaving_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/LabeledCheckbox.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/my_dropdowns/MyMultiSelectDropdown.dart';

class LoomListReportWeaving extends StatefulWidget {
  const LoomListReportWeaving({super.key});

  @override
  State<LoomListReportWeaving> createState() => _LoomListReportWeavingState();
}

class _LoomListReportWeavingState extends State<LoomListReportWeaving> {
  WeavingReportController controller = Get.put(WeavingReportController());
  TextEditingController activeController =
      TextEditingController(text: "Active");
  TextEditingController loomTypeController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(false);
    RxBool weaverC = RxBool(false);
    RxBool firmC = RxBool(false);
    RxBool activeC = RxBool(false);
    RxBool warpDesignC = RxBool(false);
    RxBool productNameC = RxBool(false);
    RxBool productGroupC = RxBool(false);
    RxBool loomTypeC = RxBool(false);
    RxBool newC = RxBool(false);
    RxBool runningC = RxBool(false);
    RxBool completedC = RxBool(false);
    RxBool warpStatusC = RxBool(false);

    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
    Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();
    Rxn<ProductGroupModel> group = Rxn<ProductGroupModel>();

    RxList<ProductInfoModel> selectedProductName = <ProductInfoModel>[].obs;

    int? weaverId;
    int? firmId;
    int? productNameId;
    int? groupId;
    int? warpDesignId;
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
          title: const Text('Loom List'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 800,
              height: 550,
              child: SingleChildScrollView(
                child: Column(
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
                                const SizedBox(width: 85),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(
                                () => SizedBox(
                                  width: 325,
                                  child: ListTile(
                                    leading: Checkbox(
                                      value: productGroupC.value,
                                      onChanged: (value) =>
                                          productGroupC.value = value!,
                                    ),
                                    subtitle: MyAutoComplete(
                                      label: 'Product Group',
                                      items: controller.groups,
                                      selectedItem: group.value,
                                      isValidate: productGroupC.value,
                                      onChanged: (ProductGroupModel item) {
                                        group.value = item;
                                        groupId = item.id;
                                        productGroupC.value = true;
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
                                      onChanged: (value) =>
                                          productNameC.value = value!,
                                    ),
                                    subtitle: MyMultiSelectDropdown(
                                      items:
                                          controller.ProductNameList.toList(),
                                      label: "Product Name",
                                      isValidate: productNameC.value,
                                      onConfirm: (item) {
                                        var res =
                                            item.cast<ProductInfoModel>();
                                        productNameC.value = true;
                                        selectedProductName.value =
                                            res.toList();
                                        controller.update();
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
                                      value: activeC.value,
                                      onChanged: (value) =>
                                          activeC.value = value!,
                                    ),
                                    subtitle: Row(
                                      children: [
                                        SizedBox(
                                          //width: 150,
                                          child: MyDropdownButtonFormField(
                                              controller: activeController,
                                              hintText: "Status",
                                              items: const [
                                                "Active",
                                                "Stopped"
                                              ],
                                              onChanged: (value) {
                                                activeC.value = true;
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => SizedBox(
                                  width: 325,
                                  child: ListTile(
                                    leading: Checkbox(
                                      value: loomTypeC.value,
                                      onChanged: (value) =>
                                          loomTypeC.value = value!,
                                    ),
                                    subtitle: MyDropdownButtonFormField(
                                      hintText: 'Loom Type',
                                      controller: loomTypeController,
                                      items: const [
                                        "",
                                        "Under Pick",
                                        "Pick & Pick",
                                        "Power Loom",
                                        "Draw Box",
                                        "Rapiar Loom",
                                        "Auto Loom",
                                        "Hand Loom",
                                      ],
                                      onChanged: (value) {
                                        loomTypeC.value = true;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => SizedBox(
                                  width: 325,
                                  child: ListTile(
                                    leading: Checkbox(
                                      value: firmC.value,
                                      onChanged: (value) =>
                                          firmC.value = value!,
                                    ),
                                    subtitle: MyAutoComplete(
                                      label: 'Firm Name',
                                      items: controller.firmDropdown,
                                      selectedItem: firmName.value,
                                      isValidate: firmC.value,
                                      onChanged: (FirmModel item) {
                                        firmName.value = item;
                                        firmId = item.id;
                                        firmC.value = true;
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
                                      onChanged: (value) =>
                                          warpDesignC.value = value!,
                                    ),
                                    subtitle: MyAutoComplete(
                                      label: 'Warp Design',
                                      items: controller.warpDesignDropdown,
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
                                      value: weaverC.value,
                                      onChanged: (value) =>
                                          weaverC.value = value!,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text('Warp Status :')),
                              Obx(
                                () => SizedBox(
                                  width: 390,
                                  child: ListTile(
                                    leading: Checkbox(
                                      value: warpStatusC.value,
                                      onChanged: (value) =>
                                          warpStatusC.value = value!,
                                    ),
                                    subtitle: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.1)),
                                      child: SizedBox(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Obx(
                                              () => LabeledCheckbox(
                                                label: "New",
                                                value: newC.value,
                                                onChanged: (value) {
                                                  newC.value = value;
                                                  warpStatusC.value = true;
                                                },
                                              ),
                                            ),
                                            Obx(
                                              () => LabeledCheckbox(
                                                label: "Running",
                                                value: runningC.value,
                                                onChanged: (value) {
                                                  runningC.value = value;
                                                  warpStatusC.value = true;
                                                },
                                              ),
                                            ),
                                            Obx(
                                              () => LabeledCheckbox(
                                                label: "Completed",
                                                value: completedC.value,
                                                onChanged: (value) {
                                                  completedC.value = value;
                                                  warpStatusC.value = true;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
                if (firmC.value == true) {
                  request['firm_id'] = firmId;
                }
                if (warpDesignC.value == true) {
                  request['warp_design_id'] = warpDesignId;
                }
                if (productNameC.value == true) {
                  for (int i = 0; i < selectedProductName.length; i++) {
                    request['product_id[$i]'] = selectedProductName[i].id;
                  }
                }
                if (productGroupC.value == true) {
                  request['product_group_id'] = groupId;
                }
                if (activeC.value == true) {
                  if (activeController.text == "Active") {
                    request['is_active'] = "Yes";
                  } else if (activeController.text == "Stopped") {
                    request['is_active'] = "No";
                  }
                }
                if (loomTypeC.value == true) {
                  request['loom_type'] = loomTypeController.text;
                }
                if (warpStatusC.value == true) {
                  var warpStatus = [];

                  if (newC.value == true) {
                    var data = {};
                    data["status"] = "New";
                    warpStatus.add(data);
                  }

                  if (runningC.value == true) {
                    var data = {};
                    data["status"] = "Running";
                    warpStatus.add(data);
                  }

                  if (completedC.value == true) {
                    var data = {};
                    data["status"] = "Completed";
                    warpStatus.add(data);
                  }

                  if (warpStatus.isEmpty) {
                    return AppUtils.infoAlert(
                        message: "Select any one of the warp statuses");
                  }

                  for (int i = 0; i < warpStatus.length; i++) {
                    request["current_status[$i]"] = warpStatus[i]["status"];
                  }
                }

                if (request.isNotEmpty) {
                  String? response =
                      await controller.loomlistReport(request: request);
                  if (response!.isNotEmpty) {
                    final Uri url = Uri.parse(response);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $response');
                    }
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
