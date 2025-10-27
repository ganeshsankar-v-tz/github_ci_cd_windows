import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/warp_delivery_to_roller_controller.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward_controller.dart';
import 'package:abtxt/widgets/my_autocompletes/roller_delivery_warpId_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/RollerDeliverWarpDetails.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class WarpDeliveryToRollerBottomSheet extends StatefulWidget {
  const WarpDeliveryToRollerBottomSheet({super.key});

  @override
  State<WarpDeliveryToRollerBottomSheet> createState() => _State();
}

class _State extends State<WarpDeliveryToRollerBottomSheet> {
  Rxn<WarpDesignModel> warpDesign = Rxn<WarpDesignModel>();
  TextEditingController warpTypeController = TextEditingController();
  Rxn<RollerDeliverWarpDetails> warpId = Rxn<RollerDeliverWarpDetails>();
  TextEditingController productQytController = TextEditingController();
  TextEditingController meterController = TextEditingController(text: "0.000");
  TextEditingController warpWeightController = TextEditingController();
  TextEditingController deliveredEmptyController =
      TextEditingController(text: "Beam");
  TextEditingController emptyQytController = TextEditingController(text: "1");
  TextEditingController sheetController = TextEditingController(text: "0");
  TextEditingController warpColourController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  var detailText = "";
  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  WarpDeliveryToRollerController controller = Get.find();
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();
  Rxn<WarpInwardDetailsModel> details = Rxn<WarpInwardDetailsModel>();

  RxInt warpInward = RxInt(0);

  // for backend tracking
  int? weaverId;
  int? subWeaverNo;
  String? warpTrackerId;
  String? warpFor;

  RxString weaverName = RxString("");
  RxString loomNo = RxString("");

