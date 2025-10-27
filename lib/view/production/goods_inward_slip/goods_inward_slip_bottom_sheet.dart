import 'package:abtxt/model/LoomGroup.dart';
import 'package:abtxt/model/weaving_models/ProductDetailsGoodsInwardModel.dart';
import 'package:abtxt/model/weaving_models/WeavingProductListModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/productinfo/add_product_info.dart';
import 'package:abtxt/view/production/weaving_weft_balance/private_weft_requirement/add_private_weft_requirements.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/my_autocompletes/loom_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/weaving_models/WeaverByLoomStatusModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../weaving/add_weaving.dart';
import 'goods_inward_slip_controller.dart';

class GoodsInwardSlipBottomSheet extends StatefulWidget {
  const GoodsInwardSlipBottomSheet({super.key});

  static const String routeName = '/goods_inward_slip_bottom_sheet';

  @override
  State<GoodsInwardSlipBottomSheet> createState() => _State();
}

class _State extends State<GoodsInwardSlipBottomSheet> {
  Rxn<LoomGroup> loom = Rxn<LoomGroup>();
  Rxn<WeaverByLoomStatusModel> warpStatusController =
      Rxn<WeaverByLoomStatusModel>();
  Rxn<WeavingProductListModel> productName = Rxn<WeavingProductListModel>();
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
  RxInt deliveredQtyController = RxInt(0);
  RxInt receivedQtyController = RxInt(0);
  RxInt balanceQtyController = RxInt(0);
  final FocusNode _warpStatusFocusNode = FocusNode();
  final FocusNode _productFocusNode = FocusNode();
  final FocusNode inwardQtyFocusNode = FocusNode();
  var shortCut = RxString("");

  /// Product default Meter. Used For Calculation Only
  double defaultMeter = 0;
  num receiveQty = 0;
  num deliveredQty = 0;

