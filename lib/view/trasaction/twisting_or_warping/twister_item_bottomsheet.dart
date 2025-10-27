//TwisterItemBottomSheet

import 'package:abtxt/model/TwisterWarpingLotModel.dart';
import 'package:abtxt/view/trasaction/twisting_or_warping/twisting_or_warping_controller.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/NewColorModel.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../model/YarnModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/new_color/add_new_color.dart';
import '../../basics/warp_design_sheet/add_warp_design_sheet.dart';
import '../../basics/yarn/add_yarn.dart';

class TwisterItemBottomSheet extends StatefulWidget {
  const TwisterItemBottomSheet({super.key});

  @override
  State<TwisterItemBottomSheet> createState() => _TwisterItemBottomSheetState();
}

class _TwisterItemBottomSheetState extends State<TwisterItemBottomSheet> {
  TextEditingController date = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();
  TextEditingController entryTypeController = TextEditingController();

  late TwistingOrWarpingController controller;

  //Opening Balance _Wight

  TextEditingController openingBalanceDeliveredweight = TextEditingController();
  TextEditingController openingBalanceReceivedwight = TextEditingController();
  TextEditingController openingBalanceCops = TextEditingController();
  TextEditingController openingBalanceReel = TextEditingController();
  TextEditingController openingBalanceDetails = TextEditingController();

  //Delivery
  Rxn<YarnModel> deliveryYarnname = Rxn<YarnModel>();
  Rxn<NewColorModel> deliveryColorname = Rxn<NewColorModel>();
  TextEditingController deliveryDeliveryfrom = TextEditingController();
  TextEditingController deliveryBoxno = TextEditingController();
  TextEditingController deliveryStock = TextEditingController();
  TextEditingController deliveryHolder = TextEditingController();
  TextEditingController deliveryQuantity = TextEditingController();

  //YarnInward

  Rxn<YarnModel> yarnInwardYarnName = Rxn<YarnModel>();
  Rxn<NewColorModel> yarnInwardColorName = Rxn<NewColorModel>();
  TextEditingController yarnInwardStockto = TextEditingController();
  TextEditingController yarnInwardBoxNo = TextEditingController();
  TextEditingController yarnInwardEmpty = TextEditingController();
  TextEditingController yarnInwardHolder = TextEditingController();
  TextEditingController yarnInwardQuantitys = TextEditingController();
  TextEditingController yarnInwardWages = TextEditingController();
  TextEditingController yarnInwardAmount = TextEditingController();

  // Warp Inward
  Rxn<WarpDesignSheetModel> warpInwardWarpDesign = Rxn<WarpDesignSheetModel>();
  TextEditingController warpInwardWarptype = TextEditingController();
  TextEditingController warpInwardWarpid = TextEditingController();
  TextEditingController warpInwardQuantity = TextEditingController();
  TextEditingController warpInwardYards = TextEditingController();
  TextEditingController warpInwardWages = TextEditingController();
  TextEditingController warpInwardAmount = TextEditingController();
  TextEditingController warpInwardFromOrder = TextEditingController();
  TextEditingController warpInwardOrderSno = TextEditingController();

  // Wastage
  TextEditingController wastageWastageweight = TextEditingController();
  TextEditingController wastageRaters = TextEditingController();
  TextEditingController wastageDeducation = TextEditingController();
  TextEditingController wastageDetails = TextEditingController();

  // Transfer-Weight
  TextEditingController transferWeightDelivered = TextEditingController();
  TextEditingController transferWeightReceived = TextEditingController();
  TextEditingController transferWeightCops = TextEditingController();
  TextEditingController transferWeightReel = TextEditingController();
  Rxn<TwisterWarpingLotModel> transferWeightTo = Rxn<TwisterWarpingLotModel>();

