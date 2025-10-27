import 'dart:convert';

import 'package:abtxt/view/trasaction/warp_order/warp_order_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../model/ProductInfoModel.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../model/warp_order_model.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MultiSelect.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/ledger/addledger.dart';

class AddWarpOrder extends StatefulWidget {
  const AddWarpOrder({Key? key}) : super(key: key);
  static const String routeName = '/AddWarpOrder';

  @override
  State<AddWarpOrder> createState() => _State();
}

class _State extends State<AddWarpOrder> {
  TextEditingController idController = TextEditingController();
  TextEditingController warpOrderTypeController = TextEditingController();
  TextEditingController orderForController = TextEditingController();
  Rxn<LedgerModel> ledgerNameController = Rxn<LedgerModel>();
  TextEditingController orderNoController = TextEditingController();
  TextEditingController orderDateController = TextEditingController();
  TextEditingController warpIDNoController = TextEditingController();
  TextEditingController warpDeliveryToController = TextEditingController();
  TextEditingController fromNotificationController = TextEditingController();
  TextEditingController noController = TextEditingController();
  Rxn<LedgerModel> weaverNameController = Rxn<LedgerModel>();
  TextEditingController loomNoController = TextEditingController();
  TextEditingController weavingStatusController = TextEditingController();
  TextEditingController weavingNoController = TextEditingController();
  Rxn<ProductInfoModel> productNameController = Rxn<ProductInfoModel>();
  TextEditingController productMeterController = TextEditingController();
  Rxn<WarpDesignSheetModel> warpDesignController = Rxn<WarpDesignSheetModel>();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController weavingBreakController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController meterController = TextEditingController();
  TextEditingController emptyDeliveryController = TextEditingController();
  TextEditingController emptyQtyController = TextEditingController();
  List<NewColorModel> selectedWarpColor = <NewColorModel>[].obs;
  TextEditingController detailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late WarpOrderController controller;