  GoodsInwardSlipController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.warpStatus.clear();
    _warpStatusFocusNode.addListener(() => shortCutKeys());
    _productFocusNode.addListener(() => shortCutKeys());
    _initValue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoodsInwardSlipController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text('Add Item - Goods Inward Slip'),
        ),
        loadingStatus: controller.status.isLoading,
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),

        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    Row(
                                      children: [
                                        MyLoomAutoComplete(
                                          label: 'Loom',
                                          items: controller.loomList,
                                          selectedItem: loom.value,
                                          forceNextFocus: true,
                                          onChanged: (LoomGroup item) async {
                                            controller.warpStatus.clear();
                                            detailsController.text = '';
                                            if (warpStatusController.value !=
                                                null) {
                                              warpStatusController.value = null;
                                            }
                                            controllerClear();
                                            loom.value = item;
                                            await warpStatusApiCall();
                                          },
                                        ),
                                        Obx(
                                          () => Focus(
                                            focusNode: _warpStatusFocusNode,
                                            skipTraversal: true,
                                            child: MyAutoComplete(
                                              label: 'Warp Status',
                                              items: controller.warpStatus,
                                              forceNextFocus: true,
                                              selectedItem:
                                                  warpStatusController.value,
                                              onChanged:
                                                  (WeaverByLoomStatusModel
                                                      item) async {
                                                warpStatusController.value =
                                                    item;
                                                var weaverId =
                                                    controller.weaverId;
                                                var loomNo = loom.value?.loomNo;
                                                var status = item.currentStatus;
                                                controllerClear();

                                                /// Product Details
                                                var data = await controller
                                                    .loomByProductDetails(
                                                        loomNo,
                                                        weaverId,
                                                        status);
                                                productDetailsDisplay(data);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyAutoComplete(
                                              width: 350,
                                              label: 'Product',
                                              items: controller.productDetails,
                                              selectedItem: productName.value,
                                              onChanged:
                                                  (WeavingProductListModel
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
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        inwardQtyFocusNode);
                                              },
                                            ),
                                            Text(
                                              'With: ${withController.text}    Pick: ${pickController.text}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                        ),

                                        /*MyTextField(
                                          width: 130,
                                          controller: designNoController,
                                          hintText: "Design No",
                                          readonly: true,
                                          // validate: "String",
                                        ),*/
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        MyTextField(
                                          controller: inwardQtyController,
                                          hintText: "Inward-Qty",
                                          width: 150,
                                          validate: 'number',
                                          focusNode: inwardQtyFocusNode,
                                          onChanged: (value) =>
                                              qtyAndAmountCalculation(),
                                        ),
                                        /*MyTextField(
                                          width: 100,
                                          controller: withController,
                                          hintText: "With",
                                          validate: "number",
                                          readonly: true,
                                        ),
                                        MyTextField(
                                          width: 100,
                                          controller: pickController,
                                          hintText: "Pick",
                                          validate: "number",
                                          readonly: true,
                                        ),*/
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        /*MyTextField(
                                          controller: inwardQtyController,
                                          hintText: "Inward-Qty",
                                          validate: 'number',
                                          focusNode: inwardQtyFocusNode,
                                          onChanged: (value) =>
                                              qtyAndAmountCalculation(),
                                        ),*/
                                        ExcludeFocus(
                                          child: MyTextField(
                                            controller: meterController,
                                            hintText: "Meter",
                                            validate: "double",
                                            readonly: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        MyTextField(
                                          controller: wagesController,
                                          hintText: "Wages(Rs)",
                                          validate: "double",
                                          suffix: const Text(
                                            'Saree',
                                            style: TextStyle(
                                              color: Color(0xFF5700BC),
                                            ),
                                          ),
                                          onChanged: (value) =>
                                              qtyAndAmountCalculation(),
                                        ),
                                        ExcludeFocus(
                                          child: MyTextField(
                                            controller: amountController,
                                            hintText: "Amount(Rs)",
                                            readonly: true,
                                            validate: "double",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        ExcludeFocusTraversal(
                                          child: MyDropdownButtonFormField(
                                            controller: damagedController,
                                            hintText: "Damaged ?",
                                            items: const ["No", "Yes"],
                                            onChanged: (value) {
                                              nullAmountSet(value);
                                            },
                                          ),
                                        ),
                                        MyTextField(
                                          controller: detailsController,
                                          hintText: "Details",
                                        ),
                                      ],
                                    ),
                                    MyDropdownButtonFormField(
                                      controller: pendingController,
                                      hintText: "Pending",
                                      items: const ["No", "Yes"],
                                      onChanged: (value) {
                                        nullAmountSet(value);
                                        if (value == 'Yes') {
                                          pendingQuantityController.text =
                                              inwardQtyController.text;
                                        } else {
                                          pendingQuantityController.text = '0';
                                        }
                                        qtyAndAmountCalculation();
                                      },
                                    ),
                                    ExcludeFocus(
                                      child: MyTextField(
                                        controller: pendingQuantityController,
                                        hintText: "Pending Qty",
                                        validate: "number",
                                        readonly: true,
                                        onChanged: (value) {
                                          qtyAndAmountCalculation();
                                        },
                                      ),
                                    ),
                                    ExcludeFocus(
                                      child: MyTextField(
                                        controller: pendingMeterController,
                                        hintText: "Pending Meter",
                                        validate: "double",
                                        readonly: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                            flex: 2,
                            child: Obx(() => Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        '${deliveredQtyController.value}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: const Text('DELIVERY QTY'),
                                    ),
                                    ListTile(
                                      title: Text(
                                        '${receivedQtyController.value}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: const Text('RECEIVED QTY'),
                                    ),
                                    ListTile(
                                      title: Text(
                                        '${balanceQtyController.value}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: const Text('BALANCE QTY'),
                                    ),
                                  ],
                                )))
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(shortCut.value,
                              style: AppUtils.shortCutTextStyle()),
                        ),
                        const SizedBox(width: 12),
                        MyElevatedButton(
                          message: "",
                          onPressed: () => submit(),
                          child: const Text('ADD'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
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

      if (result == true) {
        Map<String, dynamic> request = {
          "e_date": "${DateTime.now()}".substring(0, 10),
          "sync": 0,
          "loom": loom.value?.loomNo,
          "current_status": warpStatusController.value?.currentStatus,
          "product_name": productName.value?.productName,
          "product_id": productName.value?.id,
          "design_no": designNoController.text,
          "inward_qty": inwardQty,
          "inward_meter": double.tryParse(meterController.text) ?? 0,
          "wages": double.tryParse(wagesController.text) ?? 0,
          "credit": double.tryParse(amountController.text) ?? 0,
          "damaged": damagedController.text,
          "product_details": detailsController.text,
          "pending": pendingController.text,
          "pending_qty": int.tryParse(pendingQuantityController.text) ?? 0,
          "pending_meter": double.tryParse(pendingMeterController.text) ?? 0,
          'product_width': int.tryParse(withController.text) ?? 0,
          'pick': int.tryParse(pickController.text) ?? 0,
        };
        Get.back(result: request);
      } else {
        Get.back();
      }
    }
  }

  nullAmountSet(String status) {
    if (status == "No") {
      return;
    }

    wagesController.text = "0";
    amountController.text = "0";
    detailsController.text = "No Wages";
  }

  qtyAndAmountCalculation() {
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
    }
    designNoController.text = tryCast(data.designNo);
    defaultMeter = double.tryParse("${data.meter}") ?? 0.0;
    wagesController.text = "${data.wages}";
    withController.text = "${data.width}";
    pickController.text = "${data.pick}";

    receiveQty = data.recivedQty ?? 0;
    deliveredQty = data.deliverdQty ?? 0;
    _calculateQuantity();
  }

  controllerClear() {
    if (productName.value != null) {
      productName.value = null;
    }
    designNoController.text = "";
    meterController.text = "0";
    wagesController.text = "0";
    deliveredQtyController.value = 0;
    receivedQtyController.value = 0;
    withController.text = "0";
    pickController.text = "0";
    inwardQtyController.text = "0";
    amountController.text = "0";
    defaultMeter = 0;
  }

  _calculateQuantity() {
    var loomId = loom.value?.loomNo;
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

  weftCheckingAlert() async {
    var weaverId = controller.weaverId;
    var loomNo = loom.value?.loomNo;
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

  _privateWetCheckAlert() {
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
          loom.value = loomList.first;
        }
        var warpStatus = controller.warpStatus
            .where((element) =>
                '${element.currentStatus}' == '${item['current_status']}')
            .toList();
        if (warpStatus.isNotEmpty) {
          warpStatusController.value = warpStatus.first;

          var weaverId = controller.weaverId;
          var loomNo = loom.value?.loomNo;
          var status = warpStatus.first.currentStatus;

          var data =
              await controller.loomByProductDetails(loomNo, weaverId, status);
          productDetailsDisplay(data);
        }
      }
    });
  }

  warpStatusApiCall() async {
    var weaverId = controller.weaverId;
    var loomId = loom.value?.loomNo;
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
      if (warpStatusController.value != null) {
        var status = warpStatusController.value?.currentStatus;

        /// Product Details
        var item =
            await controller.loomByProductDetails(loomId, weaverId, status);
        productDetailsDisplay(item);
      }
    }
  }

  shortCutKeys() {
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
      var loomNo = loom.value?.loomNo;

      var request = {"weaver_id": weaverId, "loom_no": loomNo};

      if (weaverId == null || loomNo == null) {
        return;
      }

      var result = await Get.toNamed(AddWeaving.routeName, arguments: request);

      if (result == null) {
        var id = controller.weaverId;
        controller.loomInfo(id);
        warpStatusApiCall();
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
}
