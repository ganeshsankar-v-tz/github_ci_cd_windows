import 'dart:convert';
import 'dart:developer';

import 'package:abtxt/model/LoomGroup.dart';
import 'package:abtxt/model/saree_checker/SareeCheckerModel.dart';
import 'package:abtxt/model/weaving_models/GoodsInwardOtherWarpModel.dart';
import 'package:abtxt/model/weaving_models/ProductDetailsGoodsInwardModel.dart';
import 'package:abtxt/model/weaving_models/WeavingProductListModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/productinfo/add_product_info.dart';
import 'package:abtxt/view/production/weaving_weft_balance/private_weft_requirement/add_private_weft_requirements.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/multiselect.dart';
import 'package:abtxt/widgets/my_search_field/my_loom_searchField.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../http/http_urls.dart';
import '../../../model/weaving_models/WeaverByLoomStatusModel.dart';
import '../../../model/weaving_models/weft_balance/PrivateWeftRequirementListModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../weaving/add_weaving.dart';
import 'add_goods_inward_slip.dart';
import 'goods_inward_slip_controller.dart';

class GoodsInwardSlipBottomSheetTwo extends StatefulWidget {
  final GoodInwardItemDataSource dataSource;
  final Function? saveOnPressed;

  const GoodsInwardSlipBottomSheetTwo({
    super.key,
    required this.dataSource,
    required this.saveOnPressed,
  });

  static const String routeName = '/goods_inward_slip_bottom_sheet_two';

  @override
  State<GoodsInwardSlipBottomSheetTwo> createState() => _State();
}

class _State extends State<GoodsInwardSlipBottomSheetTwo> {
  Rxn<LoomGroup> loomController = Rxn<LoomGroup>();
  TextEditingController loomTextController = TextEditingController();
  Rxn<WeaverByLoomStatusModel> warpStatusController =
      Rxn<WeaverByLoomStatusModel>();
  TextEditingController warpStatusTextController = TextEditingController();
  Rxn<WeavingProductListModel> productName = Rxn<WeavingProductListModel>();
  TextEditingController productNameTextController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController withController = TextEditingController(text: '0');
  TextEditingController pickController = TextEditingController(text: '0');
  TextEditingController inwardQtyController = TextEditingController(text: '0');
  TextEditingController meterController = TextEditingController(text: '0.00');
  TextEditingController wagesController = TextEditingController(text: '0.00');
  TextEditingController amountController = TextEditingController(text: '0.00');
  TextEditingController damagedController = TextEditingController(text: "No");
  TextEditingController detailsController = TextEditingController();
  TextEditingController pendingController = TextEditingController(text: "No");
  TextEditingController pendingQuantityController =
      TextEditingController(text: '0');
  TextEditingController pendingMeterController =
      TextEditingController(text: '0.000');
  RxList<SareeCheckerModel> sareChecker = RxList<SareeCheckerModel>();
  TextEditingController sareeWeightController =
      TextEditingController(text: "0.000");

  // other warp id
  RxList<GoodsInwardOtherWarpModel> otherWarpIds =
      RxList<GoodsInwardOtherWarpModel>();

  var imageUrl = Rxn<String>();
  RxInt deliveredQtyController = RxInt(0);
  RxInt receivedQtyController = RxInt(0);
  RxInt balanceQtyController = RxInt(0);
  RxString currentProductDetails = RxString("");
  RxString currentProductColor = RxString("");
  RxString lastWages = RxString("0.00");

  final FocusNode _loomFocusNode = FocusNode();
  final FocusNode _warpStatusFocusNode = FocusNode();
  final FocusNode _productFocusNode = FocusNode();
  final FocusNode _sareeWeightFocusNode = FocusNode();
  final FocusNode inwardQtyFocusNode = FocusNode();
  final FocusNode otherWarpIdFocusNode = FocusNode();
  final FocusNode submitFocusNode = FocusNode();

  var shortCut = RxString("");

  /// Selected account private weft details
  late PrivateWeftItemDataSource dataSource;

  var privateWeftDetails = [];