  @override
  void initState() {
    _initValue();
    controller.detailsColumnData();
    super.initState();
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  void detailsTextData() {
    var comma = detailText.isNotEmpty ? "," : "";
    var text = details.value?.toString().isEmpty ?? true
        ? detailsController.text
        : details.value.toString();
    detailsController.text = '$text$comma $detailText';
    Get.back();
  }

  void _showDetailDialog() {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: SizedBox(
            width: 270,
            height: 460,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                width: 250,
                child: MyAutoComplete(
                  label: 'Details',
                  selectedItem: details.value,
                  items: controller.detailsData,
                  onChanged: (WarpInwardDetailsModel item) async {
                    details.value = item;
                    detailsTextData();
                  },
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
                detailsTextData();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDeliveryToRollerController>(builder: (controller) {
      return ShortCutWidget(
        appBar:
            AppBar(title: const Text('Add Item to Warp Delivery To Roller')),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.f2): DetailsIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            DetailsIntent: SetCounterAction(perform: () {
              _showDetailDialog();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          MyAutoComplete(
                            label: 'Warp Design',
                            items: controller.warpDesignDropdown,
                            selectedItem: warpDesign.value,
                            enabled: !isUpdate.value,
                            onChanged: (WarpDesignModel item) async {
                              controller.warpIdList.clear();
                              clearTheController();
                              warpTypeController.text = '${item.warpType}';
                              warpDesign.value = item;
                              await controller
                                  .wapDetailsByWarpId(item.warpDesignId);
                            },
                          ),
                          MyTextField(
                            controller: warpTypeController,
                            hintText: 'Warp Type',
                            enabled: !isUpdate.value,
                          ),
                          Row(
                            children: [
                              Wrap(
                                children: [
                                  RollerDeliveryWarpIdDropDown(
                                    enabled: !isUpdate.value,
                                    label: 'Warp Id',
                                    items: controller.warpIdList,
                                    selectedItem: warpId.value,
                                    onChanged: (RollerDeliverWarpDetails item) {
                                      FocusScope.of(context)
                                          .requestFocus(_detailsFocusNode);
                                      clearTheController();
                                      warpId.value = item;
                                      displayWarpIdDetails(item);
                                    },
                                  ),
                                  MyTextField(
                                    controller: productQytController,
                                    hintText: 'Product Qty',
                                    validate: 'number',
                                    readonly: true,
                                    enabled: !isUpdate.value,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Wrap(
                                children: [
                                  MyTextField(
                                    controller: meterController,
                                    hintText: 'Meter',
                                    validate: 'double',
                                    readonly: true,
                                    enabled: !isUpdate.value,
                                  ),
                                  MyTextField(
                                    controller: warpWeightController,
                                    hintText: 'Warp Weight',
                                    validate: 'double',
                                    // readonly: true,
                                    focusNode: _firstInputFocusNode,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Wrap(
                                children: [
                                  MyDropdownButtonFormField(
                                    controller: deliveredEmptyController,
                                    hintText: "Delivered Empty",
                                    items: const ["Beam", "Bobbin", "Nothing"],
                                    onChanged: (value) {
                                      if (value == "Beam") {
                                        emptyQytController.text = "1";
                                        sheetController.text = "40";
                                      } else if (value == "Bobbin") {
                                        emptyQytController.text = "2";
                                        sheetController.text = "0";
                                      } else {
                                        emptyQytController.text = "0";
                                        sheetController.text = "0";
                                      }
                                    },
                                  ),
                                  MyTextField(
                                    controller: emptyQytController,
                                    hintText: 'Empty Qty',
                                    validate: 'number',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Wrap(
                                children: [
                                  MyTextField(
                                    controller: sheetController,
                                    hintText: 'Sheet',
                                    validate: 'number',
                                  ),
                                  MyTextField(
                                    controller: warpColourController,
                                    hintText: 'Warp Color',
                                    readonly: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MyTextField(
                                width: 400,
                                focusNode: _detailsFocusNode,
                                controller: detailsController,
                                hintText: 'Details',
                              ),
                              const Text(
                                'F2',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        children: [
                          const Text("Weaver Name:  "),
                          Obx(
                            () => Text(weaverName.value,
                                style: const TextStyle(color: Colors.red)),
                          ),
                          const SizedBox(width: 10),
                          const Text("Loom No:  "),
                          Obx(
                            () => Text(loomNo.value,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: MyAddButton(onPressed: () => submit()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "warp_design_id": warpDesign.value?.warpDesignId,
        "warp_design_name": warpDesign.value?.warpName,
        "warp_id": warpId.value?.warpId,
        "product_qty": int.tryParse(productQytController.text) ?? 0,
        "meter": double.tryParse(meterController.text) ?? 0.0,
        "warp_weight": double.tryParse(warpWeightController.text) ?? 0.0,
        "empty_type": deliveredEmptyController.text,
        "empty_qty": int.tryParse(emptyQytController.text) ?? 0,
        "sheet": int.tryParse(sheetController.text) ?? 0,
        "warp_color": warpColourController.text,
        "warp_det": detailsController.text,
        "warp_type": warpTypeController.text,
        "warp_inward": warpInward.value,
        "weaver_id": weaverId,
        "sub_weaver_no": subWeaverNo,
        "warp_tracker_id": warpTrackerId,
        "warp_for": warpFor,
        "weaver_name": weaverName.value,
        "loom_no": loomNo.value,
      };
      Get.back(result: request);
    }
  }

  void _initValue() async {
    if (Get.arguments != null) {
      isUpdate.value = true;
      //controller.change(isUpdate.value = true);
      var item = Get.arguments['item'];
      meterController.text = tryCast(item['meter']);
      warpWeightController.text = tryCast(item['warp_weight']);
      deliveredEmptyController.text = '${item['empty_type']}';
      warpColourController.text = '${item['warp_color'] ?? ""}';
      sheetController.text = '${item['sheet']}';
      productQytController.text = '${item['product_qty']}';
      detailsController.text = '${item['warp_det']}';
      detailText = tryCast(item['warp_det']);
      warpTypeController.text = '${item['warp_type']}';
      warpDesign.value = WarpDesignModel(
          warpDesignId: item["warp_design_id"],
          warpName: item["warp_design_name"]);
      warpId.value = RollerDeliverWarpDetails(warpId: item["warp_id"]);
      warpInward.value = item["warp_inward"];
      weaverId = item["weaver_id"];
      subWeaverNo = item["sub_weaver_no"];
      warpTrackerId = item["warp_tracker_id"];
      warpFor = item["warp_for"];
      weaverName.value = item["weaver_name"] ?? "";
      loomNo.value = item["loom_no"] ?? "";
    } else if (controller.lastWarp != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var item = controller.lastWarp;
        var warpDesignlist = controller.warpDesignDropdown
            .where((element) =>
                '${element.warpDesignId}' == '${item['warp_design_id']}')
            .toList();
        if (warpDesignlist.isNotEmpty) {
          warpDesign.value = warpDesignlist.first;
          warpTypeController.text = warpDesignlist.first.warpType!;
          controller.wapDetailsByWarpId(warpDesign.value?.warpDesignId);
        }
      });
    }
  }

  void displayWarpIdDetails(RollerDeliverWarpDetails item) {
    var warpColour = "";

    if (item.warpColor != null) {
      warpColour = "${item.warpColor}, ";
    }

    productQytController.text = "${item.qty}";
    meterController.text = item.metre!.toStringAsFixed(3);
    warpWeightController.text = item.weight!.toStringAsFixed(3);
    warpColourController.text = "$warpColour${tryCast(item.details)}";
    detailsController.text = "";
    detailText = '';
    if (warpTypeController.text == "Main Warp") {
      setState(() {
        deliveredEmptyController.text = "Beam";
      });
      sheetController.text = "40";
      emptyQytController.text = "1";
    } else {
      setState(() {
        deliveredEmptyController.text = "Bobbin";
      });
      sheetController.text = "0";
      emptyQytController.text = "2";
    }
  }

  clearTheController() {
    productQytController.text = "0";
    meterController.text = "0.000";
    warpWeightController.text = "0.000";
    warpColourController.text = "";
  }
}