  // Orer-Warp
  Rxn<WarpDesignSheetModel> orderWarpWarpingDesign =
      Rxn<WarpDesignSheetModel>();
  TextEditingController orderWarpFromNotification = TextEditingController();
  TextEditingController orderWarpNo = TextEditingController();
  TextEditingController orderWarpNoStatus = TextEditingController();
  TextEditingController orderWarpWeaverLoom = TextEditingController();
  TextEditingController orderWarpWeaverLoomStatus = TextEditingController();
  TextEditingController orderWarpProductName = TextEditingController();
  TextEditingController orderWarpWarpType = TextEditingController();
  TextEditingController orderWarpYards = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final openingBalanceFormKey = GlobalKey<FormState>();
  final deliveryFormKey = GlobalKey<FormState>();
  final yarnInwardFormKey = GlobalKey<FormState>();
  final warpInwardFormKey = GlobalKey<FormState>();
  final orderWarpFormKey = GlobalKey<FormState>();
  final wastageFormKey = GlobalKey<FormState>();
  final transferWeightFormKey = GlobalKey<FormState>();

  final RxString _selectedEntryType =
      RxString(Constants.TWISTING_ENTRY_TYPES[0]);

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwistingOrWarpingController>(builder: (controller) {
      this.controller = controller;
      return Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width * 0.90,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add Item(Twisting Or Warping)',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Wrap(
                    children: [
                      MyDateField(
                        controller: date,
                        hintText: 'Date',
                        validate: 'string',
                        readonly: true,
                      ),
                      MyDropdownButtonFormField(
                        controller: transactionTypeController,
                        hintText: "Transaction Type",
                        items: Constants.TRANSACTIONTYPE,
                      ),
                      MyDropdownButtonFormField(
                        hintText: "Entry Type",
                        items: Constants.TWISTING_ENTRY_TYPES,
                        controller: entryTypeController,
                        onChanged: (value) {
                          _selectedEntryType.value = value;
                        },
                      ),
                      Obx(() => widgetByEntryType(_selectedEntryType.value))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 200,
                      child: MyElevatedButton(
                        color: Colors.red,
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: MyElevatedButton(
                        onPressed: () => submit(),
                        child: Text(Get.arguments == null ? 'Add' : 'Update'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget widgetByEntryType(String option) {
    if (option == 'Opening Balance') {
      return Form(
        key: openingBalanceFormKey,
        child: Wrap(
          children: [
            MyTextField(
              controller: openingBalanceDeliveredweight,
              hintText: 'Delivered Weight',
              validate: 'number',
              suffix:
                  const Text('Kg', style: TextStyle(color: Color(0xFF5700BC))),
            ),
            MyTextField(
              controller: openingBalanceReceivedwight,
              hintText: 'Received Weight',
              validate: 'number',
              suffix:
                  const Text('Kg', style: TextStyle(color: Color(0xFF5700BC))),
            ),
            MyTextField(
              controller: openingBalanceCops,
              hintText: 'Cops',
              validate: 'number',
            ),
            MyTextField(
              controller: openingBalanceReel,
              hintText: 'Reel',
              validate: 'number',
            ),
            MyTextField(
              controller: openingBalanceDetails,
              hintText: 'Details',
              validate: 'String',
            ),
          ],
        ),
      );
    } else if (option == 'Delivery') {
      return Form(
        key: deliveryFormKey,
        child: Wrap(
          children: [
            Row(
              children: [
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(8),
                  child: Obx(() =>
                      DropdownButtonFormField(
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF141414),
                            fontFamily: 'Poppins'),
                      value: deliveryYarnname.value,
                      items: controller.Yarn.map((YarnModel item) {
                        return DropdownMenuItem<YarnModel>(
                          value: item,
                          child: Text('${item.name}'),
                        );
                      }).toList(),
                      onChanged: (YarnModel? value) {
                        deliveryYarnname.value = value;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(),
                        // hintText: 'Select'
                        labelText: 'Yarn Name',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF939393),
                            width: 0.4,
                          ),
                        ),
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
                MyCreateNew(
                  onPressed: () async {
                    deliveryYarnname.value = null;
                    var item = await Get.toNamed(AddYarn.routeName);
                    controller.onInit();
                  },
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(8),
                  child: Obx(() =>
                     DropdownButtonFormField(
                       style: TextStyle(
                           fontSize: 14,
                           color: Color(0xFF141414),
                           fontFamily: 'Poppins'),
                      value: deliveryColorname.value,
                      items: controller.Color.map((NewColorModel item) {
                        return DropdownMenuItem<NewColorModel>(
                          value: item,
                          child: Text('${item.name}'),
                        );
                      }).toList(),
                      onChanged: (NewColorModel? value) {
                        deliveryColorname.value = value;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(),
                        // hintText: 'Select',
                        labelText: 'Color Name',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF939393),
                            width: 0.4,
                          ),
                        ),
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
                MyCreateNew(
                  onPressed: () async {
                    deliveryColorname.value=null;
                    var item = await Get.toNamed(AddNewColor.routeName);
                    controller.onInit();
                  },
                ),
              ],
            ),
            MyDropdownButtonFormField(
              controller: deliveryDeliveryfrom,
              hintText: "Delivery From",
              items: Constants.deliveredFrom,
            ),
            MyTextField(
              controller: deliveryBoxno,
              hintText: 'Box / Box No',
              validate: 'string',
            ),
            MyTextField(
              controller: deliveryStock,
              hintText: 'Stock',
              validate: 'number',
            ),
            MyDropdownButtonFormField(
              controller: deliveryHolder,
              hintText: "Holder",
              items: Constants.Holder,
            ),
            MyTextField(
              controller: deliveryQuantity,
              hintText: 'Quantity',
              validate: 'number',
            ),
          ],
        ),
      );
    } else if (option == 'Yarn Inward') {
      return Form(
        key: yarnInwardFormKey,
        child: Wrap(
          children: [
            Row(
              children: [
                Container(
                  width: 240,
                  padding: EdgeInsets.all(8),
                  child: Obx(() =>
                     DropdownButtonFormField(
                       style: TextStyle(
                           fontSize: 14,
                           color: Color(0xFF141414),
                           fontFamily: 'Poppins'),
                      value: yarnInwardYarnName.value,
                      items: controller.Yarn.map((YarnModel item) {
                        return DropdownMenuItem<YarnModel>(
                          value: item,
                          child: Text(
                            '${item.name}',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        );
                      }).toList(),
                      onChanged: (YarnModel? value) {
                        yarnInwardYarnName.value = value;
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          border: OutlineInputBorder(),
                          // hintText: 'Select',
                          labelText: 'Yarn Name',
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
                ),
                const SizedBox(
                  width: 11,
                ),
                MyCreateNew(
                  onPressed: () async {
                    yarnInwardYarnName.value=null;
                    var item = await Get.toNamed(AddYarn.routeName);
                    controller.onInit();
                  },
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 240,
                  padding: EdgeInsets.all(8),
                  child: Obx(()=>
                   DropdownButtonFormField(
                     style: TextStyle(
                         fontSize: 14,
                         color: Color(0xFF141414),
                         fontFamily: 'Poppins'),
                      value: yarnInwardColorName.value,
                      items: controller.Color.map((NewColorModel item) {
                        return DropdownMenuItem<NewColorModel>(
                          value: item,
                          child: Text(
                            '${item.name}',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        );
                      }).toList(),
                      onChanged: (NewColorModel? value) {
                        yarnInwardColorName.value = value;
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          border: OutlineInputBorder(),
                          // hintText: 'Select',
                          labelText: 'Color Name',
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
                ),
                const SizedBox(
                  width: 11,
                ),
                MyCreateNew(
                  onPressed: () async {
                    yarnInwardColorName.value=null;
                    var item = await Get.toNamed(AddNewColor.routeName);
                    controller.onInit();
                  },
                ),
              ],
            ),
            MyDropdownButtonFormField(
              controller: yarnInwardStockto,
              hintText: "Stock to",
              items: Constants.stockTo,
            ),
            MyTextField(
              controller: yarnInwardBoxNo,
              hintText: 'Box No',
              validate: 'String',
            ),
            MyDropdownButtonFormField(
              controller: yarnInwardHolder,
              hintText: "Holder",
              items: Constants.Holder,
            ),
            MyTextField(
              controller: yarnInwardEmpty,
              hintText: '',
              validate: 'number',
            ),
            MyTextField(
              controller: yarnInwardQuantitys,
              hintText: 'Quantity',
              validate: 'number',
              suffix:
                  const Text('Kg', style: TextStyle(color: Color(0xFF5700BC))),
            ),
            MyTextField(
              controller: yarnInwardWages,
              hintText: 'Wages(Rs)/Kg',
              validate: 'double',
            ),
            MyTextField(
              controller: yarnInwardAmount,
              hintText: 'Amount(Rs)',
              validate: 'double',
            ),
          ],
        ),
      );
    } else if (option == 'Warp Inward') {
      return Form(
        key: warpInwardFormKey,
        child: Wrap(
          children: [
            Row(
              children: [
                Container(
                  width: 240,
                  padding: EdgeInsets.all(8),
                  child: Obx(()=>
                     DropdownButtonFormField(
                       style: TextStyle(
                           fontSize: 14,
                           color: Color(0xFF141414),
                           fontFamily: 'Poppins'),
                      value: warpInwardWarpDesign.value,
                      items: controller.WarpdesignSheet.map(
                          (WarpDesignSheetModel item) {
                        return DropdownMenuItem<WarpDesignSheetModel>(
                          value: item,
                          child: Text(
                            '${item.designName}',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        );
                      }).toList(),
                      onChanged: (WarpDesignSheetModel? value) {
                        warpInwardWarpDesign.value = value;
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
                ),
                const SizedBox(
                  width: 11,
                ),
                MyCreateNew(
                  onPressed: () async {
                    warpInwardWarpDesign.value=null;
                    var item = await Get.toNamed(AddWarpDesignSheet.routeName);
                    controller.onInit();
                  },
                ),
              ],
            ),
            MyTextField(
              controller: warpInwardWarptype,
              hintText: 'Warp Type',
              validate: 'string',
            ),
            MyTextField(
              controller: warpInwardWarpid,
              hintText: 'Warp ID',
              validate: 'string',
            ),
            MyTextField(
              controller: warpInwardYards,
              hintText: 'Yards',
              validate: 'number',
            ),
            MyTextField(
              controller: warpInwardQuantity,
              hintText: 'Quantity',
              validate: 'number',
              suffix:
                  const Text('Kg', style: TextStyle(color: Color(0xFF5700BC))),
            ),
            MyTextField(
              controller: warpInwardWages,
              hintText: 'Wages(Rs)/Kg',
              validate: 'double',
            ),
            MyTextField(
              controller: warpInwardAmount,
              hintText: 'Amount(Rs)',
              validate: 'double',
            ),
            MyDropdownButtonFormField(
              controller: warpInwardFromOrder,
              hintText: "From Order?",
              items: Constants.FromOrder,
            ),
            MyDropdownButtonFormField(
              controller: warpInwardOrderSno,
              hintText: "Order S.No",
              items: Constants.OrderSNo,
            ),
          ],
        ),
      );
    } else if (option == 'Wastage') {
      return Form(
        key: wastageFormKey,
        child: Wrap(
          children: [
            MyTextField(
              controller: wastageWastageweight,
              hintText: 'Wastage Weight',
              validate: 'double',
              suffix:
                  const Text('Kg', style: TextStyle(color: Color(0xFF5700BC))),
            ),
            MyTextField(
              controller: wastageRaters,
              hintText: 'Rate(Rs)/Kg',
              validate: 'double',
            ),
            MyTextField(
              controller: wastageDeducation,
              hintText: 'Deduction Amount (Rs)',
              validate: 'double',
            ),
            MyTextField(
              controller: wastageDetails,
              hintText: 'Details',
              validate: 'string',
            ),
          ],
        ),
      );
    } else if (option == 'Transfer-Weight') {
      return Form(
        key: transferWeightFormKey,
        child: Wrap(
          children: [
            MyTextField(
              controller: transferWeightDelivered,
              hintText: 'Delivered Weight',
              validate: 'double',
              suffix:
                  const Text('Kg', style: TextStyle(color: Color(0xFF5700BC))),
            ),
            MyTextField(
              controller: transferWeightReceived,
              hintText: 'Received Weight',
              validate: 'double',
              suffix:
                  const Text('Kg', style: TextStyle(color: Color(0xFF5700BC))),
            ),
            MyTextField(
              controller: transferWeightCops,
              hintText: 'Cops',
              validate: 'number',
            ),
            MyTextField(
              controller: transferWeightReel,
              hintText: 'Reel',
              validate: 'number',
            ),
            Container(
              width: 240,
              padding: const EdgeInsets.all(8),
              child: DropdownButtonFormField(
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF141414),
                    fontFamily: 'Poppins'),
                value: transferWeightTo.value,
                items: controller.lot.map((TwisterWarpingLotModel item) {
                  return DropdownMenuItem<TwisterWarpingLotModel>(
                    value: item,
                    child: Text(
                      '${item.lot}',
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  );
                }).toList(),
                onChanged: (TwisterWarpingLotModel? value) {
                  transferWeightTo.value = value;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(),
                    // hintText: 'Select',
                    labelText: 'Lot',
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
      );
    } else if (option == 'Order-Warp') {
      return Form(
        key: orderWarpFormKey,
        child: Wrap(
          children: [
            MyDropdownButtonFormField(
              controller: orderWarpFromNotification,
              hintText: "FromNotification",
              items: Constants.FromNotification,
            ),
            MyTextField(
              controller: orderWarpNo,
              hintText: 'No',
              validate: 'number',
            ),
            MyTextField(
              controller: orderWarpNoStatus,
              hintText: ' ',
              validate: 'String',
            ),
            MyTextField(
              controller: orderWarpWeaverLoom,
              hintText: 'Weaver Loom',
              validate: 'String',
            ),
            MyTextField(
              controller: orderWarpWeaverLoomStatus,
              hintText: ' ',
              validate: 'String',
            ),
            MyTextField(
              controller: orderWarpProductName,
              hintText: 'Product Name',
              validate: 'String',
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 240,
                  padding: EdgeInsets.all(8),
                  child: DropdownButtonFormField(
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF141414),
                        fontFamily: 'Poppins'),
                    value: orderWarpWarpingDesign.value,
                    items: controller.WarpdesignSheet.map(
                        (WarpDesignSheetModel item) {
                      return DropdownMenuItem<WarpDesignSheetModel>(
                        value: item,
                        child: Text(
                          '${item.designName}',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      );
                    }).toList(),
                    onChanged: (WarpDesignSheetModel? value) {
                      orderWarpWarpingDesign.value = value;
                    },
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
              controller: orderWarpWarpType,
              hintText: 'Warp Type',
              validate: 'string',
            ),
            MyTextField(
              controller: orderWarpYards,
              hintText: 'Yards',
              validate: 'number',
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  submit() {
    var entryType = _selectedEntryType.value.toString();

    if (entryType == "Opening Balance") {
      if (_formKey.currentState!.validate()) {
        if (openingBalanceFormKey.currentState!.validate()) {
          Map<String, dynamic> request = {
            "date": date.text,
            "entry_type": entryType,
            "transaction_type": transactionTypeController.text,
            "opening_balance_De_weight": openingBalanceDeliveredweight.text,
            "opening_balance_Re_weight": openingBalanceReceivedwight.text,
            "opening_balance_cops": openingBalanceCops.text,
            "opening_balance_reel": openingBalanceReel.text,
            "opening_balance_details": openingBalanceDetails.text,
          };
          Get.back(result: request);
        }
      }
    } else if (entryType == "Delivery") {
      if (_formKey.currentState!.validate()) {
        if (deliveryFormKey.currentState!.validate()) {
          Map<String, dynamic> request = {
            "date": date.text,
            "entry_type": entryType,
            "transaction_type": transactionTypeController.text,
            "delivery_yarn_name": deliveryYarnname.value?.name,
            "delivery_color_Name": deliveryColorname.value?.name,
            "delivery_delivery_from": deliveryDeliveryfrom.text,
            "delivery_boxNo": deliveryBoxno.text,
            "delivery_stock": deliveryStock.text,
            "delivery_holder": deliveryHolder.text,
            "delivery_quantity": deliveryQuantity.text,
          };
          Get.back(result: request);
        }
      }
    } else if (entryType == "Yarn Inward") {
      if (_formKey.currentState!.validate()) {
        print("${yarnInwardFormKey.currentState}");
        if (yarnInwardFormKey.currentState!.validate()) {
          Map<String, dynamic> request = {
            "date": date.text,
            "entry_type": entryType,
            "transaction_type": transactionTypeController.text,
            "yarnInward_yarn_name": yarnInwardYarnName.value?.name,
            "yarnInward_color_name": yarnInwardColorName.value?.name,
            "yarnInward_stockTo": yarnInwardStockto.text,
            "yarnInward_boxNo": yarnInwardBoxNo.text,
            "yarnInward_holder": yarnInwardHolder.text,
            "yarnInward_empty": yarnInwardEmpty.text,
            "yarnInward_quantity": yarnInwardQuantitys.text,
            "yarnInward_wages": yarnInwardWages.text,
            "yarnInward_amount": yarnInwardAmount.text,
          };
          Get.back(result: request);
        }
      }
    } else if (entryType == "Warp Inward") {
      if (_formKey.currentState!.validate()) {
        print("${warpInwardFormKey.currentState}");
        if (warpInwardFormKey.currentState!.validate()) {
          Map<String, dynamic> request = {
            "date": date.text,
            "entry_type": entryType,
            "transaction_type": transactionTypeController.text,
            "warpInward_warp_design": warpInwardWarpDesign.value?.designName,
            "warpInward_warp_type": warpInwardWarptype.text,
            "warpInward_warp_IdNo": warpInwardWarpid.text,
            "warpInward_yards": warpInwardYards.text,
            "warpInward_quantity": warpInwardQuantity.text,
            "warpInward_wages": warpInwardWages.text,
            "warpInward_amount": warpInwardAmount.text,
            "warpInward_fromOrder": warpInwardFromOrder.text,
            "warpInward_Order_SNo": warpInwardOrderSno.text,
          };
          Get.back(result: request);
        }
      }
    } else if (entryType == "Order-Warp") {
      if (_formKey.currentState!.validate()) {
        if (orderWarpFormKey.currentState!.validate()) {
          Map<String, dynamic> request = {
            "date": date.text,
            "entry_type": entryType,
            "transaction_type": transactionTypeController.text,
            "orderWarp_from_notification": orderWarpFromNotification.text,
            "orderWarp_no": orderWarpNo.text,
            "orderWarp_no_empty": orderWarpNoStatus.text,
            "orderWarp_weaver_loom": orderWarpWeaverLoom.text,
            "orderWarp_weaver_loom_empty": orderWarpWeaverLoomStatus.text,
            "orderWarp_product_name": orderWarpProductName.text,
            "orderWarp_warp_design": orderWarpWarpingDesign.value?.designName,
            "orderWarp_warp_type": orderWarpWarpType.text,
            "orderWarp_yards": orderWarpYards.text,
          };
          Get.back(result: request);
        }
      }
    } else if (entryType == "Wastage") {
      if (_formKey.currentState!.validate()) {
        if (wastageFormKey.currentState!.validate()) {
          Map<String, dynamic> request = {
            "date": date.text,
            "entry_type": entryType,
            "transaction_type": transactionTypeController.text,
            "wastage_wastage_weight": wastageWastageweight.text,
            "wastage_rate": wastageRaters.text,
            "wastage_deduction_amount": wastageDeducation.text,
            "wastage_details": wastageDetails.text,
          };
          Get.back(result: request);
        }
      }
    } else if (entryType == "Transfer-Weight") {
      if (_formKey.currentState!.validate()) {
        if (transferWeightFormKey.currentState!.validate()) {
          Map<String, dynamic> request = {
            "date": date.text,
            "entry_type": entryType,
            "transaction_type": transactionTypeController.text,
            "transfer_weight_delivered_weight": transferWeightDelivered.text,
            "transfer_weight_received_weight": transferWeightReceived.text,
            "transfer_weight_cops": transferWeightCops.text,
            "transfer_weight_reel": transferWeightReel.text,
            "transfer_weight_to": transferWeightTo.value?.lot,
          };
          Get.back(result: request);
        }
      }
    }
  }

  void _initValue() {
    deliveryHolder.text = Constants.Holder[0];
    yarnInwardHolder.text = Constants.Holder[0];
    deliveryDeliveryfrom.text = Constants.deliveredFrom[0];
    yarnInwardStockto.text = Constants.stockTo[0];
    warpInwardFromOrder.text = Constants.FromOrder[0];
    warpInwardOrderSno.text = Constants.OrderSNo[0];
    orderWarpFromNotification.text = Constants.FromNotification[0];
    entryTypeController.text = Constants.TWISTING_ENTRY_TYPES[0];
    transactionTypeController.text = Constants.TRANSACTIONTYPE[0];
  }
}