  /// Product default Meter. Used For Calculation Only
  double defaultMeter = 0;
  num receiveQty = 0;
  num deliveredQty = 0;

  GoodsInwardSlipController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    sareChecker = RxList<SareeCheckerModel>([]);
    controller.otherWarpId.clear();
    controller.warpStatus.clear();
    _warpStatusFocusNode.addListener(() => shortCutKeys());
    _productFocusNode.addListener(() => shortCutKeys());
    _initValue();
    dataSource = PrivateWeftItemDataSource(list: privateWeftDetails);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoodsInwardSlipController>(builder: (controller) {
      return ShortCutWidget(
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
          SingleActivator(LogicalKeyboardKey.keyA, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.f5): LoomFocusIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): ListIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            NavigateIntent:
                SetCounterAction(perform: () => navigateAnotherPage()),
            LoomFocusIntent: SetCounterAction(perform: () => _loomFocus()),
            SaveIntent: SetCounterAction(perform: () => _submitFocus()),
            ListIntent:
                SetCounterAction(perform: () => widget.saveOnPressed!()),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Row(
                                    children: [
                                      MyLoomSearchField(
                                        label: 'Loom',
                                        items: controller.loomList,
                                        textController: loomTextController,
                                        focusNode: _loomFocusNode,
                                        requestFocus: _warpStatusFocusNode,
                                        onChanged: (LoomGroup item) async {
                                          controller.warpStatus.clear();
                                          detailsController.text = '';
                                          if (warpStatusController.value !=
                                              null) {
                                            warpStatusController.value = null;
                                          }
                                          controllerClear();
                                          loomController.value = item;
                                          await warpStatusApiCall();
                                        },
                                      ),
                                      MySearchField(
                                        width: 150,
                                        label: 'Warp Status',
                                        textController:
                                            warpStatusTextController,
                                        items: controller.warpStatus,
                                        focusNode: _warpStatusFocusNode,
                                        requestFocus: inwardQtyFocusNode,
                                        onChanged: (WeaverByLoomStatusModel
                                            item) async {
                                          warpStatusController.value = item;

                                          var weaverId = controller.weaverId;
                                          var loomNo =
                                              loomController.value?.loomNo;
                                          var status = item.currentStatus;
                                          controllerClear();

                                          /// other warp id
                                          otherWarpIdApiCall(item.weaveNo!);

                                          /// Product Details
                                          var data = await controller
                                              .loomByProductDetails(
                                                  loomNo, weaverId, status);
                                          productDetailsDisplay(data);

                                          /// ShortCut Keys private weft api call
                                          privateWeftApiCall(
                                              warpStatusController
                                                  .value?.weaveNo,
                                              warpStatusController
                                                  .value?.productId);
                                        },
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      ExcludeFocusTraversal(
                                        child: MySearchField(
                                          width: 350,
                                          label: 'Product',
                                          textController:
                                              productNameTextController,
                                          focusNode: _productFocusNode,
                                          requestFocus: inwardQtyFocusNode,
                                          items: controller.productDetails,
                                          onChanged: (WeavingProductListModel
                                              item) async {
                                            productName.value = item;
                                            wagesController.text =
                                                "${item.wages}";
                                            inwardQtyController.text = "0";
                                            meterController.text = "0";
                                            amountController.text = "0.00";
                                            detailsController.text = "";
                                            pendingQuantityController.text =
                                                "0";
                                            pendingMeterController.text =
                                                "0.000";
                                            FocusScope.of(context).requestFocus(
                                                inwardQtyFocusNode);
                                          },
                                        ),
                                      ),
                                      MyTextField(
                                        controller: inwardQtyController,
                                        hintText: "Inward-Qty",
                                        width: 100,
                                        validate: 'number',
                                        focusNode: inwardQtyFocusNode,
                                        onChanged: (value) =>
                                            netAmountCalculation(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Obx(
                                        () => ExcludeFocusTraversal(
                                          child: DropDownMultiSelect(
                                            labelText: 'Saree Checker Name',
                                            options: controller.sareChecker,
                                            selectedValues: sareChecker.value,
                                            onChanged: (List<SareeCheckerModel>
                                                item) async {
                                              sareChecker.value = item;
                                            },
                                          ),
                                        ),
                                      ),
                                      Focus(
                                        skipTraversal: true,
                                        child: MyTextField(
                                          width: 150,
                                          focusNode: _sareeWeightFocusNode,
                                          controller: sareeWeightController,
                                          hintText: "Saree Weight",
                                          validate: "double",
                                        ),
                                        onFocusChange: (hasFocus) {
                                          AppUtils.fractionDigitsText(
                                            sareeWeightController,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      ExcludeFocus(
                                        child: MyTextField(
                                          width: 100,
                                          controller: meterController,
                                          hintText: "Meter",
                                          validate: "double",
                                          readonly: true,
                                        ),
                                      ),
                                      Text(
                                        'With: ${withController.text}    Pick: ${pickController.text}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 12),
                                      Obx(
                                        () => Text(
                                          "Last Wages: ${lastWages.value}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Wrap(
                                              children: [
                                                DropDownMultiSelect<
                                                    GoodsInwardOtherWarpModel>(
                                                  focusNode:
                                                      otherWarpIdFocusNode,
                                                  width: 400,
                                                  labelText: 'Other Warp Id',
                                                  options:
                                                      controller.otherWarpId,
                                                  selectedValues:
                                                      otherWarpIds.value,
                                                  onChanged: (List<
                                                          GoodsInwardOtherWarpModel>
                                                      items) async {
                                                    otherWarpIds.value = items;
                                                  },
                                                  menuItembuilder:
                                                      (GoodsInwardOtherWarpModel
                                                          item) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Obx(
                                                          () => Checkbox(
                                                            value: otherWarpIds
                                                                .value
                                                                .contains(item),
                                                            onChanged:
                                                                (isSelected) {
                                                              if (isSelected!) {
                                                                if (!otherWarpIds
                                                                    .value
                                                                    .contains(
                                                                        item)) {
                                                                  otherWarpIds
                                                                      .value
                                                                      .add(
                                                                          item);
                                                                }
                                                              } else {
                                                                otherWarpIds
                                                                    .value
                                                                    .remove(
                                                                        item);
                                                              }
                                                              otherWarpIds
                                                                  .refresh();
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            "${item.warpName}    ${item.otherWarpid}    ${item.balanceMeter}",
                                                            // Display item with additional details
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                  childBuilder: (List<
                                                          GoodsInwardOtherWarpModel>
                                                      selectedItems) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(
                                                        selectedItems.isNotEmpty
                                                            ? selectedItems
                                                                .map((e) =>
                                                                    "${e.otherWarpid} ")
                                                                .join(', ')
                                                            : 'Select Items',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    );
                                                  },
                                                  whenEmpty:
                                                      'Select Other Warp Id',
                                                ),
                                              ],
                                            ),
                                            ExcludeFocusTraversal(
                                              child: Row(
                                                children: [
                                                  MyTextField(
                                                    width: 125,
                                                    controller: wagesController,
                                                    hintText: "Wages(Rs)",
                                                    validate: "double",
                                                    suffix: const Text(
                                                      'Saree',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF5700BC),
                                                      ),
                                                    ),
                                                    onChanged: (value) =>
                                                        netAmountCalculation(),
                                                  ),
                                                  MyTextField(
                                                    width: 120,
                                                    controller:
                                                        amountController,
                                                    hintText: "Amount(Rs)",
                                                    readonly: true,
                                                    validate: "double",
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                ExcludeFocusTraversal(
                                                  child:
                                                      MyDropdownButtonFormField(
                                                    width: 100,
                                                    controller:
                                                        damagedController,
                                                    hintText: "Damaged ?",
                                                    items: const ["No", "Yes"],
                                                    onChanged: (value) {
                                                      nullAmountSet(value);
                                                    },
                                                  ),
                                                ),
                                                MyTextField(
                                                  width: 150,
                                                  controller: detailsController,
                                                  hintText: "Details",
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                MyDropdownButtonFormField(
                                                  width: 100,
                                                  controller: pendingController,
                                                  hintText: "Pending",
                                                  items: const ["No", "Yes"],
                                                  onChanged: (value) {
                                                    nullAmountSet(value);
                                                    if (value == 'Yes') {
                                                      pendingQuantityController
                                                              .text =
                                                          inwardQtyController
                                                              .text;
                                                    } else {
                                                      pendingQuantityController
                                                          .text = '0';
                                                    }
                                                    netAmountCalculation();
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            submitFocusNode);
                                                  },
                                                ),
                                                ExcludeFocus(
                                                  child: MyTextField(
                                                    width: 150,
                                                    controller:
                                                        pendingQuantityController,
                                                    hintText: "Pending Qty",
                                                    validate: "number",
                                                    readonly: true,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: false,
                                                  child: ExcludeFocus(
                                                    child: MyTextField(
                                                      width: 150,
                                                      controller:
                                                          pendingMeterController,
                                                      hintText: "Pending Meter",
                                                      validate: "double",
                                                      readonly: true,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            imageWidget(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Tooltip(
                                                  message: currentProductDetails
                                                      .value,
                                                  child: Text(
                                                    currentProductDetails.value,
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Tooltip(
                                                  message:
                                                      currentProductColor.value,
                                                  child: Text(
                                                    currentProductColor.value,
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Flexible(
                            child: Text(
                              shortCut.value,
                              style: AppUtils.shortCutTextStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        MyElevatedButton(
                          focusNode: submitFocusNode,
                          message: "",
                          onPressed: () => submit(),
                          child: const Text('ADD'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Obx(() => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'DELIVERY QTY : ${deliveredQtyController.value}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'RECEIVED QTY : ${receivedQtyController.value}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'BALANCE QTY : ${balanceQtyController.value}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                    privateWeftItemTable(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future submit() async {
    if (_formKey.currentState!.validate()) {
      if (controller.otherWarpId.isNotEmpty && otherWarpIds.isEmpty) {
        return AppUtils.infoAlert(message: "Select the other warp id");
      }

      double inwardMeter = double.tryParse(meterController.text) ?? 0.0;

      List<String?> selectedWarpId =
          otherWarpIds.map((element) => element.otherWarpid).toList();

      /// check the selected other warp's meter
      double meter = 0.0;
      for (var e in otherWarpIds) {
        meter = (double.tryParse("${e.balanceMeter}") ?? 0.0) - inwardMeter;

        double requiredMeter = meter * -1;
        if (meter < 0) {
          return AppUtils.infoAlert(
              message:
                  "Selected warp id ${e.otherWarpid} meter is less than 6.2 meter, Required Meter is $requiredMeter");
        }
      }

      int inwardQty = int.tryParse(inwardQtyController.text) ?? 0;

      if (deliveredQty == 0) {
        return AppUtils.infoAlert(
            message: "The main warp has not been delivered yet !");
      }

      if (inwardQty == 0) {
        return AppUtils.infoAlert(
            message: "inward quantity is ‘0’. Please enter the quantity.");
      }

      if (inwardQty > controller.balanceQty) {
        return AppUtils.infoAlert(
            message: "Inward Quantity Greater Than To Delivered Quantity");
      }

      var alert = await sameWarpStatusCheck();
      if (alert == "Running") {
        return AppUtils.infoAlert(
            message: "Already running account is available !");
      } else if (alert == "Completed") {
        return AppUtils.infoAlert(
            message: "Already completed account is available !");
      }

      var result = await weftCheckingAlert();

      List<int?> selectedSareeCheckerId =
          sareChecker.map((element) => element.id).toList();
      List<String?> selectedChecker =
          sareChecker.map((element) => element.checkerName).toList();

      String warpStatus = "";

      if (controller.itemList.isNotEmpty) {
        for (var e in controller.itemList) {
          if (e["loom"] == loomController.value?.loomNo &&
              e["current_status"] ==
                  warpStatusController.value?.currentStatus &&
              e["sync"] == 0) {
            warpStatus = (e["current_status"] == "New")
                ? "Running"
                : warpStatusController.value!.currentStatus!;
          } else {
            warpStatus = warpStatusController.value!.currentStatus!;
          }
        }
      } else {
        warpStatus = warpStatusController.value!.currentStatus!;
      }

      if (result == true) {
        Map<String, dynamic> request = {
          "e_date": "${DateTime.now()}".substring(0, 10),
          "sync": 0,
          "loom": loomController.value?.loomNo,
          "current_status": warpStatus,
          "product_name": productName.value?.productName,
          "product_id": productName.value?.id,
          "design_no": designNoController.text,
          "inward_qty": inwardQty,
          "inward_meter": inwardMeter,
          "wages": double.tryParse(wagesController.text) ?? 0,
          "credit": double.tryParse(amountController.text) ?? 0,
          "damaged": damagedController.text,
          "product_details": detailsController.text,
          "pending": pendingController.text,
          "pending_qty": int.tryParse(pendingQuantityController.text) ?? 0,
          "pending_meter": double.tryParse(pendingMeterController.text) ?? 0,
          'product_width': int.tryParse(withController.text) ?? 0,
          'pick': int.tryParse(pickController.text) ?? 0,
          "saree_weight": double.tryParse(sareeWeightController.text) ?? 0.0,
          "saree_checker_name": selectedChecker.join(","),
          "used_other_warp": selectedWarpId.join(","),
          "saree_checker_id": selectedSareeCheckerId,
        };

        controller.itemList.add(request);
        widget.dataSource.updateDataGridRows();
        widget.dataSource.updateDataGridSource();
        controller.getBackBoolean.value = true;
        controller.pendingQtyCalculation();
        controllersClear();
        // Get.back(result: request);
      } else {
        // Get.back();
      }
    }
  }

  void nullAmountSet(String status) {
    if (status == "No") {
      return;
    }

    wagesController.text = "0";
    amountController.text = "0";
    detailsController.text = "No Wages";
  }

  void netAmountCalculation() {
    /// Amount Calculation
    double wages = double.tryParse(wagesController.text) ?? 0.00;
    int inwardQty = int.tryParse(inwardQtyController.text) ?? 0;
    double amount = 0.00;
    detailsController.text = (wages == 0) ? 'No Wages' : "";

    amount = inwardQty * wages;

    amountController.text = amount.toStringAsFixed(2);

    /// inward Meter Calculation
    double meter = defaultMeter;
    double inwardMeter = 0.00;

    inwardMeter = inwardQty * meter;
    meterController.text = inwardMeter.toStringAsFixed(3);
    qtyAndAmountCalculation();
  }

  void qtyAndAmountCalculation() {
    int inwardQty = int.tryParse(inwardQtyController.text) ?? 0;

    /// Pending Meter
    double pendingMeter = 0.00;
    num pendingQty = int.tryParse(pendingQuantityController.text) ?? 0;

    pendingMeter = pendingQty * defaultMeter;

    pendingMeterController.text = pendingMeter.toStringAsFixed(3);

    /// Received Qty Calculation
    num newReceive = receiveQty + inwardQty;
    receivedQtyController.value = int.tryParse("$newReceive") ?? 0;
    num balance = deliveredQty - newReceive;
    balanceQtyController.value = int.tryParse("$balance") ?? 0;
  }

  void productDetailsDisplay(ProductDetailsGoodsInwardModel data) {
    var productList = controller.productDetails
        .where((element) => '${element.id}' == '${data.productId}')
        .toList();
    if (productList.isNotEmpty) {
      productName.value = productList.first;
      productNameTextController.text = productList.first.productName!;
    }
    designNoController.text = tryCast(data.designNo);
    defaultMeter = double.tryParse("${data.meter}") ?? 0.0;
    wagesController.text = "${data.wages}";
    withController.text = "${data.width}";
    pickController.text = "${data.pick}";
    lastWages.value = "${data.previousBill?.wages ?? "0.00"}";
    imageUrl.value = '${HttpUrl.baseUrl}${data.designImage}';
    currentProductDetails.value = tryCast(data.warpDetails);
    currentProductColor.value = tryCast(data.warpColor);

    receiveQty = data.recivedQty ?? 0;
    deliveredQty = data.deliverdQty ?? 0;
    _calculateQuantity();
    netAmountCalculation();
  }

  void controllerClear() {
    if (productName.value != null) {
      productName.value = null;
      productNameTextController.text = "";
    }
    designNoController.text = "";
    meterController.text = "0";
    wagesController.text = "0";
    deliveredQtyController.value = 0;
    receivedQtyController.value = 0;
    withController.text = "0";
    pickController.text = "0";
    lastWages.value = "0.00";
    inwardQtyController.text = "0";
    amountController.text = "0";
    defaultMeter = 0;
    otherWarpIds = RxList<GoodsInwardOtherWarpModel>([]);
  }

  void _calculateQuantity() {
    var loomId = loomController.value?.loomNo;
    var currentStatus = warpStatusController.value?.currentStatus;
    if (loomId == null || currentStatus == null) {
      return;
    }

    var ll = controller.itemList
        .where((e) =>
            e['loom'] == loomId &&
            e['current_status'] == currentStatus &&
            e["sync"] == 0)
        .toList();
    for (var element in ll) {
      receiveQty += element['inward_qty'];
    }

    var balanceQty = deliveredQty - receiveQty;
    controller.balanceQty = balanceQty;
    deliveredQtyController.value = int.tryParse("$deliveredQty") ?? 0;
    receivedQtyController.value = int.tryParse("$receiveQty") ?? 0;
    balanceQtyController.value = int.tryParse("$balanceQty") ?? 0;
  }

  Future weftCheckingAlert() async {
    var weaverId = controller.weaverId;
    var loomNo = loomController.value?.loomNo;
    var currentStatus = warpStatusController.value?.currentStatus;
    var productId = productName.value?.id;
    bool? data = await controller.weftChecking(
        weaverId, loomNo, currentStatus, productId);

    if (data == false) {
      var result = await _privateWetCheckAlert();
      return result;
    } else {
      return true;
    }
  }

  Future _privateWetCheckAlert() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Alert!',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const SizedBox(
            height: 50,
            child: Column(
              children: [
                Text("Private weft is not available!"),
                Text("Do You Want Add?")
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () async => Get.back(result: true),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red), // Border color
              ),
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                if (warpStatusController.value == null ||
                    productName.value == null) {
                  return;
                }
                var weavingAcId = warpStatusController.value?.weaveNo;
                var productId = productName.value?.id;
                var request = {"id": weavingAcId, "product_id": productId};
                var data = await Get.toNamed(
                    AddPrivateWeftRequirement.routeName,
                    arguments: request);
                if (data == 'success') {
                  Get.back(result: true);
                }
              },
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text(
                'Ok',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _initValue() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.lastAddDetails != null) {
        var item = controller.lastAddDetails;
        var loomList = controller.loomList
            .where((element) => '${element.loomNo}' == '${item['loom']}')
            .toList();
        if (loomList.isNotEmpty) {
          loomController.value = loomList.first;
          loomTextController.text = loomList.first.loomNo!;
        }
        var warpStatus = controller.warpStatus
            .where((element) =>
                '${element.currentStatus}' == '${item['current_status']}')
            .toList();
        if (warpStatus.isNotEmpty) {
          warpStatusController.value = warpStatus.first;

          var weaverId = controller.weaverId;
          var loomNo = loomController.value?.loomNo;
          var status = warpStatus.first.currentStatus;

          var data =
              await controller.loomByProductDetails(loomNo, weaverId, status);
          productDetailsDisplay(data);
        }
      }
    });
  }

  Future<void> warpStatusApiCall() async {
    var weaverId = controller.weaverId;
    var loomId = loomController.value?.loomNo;
    if (loomId!.isEmpty) {
      return;
    }

    List<WeaverByLoomStatusModel> data =
        await controller.loomWarpStatus(weaverId, loomId);

    var index = data.indexWhere((e) => e.currentStatus == 'Running');
    initWarpStatus(
        index: index != -1 ? index : 0, loomId: loomId, weaverId: weaverId);
  }

  void initWarpStatus({var index = 0, var loomId, var weaverId}) async {
    if (controller.warpStatus.isNotEmpty) {
      var item = controller.warpStatus[index];
      warpStatusController.value = item;

      otherWarpIdApiCall(item.weaveNo!);

      warpStatusTextController.text = item.currentStatus!;
      if (warpStatusController.value != null) {
        var status = warpStatusController.value?.currentStatus;

        /// Product Details
        var item =
            await controller.loomByProductDetails(loomId, weaverId, status);
        productDetailsDisplay(item);
        privateWeftApiCall(warpStatusController.value?.weaveNo,
            warpStatusController.value?.productId);
      }
    }
  }

  void shortCutKeys() {
    if (_warpStatusFocusNode.hasFocus) {
      shortCut.value = "To Create 'Weaving Page',Press Alt+C ";
    } else if (_productFocusNode.hasFocus) {
      shortCut.value = "To Create 'Product',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_warpStatusFocusNode.hasFocus) {
      var weaverId = controller.weaverId;
      var loomNo = loomController.value?.loomNo;

      var request = {"weaver_id": weaverId, "loom_no": loomNo};

      if (weaverId == null || loomNo == null) {
        return;
      }

      /// (Alt + c) press to save the last add unSaves data's
      shortCutToSaveData();

      var result = await Get.toNamed(AddWeaving.routeName, arguments: request);

      if (result == null) {
        var id = controller.weaverId;
        controller.loomInfo(id);
        getApiCall();
        warpStatusApiCall();
        controller.getBackBoolean.value = false;
      }
    } else if (_productFocusNode.hasFocus) {
      var result = await Get.toNamed(AddProductInfo.routeName);

      if (result == "success") {
        controller.productInfo();
      }
    }
  }

  sameWarpStatusCheck() {
    /// Check the selected weaver, loom, warp status, and inward quantity
    /// to verify if the same warp status is already available

    var currentStatus = warpStatusController.value?.currentStatus;
    int balanceQty = int.tryParse("${balanceQtyController.value}") ?? 0;
    if (currentStatus == "Running") {
      if (balanceQty == 0) {
        var result = controller.warpStatus
            .where((element) => "${element.currentStatus}" == "Completed");

        if (result.isNotEmpty) {
          return "Completed";
        }
      }
    }

    if (currentStatus == "New") {
      var result = controller.warpStatus
          .where((element) => "${element.currentStatus}" == "Running");

      if (result.isNotEmpty) {
        return "Running";
      }
    }
  }

  void controllersClear() {
    otherWarpIds.value = [];
    loomController.value = null;
    loomTextController.text = "";
    warpStatusController.value = null;
    warpStatusTextController.text = "";
    productName.value = null;
    productNameTextController.text = "";
    inwardQtyController.text = "0";
    meterController.text = "0";
    wagesController.text = "0.00";
    amountController.text = "0.00";
    damagedController.text = "No";
    detailsController.text = "";
    pendingController.text = "No";
    pendingQuantityController.text = "0";
    pendingMeterController.text = "0";
    sareeWeightController.text = "0.000";
    sareChecker = RxList<SareeCheckerModel>([]);
    controller.change(otherWarpIds = RxList<GoodsInwardOtherWarpModel>([]));
    controller.otherWarpId.clear();
    deliveredQtyController.value = 0;
    receivedQtyController.value = 0;
    balanceQtyController.value = 0;
    FocusScope.of(context).requestFocus(_loomFocusNode);

    // Clear private weft details
    privateWeftDetails.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  Widget imageWidget() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.all(8),
        width: 180,
        height: 180,
        child: CachedNetworkImage(
          imageUrl: '${imageUrl.value}',
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Image.asset(
            Constants.placeHolderPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Future<void> shortCutToSaveData() async {
    if (controller.itemList.isEmpty) {
      return;
    }
    controller.shortCutToSave = true;

    int? id = controller.id;
    String? date = controller.date;
    int? weaverId = controller.weaverId;

    /// id is null save api call

    Map<String, dynamic> request = {
      "weaver_id": weaverId,
      "e_date": date,
    };

    if (id == null) {
      request["item_details"] = controller.itemList;
      var result = await controller.shortCuteAdd(request);
      for (var item in controller.itemList) {
        item['sync'] = 1;
        widget.dataSource.updateDataGridRows();
        widget.dataSource.updateDataGridSource();
      }

      controller.id = result["id"];
      controller.challanNo = result["challan_no"];
    } else {
      updateApiCall(request);
    }
  }

  void updateApiCall(Map<String, dynamic> request) {
    int? id = controller.id;
    int? challanNo = controller.challanNo;
    request["challan_no"] = challanNo;

    var resentAdded = [];
    for (var item in controller.itemList) {
      if (item["sync"] == 0) {
        resentAdded.add(item);
      }
    }
    request["item_details"] = resentAdded;
    controller.shortCuteEdit(request, id);
    for (var item in controller.itemList) {
      item['sync'] = 1;
      widget.dataSource.updateDataGridRows();
      widget.dataSource.updateDataGridSource();
    }
  }

  /// after save get the details in API
  Future<void> getApiCall() async {
    int? recNo = controller.id;
    int? challanNo = controller.challanNo;

    if (recNo == null || challanNo == null) {
      return;
    }

    controller.itemList.clear();

    /// get API call
    var item = await controller.challanNoByDetails(challanNo, recNo);
    item.itemDetails?.forEach((element) {
      var result = element.toJson();
      controller.itemList.add(result);
      widget.dataSource.updateDataGridRows();
      widget.dataSource.updateDataGridSource();
    });
    // controller.getBackBoolean.value = false;
  }

  void _loomFocus() {
    FocusScope.of(context).requestFocus(_loomFocusNode);
  }

  void _submitFocus() {
    if (otherWarpIdFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(submitFocusNode);
    }
  }

  void otherWarpIdApiCall(int? weaveNo) async {
    if (weaveNo == null) {
      return;
    }
    otherWarpIds = RxList<GoodsInwardOtherWarpModel>([]);
    List<String> result = await controller.otherWarpIdDetails(weaveNo);

    var otherWarpId = controller.otherWarpId;

    for (int i = 0; i < result.length; i++) {
      for (int j = 0; j < otherWarpId.length; j++) {
        if (result[i] == otherWarpId[j].otherWarpid) {
          otherWarpIds.value.add(otherWarpId[j]);
        }
      }
    }
  }

  void privateWeftApiCall(var weavingAcId, var productId) async {
    privateWeftDetails.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();

    PrivateWeftRequirementListModel? item = await controller
        .weavingAcIdByPrivateWeftDetails(weavingAcId, productId);
    item?.itemDetails?.forEach((element) {
      var result = element.toJson();
      privateWeftDetails.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    });
  }

  Widget privateWeftItemTable() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Private weft details"),
        MySFDataGridItemTable(
          selectionMode: SelectionMode.single,
          columns: [
            GridColumn(
              columnName: 'yarn_name',
              label: const MyDataGridHeader(title: 'Yarn Name'),
            ),
            GridColumn(
              width: 110,
              columnName: 'quantity',
              label: const MyDataGridHeader(title: 'Quantity (Kg)'),
            ),
            GridColumn(
              width: 110,
              columnName: 'weft_type',
              label: const MyDataGridHeader(title: 'Weft Type'),
            ),
          ],
          source: dataSource,
        ),
      ],
    );
  }
}

class PrivateWeftItemDataSource extends DataGridSource {
  PrivateWeftItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'weft_type', value: e['weft_type']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      double value = double.tryParse('${dataGridCell.value}') ?? 0;
      final columnName = dataGridCell.columnName;
      switch (columnName) {
        case 'quantity':
          return buildFormattedCell(value, decimalPlaces: 3);
        default:
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dataGridCell.value != null ? '${dataGridCell.value}' : '',
              style: AppUtils.cellTextStyle(),
            ),
          );
      }
    }).toList());
  }

  Widget buildFormattedCell(dynamic value, {int decimalPlaces = 2}) {
    if (value is num) {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        decimalDigits: decimalPlaces,
        name: '',
      );
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          formatter.format(value),
          style: AppUtils.cellTextStyle(),
        ),
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null ? '$value' : '',
        style: AppUtils.cellTextStyle(),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