  var winderList = <dynamic>[].obs;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOrderController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text("${idController.text == '' ? 'Add' : 'Update'} Warp Order"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: Get.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              margin: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Visibility(
                          visible: false,
                          child: MyTextField(
                            controller: idController,
                            hintText: "ID",
                            validate: "",
                            enabled: false,
                          ),
                        ),
                        MyDropdownButtonFormField(
                            controller: warpOrderTypeController,
                            hintText: "Warp Order Type",
                            items: Constants.WarpOrderType),
                        MyDropdownButtonFormField(
                            controller: orderForController,
                            hintText: "Order for",
                            items: Constants.Orderfor),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 240,
                              padding: const EdgeInsets.all(8),
                              child: DropdownButtonFormField(
                                style: TextStyle(
                                    color: Color(0xFF141414),
                                    fontSize: 14,
                                    fontFamily: 'Poppins'),
                                value: ledgerNameController.value,
                                items:
                                    controller.ledgerName.map((LedgerModel item) {
                                  return DropdownMenuItem<LedgerModel>(
                                    value: item,
                                    child: Text(
                                      '${item.ledgerName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (LedgerModel? value) {
                                  ledgerNameController.value = value;
                                },
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    border: OutlineInputBorder(),
                                    // hintText: 'Select',
                                    labelText: 'Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF939393),
                                      width: 0.4,
                                    ),
                                  ),
                                  labelStyle: TextStyle(fontSize: 14),),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        MyCreateNew(
                          onPressed: () async {
                            var item = await Get.toNamed(AddLedger.routeName);
                            controller.onInit();
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        MyTextField(
                          controller: orderNoController,
                          hintText: "Order No",
                          validate: "string",
                        ),
                        MyDateField(
                          controller: orderDateController,
                          hintText: "Order Date",
                          validate: "string",
                          readonly: true,
                        ),
                        MyTextField(
                          controller: warpIDNoController,
                          hintText: "Warp ID No",
                          validate: "string",
                        ),
                        MyDropdownButtonFormField(
                            controller: warpDeliveryToController,
                            hintText: "Warp Delivery to",
                            items: Constants.WarpDeliveryto),
                        MyDropdownButtonFormField(
                            controller: fromNotificationController,
                            hintText: "From Notification",
                            items: Constants.FromNotification),
                        MyTextField(
                          controller: noController,
                          hintText: "No",
                          validate: "number",
                        ),
                      ],
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 240,
                              padding: const EdgeInsets.all(8),
                              child: DropdownButtonFormField(
                                style: TextStyle(
                                    color: Color(0xFF141414),
                                    fontSize: 14,
                                    fontFamily: 'Poppins'),
                                value: weaverNameController.value,
                                items:
                                    controller.weaverName.map((LedgerModel item) {
                                  return DropdownMenuItem<LedgerModel>(
                                    value: item,
                                    child: Text(
                                      '${item.ledgerName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (LedgerModel? value) {
                                  weaverNameController.value = value;
                                },
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    border: OutlineInputBorder(),
                                    // hintText: 'Select',
                                    labelText: 'Weaver Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF939393),
                                      width: 0.4,
                                    ),
                                  ),
                                  labelStyle: TextStyle(fontSize: 14),),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        MyCreateNew(
                          onPressed: () async {
                            var item = await Get.toNamed(AddLedger.routeName);
                            controller.onInit();
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        MyTextField(
                          controller: loomNoController,
                          hintText: "Loom No",
                          validate: "number",
                        ),
                        MyDropdownButtonFormField(
                            controller: weavingStatusController,
                            hintText: "Weaving Status",
                            items: Constants.WeavingStatus),
                        MyTextField(
                          controller: weavingNoController,
                          hintText: "Weaving No",
                          validate: "double",
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 240,
                              padding: const EdgeInsets.all(8),
                              child: DropdownButtonFormField(
                                style: TextStyle(
                                    color: Color(0xFF141414),
                                    fontSize: 14,
                                    fontFamily: 'Poppins'),
                                value: productNameController.value,
                                items: controller.ProductName.map(
                                    (ProductInfoModel item) {
                                  return DropdownMenuItem<ProductInfoModel>(
                                    value: item,
                                    child: Text(
                                      '${item.productName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (ProductInfoModel? value) {
                                  productNameController.value = value;
                                },
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    border: OutlineInputBorder(),
                                    // hintText: 'Select',
                                    labelText: 'Product Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF939393),
                                      width: 0.4,
                                    ),
                                  ),
                                  labelStyle: TextStyle(fontSize: 14),),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        MyTextField(
                          controller: productMeterController,
                          hintText: "Product Meter",
                          validate: "double",
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 240,
                              padding: const EdgeInsets.all(8),
                              child: DropdownButtonFormField(
                                style: TextStyle(
                                    color: Color(0xFF141414),
                                    fontSize: 14,
                                    fontFamily: 'Poppins'),
                                value: warpDesignController.value,
                                items: controller.WarpdesignSheet.map(
                                    (WarpDesignSheetModel item) {
                                  return DropdownMenuItem<WarpDesignSheetModel>(
                                    value: item,
                                    child: Text(
                                      '${item.designName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (WarpDesignSheetModel? value) {
                                  warpDesignController.value = value;
                                },
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    border: OutlineInputBorder(),
                                    // hintText: 'Select',
                                    labelText: 'Warp Design',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF939393),
                                      width: 0.4,
                                    ),
                                  ),
                                  labelStyle: TextStyle(fontSize: 14),),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        MyTextField(
                          controller: warpTypeController,
                          hintText: "Warp Type",
                          validate: "string",
                        ),
                        MyDropdownButtonFormField(
                            controller: weavingBreakController,
                            hintText: "Weaving Break",
                            items: Constants.WeavingBreak),
                        MyTextField(
                          controller: quantityController,
                          hintText: "Quantity",
                          validate: "number",
                        ),
                        MyTextField(
                          controller: meterController,
                          hintText: "Meter",
                          validate: "double",
                        ),
                        MyDropdownButtonFormField(
                            controller: emptyDeliveryController,
                            hintText: "Empty Delivery",
                            items: Constants.UsedEmpty),
                        MyTextField(
                          controller: emptyQtyController,
                          hintText: "Empty Qty",
                          validate: "number",
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(7),
                              child: SizedBox(
                                width: 226,
                                child: DropDownMultiSelect(
                                  onChanged: (List<dynamic> x) {
                                    var json = jsonDecode(jsonEncode(x));
                                    var items = (json as List)
                                        .map((i) => NewColorModel.fromJson(i))
                                        .toList();
                                    selectedWarpColor = items;
                                  },
                                  labelText: 'Warp Color',
                                  options: controller.colorDropdown,
                                  selectedValues: selectedWarpColor,
                                  validator: (value) => selectedWarpColor.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MyTextField(
                          controller: detailsController,
                          hintText: "Details",
                          validate: "string",
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 200,
                          child: MyElevatedButton(
                            color: Colors.red,
                            onPressed: () => Get.back(),
                            child: Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 200,
                          child: MyElevatedButton(
                            onPressed: () => submit(),
                            child: Text(
                                "${Get.arguments == null ? 'Save' : 'Update'}"),
                          ),
                        ),
                      ],
                    ),
                  ],
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
      Map<String, dynamic> request = {
        "warp_order_type": warpOrderTypeController.text,
        "order_for": orderForController.text,
        "ledger_id": ledgerNameController.value?.id,
        "order_no": orderNoController.text,
        "order_date": orderDateController.text,
        "warp_id_no": warpIDNoController.text,
        "warp_delivery_to": warpDeliveryToController.text,
        "from_notification": fromNotificationController.text,
        "warp_no": noController.text,
        "weaver_id": weaverNameController.value?.id,
        "loom_no": loomNoController.text,
        "weaving_status": weavingStatusController.text,
        "product_id": productNameController.value?.id,
        "product_meter": productMeterController.text,
        "warp_design_id": warpDesignController.value?.id,
        "warp_type": warpTypeController.text,
        "weaving_break": weavingBreakController.text,
        "qty": quantityController.text,
        "warp_metter": meterController.text,
        "empty_delivery": emptyDeliveryController.text,
        "empty_qty": emptyQtyController.text,
        "warp_color": selectedWarpColor.join(","),
        "details": detailsController.text ?? '',
        "weaving_no": weavingNoController.text,
      };

      print(jsonEncode(request));
      var id = idController.text;
      if (id.isEmpty) {
        controller.addwarporders(request);
      } else {
        request['id'] = '$id';
        controller.updatewarporders(request);
      }
    }
  }

  void _initValue() {
    WarpOrderController controller = Get.find();

    warpOrderTypeController.text = Constants.WarpOrderType[0];
    orderForController.text = Constants.Orderfor[0];
    warpDeliveryToController.text = Constants.WarpDeliveryto[0];
    fromNotificationController.text = Constants.FromNotification[0];
    weavingStatusController.text = Constants.WeavingStatus[0];
    emptyDeliveryController.text = Constants.UsedEmpty[0];
    weavingBreakController.text = Constants.WeavingBreak[0];

    if (Get.arguments != null) {
      WarpOrderController controller = Get.find();
      WarpsOrder warporderlist = Get.arguments['item'];
      idController.text = '${warporderlist.id}';
      warpOrderTypeController.text = '${warporderlist.warpOrderType}';
      orderForController.text = '${warporderlist.orderFor}';
      orderNoController.text = '${warporderlist.orderNo}';
      orderDateController.text = '${warporderlist.orderDate}';
      warpIDNoController.text = '${warporderlist.warpIdNo}';
      warpDeliveryToController.text = '${warporderlist.warpDeliveryTo}';
      fromNotificationController.text = '${warporderlist.fromNotification}';
      noController.text = '${warporderlist.warpNo}';
      loomNoController.text = '${warporderlist.loomNo}';
      weavingStatusController.text = '${warporderlist.weavingStatus}';
      weavingNoController.text = '${warporderlist.weavingNo}';
      productMeterController.text = '${warporderlist.productMeter}';
      warpTypeController.text = '${warporderlist.warpType}';
      weavingBreakController.text = '${warporderlist.weavingBreak}';
      quantityController.text = '${warporderlist.productId}';
      meterController.text = '${warporderlist.warpMetter}';
      emptyDeliveryController.text = '${warporderlist.emptyDelivery}';
      emptyQtyController.text = '${warporderlist.emptyQty}';
      detailsController.text = '${warporderlist.details}';

      // Ledger Name
      var ledgerNameList = controller.ledgerName
          .where((element) => '${element.id}' == '${warporderlist.ledgerId}')
          .toList();
      if (ledgerNameList.isNotEmpty) {
        ledgerNameController.value = ledgerNameList.first;
      }
      // Weaver Name
      var WeaverNameList = controller.weaverName
          .where((element) => '${element.id}' == '${warporderlist.weaverId}')
          .toList();
      if (WeaverNameList.isNotEmpty) {
        weaverNameController.value = WeaverNameList.first;
      }
      // Product name
      var ProductNameList = controller.ProductName.where(
              (element) => '${element.id}' == '${warporderlist.productId}')
          .toList();
      if (ProductNameList.isNotEmpty) {
        productNameController.value = ProductNameList.first;
      }
      //WrpDesign
      var WarpDesignList = controller.WarpdesignSheet.where(
              (element) => '${element.id}' == '${warporderlist.warpDesignId}')
          .toList();
      if (WarpDesignList.isNotEmpty) {
        warpDesignController.value = WarpDesignList.first;
      }
      // color Name
      var colorList = controller.colorDropdown
          .where((element) =>
              '${element.name}' ==
              '${warporderlist.warpColor?.warpColor?.split(",").first}')
          .toList();
      if (colorList.isNotEmpty) {
        selectedWarpColor = colorList;
      }
    }
  }
}
