import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/model/WarpDetailsByWarpDesignIdModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/my_autocompletes/dyer_warp_Id_autoComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class WarpDeliveryToDyerBottomSheet extends StatefulWidget {
  const WarpDeliveryToDyerBottomSheet({super.key});

  @override
  State<WarpDeliveryToDyerBottomSheet> createState() => _State();
}

class _State extends State<WarpDeliveryToDyerBottomSheet> {
  Rxn<WarpDesignModel> warpDesign = Rxn<WarpDesignModel>();
  TextEditingController warpDesignController = TextEditingController();
  TextEditingController colourController = TextEditingController();
  TextEditingController colourToDyeController = TextEditingController();
  TextEditingController meterController = TextEditingController(text: "0.000");
  TextEditingController productQtyController = TextEditingController(text: "0");
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController warpWeightController = TextEditingController(text: "0");
  TextEditingController detailsController = TextEditingController();
  Rxn<WarpDetailsByWarpDesignIdModel> warpIdNo =
      Rxn<WarpDetailsByWarpDesignIdModel>();
  Rxn<NewColorModel> colorname = Rxn<NewColorModel>();

  WarpDeliveryToDyerController controller = Get.find();
  final FocusNode _detailsFocusNode = FocusNode();
  RxInt warpInward = RxInt(0);

  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDeliveryToDyerController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text('Add Item to Warp Delivery To Dyer'),
        ),
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
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
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Wrap(
                                    children: [
                                      MyAutoComplete(
                                        label: 'Warp Design',
                                        items: controller.warpDesignDropdown,
                                        selectedItem: warpDesign.value,
                                        forceNextFocus: true,
                                        enabled: !isUpdate.value,
                                        onChanged:
                                            (WarpDesignModel item) async {
                                          warpDesign.value = item;
                                          warpTypeController.text =
                                              "${item.warpType}";
                                          warpIdNo.value = null;
                                          clearTheControllers();
                                          var id = item.warpDesignId;
                                          await controller
                                              .warpDetailsByWarpDesignId(id);
                                        },
                                      ),
                                      MyTextField(
                                        controller: warpTypeController,
                                        hintText: 'Warp Type',
                                        readonly: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Obx(
                                    () => DyerWarpIdAutoComplete(
                                      enabled: !isUpdate.value,
                                      label: 'Warp Id',
                                      items: controller.warpIdList,
                                      selectedItem: warpIdNo.value,
                                      onChanged: (WarpDetailsByWarpDesignIdModel
                                          item) {
                                        clearTheControllers();
                                        productQtyController.text =
                                            '${item.qty}';
                                        meterController.text =
                                            item.metre!.toStringAsFixed(3);
                                        warpWeightController.text =
                                            item.weight!.toStringAsFixed(3);
                                        colourToDyeController.text =
                                            item.warpColor ?? '';
                                        warpIdNo.value = item;
                                        FocusScope.of(context)
                                            .requestFocus(_detailsFocusNode);
                                      },
                                    ),
                                  ),
                                  MyTextField(
                                    controller: productQtyController,
                                    hintText: 'Product Qty',
                                    validate: "number",
                                    readonly: true,
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
                                        validate: "double",
                                        readonly: true,
                                      ),
                                      MyTextField(
                                        controller: warpWeightController,
                                        hintText: 'Warp Weight',
                                        validate: "double",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Wrap(
                                    children: [
                                      MyAutoComplete(
                                        label: 'Color Name',
                                        items: controller.colorDropdown,
                                        isValidate: false,
                                        selectedItem: colorname.value,
                                        onChanged: (NewColorModel item) {
                                          colourController.text =
                                              '${item.name}';
                                          colourToDyeController.text +=
                                              '${item.name}, ';
                                          colorname.value = item;
                                        },
                                      ),
                                      MyTextField(
                                        controller: colourToDyeController,
                                        hintText: 'Color To Dye',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              MyTextField(
                                controller: detailsController,
                                focusNode: _detailsFocusNode,
                                hintText: "Details",
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                children: [
                                  const Text("Weaver Name:  "),
                                  Obx(
                                    () => Text(weaverName.value,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Loom No:  "),
                                  Obx(
                                    () => Text(loomNo.value,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(),
                                  MyAddButton(onPressed: () => submit()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(child: Container())
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
        "warp_id": warpIdNo.value?.warpId,
        "warp_type": warpTypeController.text,
        "product_qty": int.tryParse(productQtyController.text) ?? 0,
        "metre": double.tryParse(meterController.text) ?? 0,
        "color_to_dye": colourToDyeController.text,
        "warp_weight": double.tryParse(warpWeightController.text) ?? 0.0,
        "warp_det": detailsController.text,
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
    WarpDeliveryToDyerController controller = Get.find();
    controller.warpIdList.clear();

    // AUTO SELECT THE FIRST ITEM OF COLOUR.
    if (controller.colorDropdown.isNotEmpty) {
      colorname.value = controller.colorDropdown.first;
    }

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      warpTypeController.text = tryCast(item['warp_type']);
      meterController.text = tryCast(item['metre']);
      productQtyController.text = tryCast(item['product_qty']);
      colourToDyeController.text = '${item['color_to_dye'] ?? ""}';
      detailsController.text = tryCast(item['warp_det']);
      warpWeightController.text = tryCast(item["warp_weight"]);
      warpDesign.value = WarpDesignModel(
          warpDesignId: item['warp_design_id'],
          warpName: item["warp_design_name"]);
      warpIdNo.value = WarpDetailsByWarpDesignIdModel(
          warpId: item['warp_id'], metre: item["metre"]);
      warpInward.value = item["warp_inward"];
      weaverId = item["weaver_id"];
      subWeaverNo = item["sub_weaver_no"];
      warpTrackerId = item["warp_tracker_id"];
      warpFor = item["warp_for"];
      weaverName.value = item["weaver_name"] ?? "";
      loomNo.value = item["loom_no"] ?? "";
    } else if (controller.lastWarp != null) {
      var item = controller.lastWarp;
      var warpDesignList = controller.warpDesignDropdown
          .where((element) =>
              '${element.warpDesignId}' == '${item['warp_design_id']}')
          .toList();

      if (warpDesignList.isNotEmpty) {
        warpTypeController.text = tryCast(warpDesignList.first.warpType);
        warpDesign.value = warpDesignList.first;
        await controller
            .warpDetailsByWarpDesignId(warpDesign.value?.warpDesignId);
      }
    }
  }

  clearTheControllers() {
    productQtyController.text = "0";
    meterController.text = "0.000";
    warpWeightController.text = "0.000";
    colourToDyeController.text = "";
    detailsController.text = "";
  }
}
