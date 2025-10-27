import 'dart:convert';

import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/TwisterWarpingModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/trasaction/twisting_or_warping/twister_item_bottomsheet.dart';
import 'package:abtxt/view/trasaction/twisting_or_warping/twisting_or_warping_controller.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/TwisterWarpingLotModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/ledger/addledger.dart';
import 'create_lot_bottom.dart';

class add_twisting_warping extends StatefulWidget {
  const add_twisting_warping({Key? key}) : super(key: key);
  static const String routeName = '/addtwisting';

  @override
  State<add_twisting_warping> createState() => _State();
}

class _State extends State<add_twisting_warping> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> warperName = Rxn<LedgerModel>();
  TextEditingController recoredNoController = TextEditingController();
  Rxn<TwisterWarpingLotModel> lotController = Rxn<TwisterWarpingLotModel>();
  TextEditingController wagesAccountController = TextEditingController();
  TextEditingController transactionTypsController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController totalDeliveredWeightController =
      TextEditingController();
  TextEditingController totalReceivedWeightController = TextEditingController();
  TextEditingController totalWagesController = TextEditingController();
  TextEditingController totalCopsOUTController = TextEditingController();
  TextEditingController totalCopsInController = TextEditingController();
  TextEditingController totalReelOUTController = TextEditingController();
  TextEditingController totalReelInController = TextEditingController();
  TextEditingController balanceDeliveredWeightController =
      TextEditingController();
  TextEditingController balanceCopsINController = TextEditingController();
  TextEditingController balanceReelInController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late TwistingOrWarpingController controller;
  var twisterList = <dynamic>[].obs;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TwistingOrWarpingController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
            () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Twisting or Warping"),
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
                        Container(
                          width: 240,
                          padding: const EdgeInsets.all(8),
                          child: Obx(
                            () => DropdownButtonFormField(
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF141414),
                                  fontFamily: 'Poppins'),
                              value: warperName.value,
                              items:
                                  controller.WarperName.map((LedgerModel item) {
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
                                warperName.value = value;
                              },
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                border: OutlineInputBorder(),
                                labelText: 'Warper Name',
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
                            warperName.value = null;
                            var item = await Get.toNamed(AddLedger.routeName);
                            controller.onInit();
                          },
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Container(
                          width: 240,
                          padding: const EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF141414),
                                fontFamily: 'Poppins'),
                            value: lotController.value,
                            items: controller.lot
                                .map((TwisterWarpingLotModel item) {
                              return DropdownMenuItem<TwisterWarpingLotModel>(
                                value: item,
                                child: Text(
                                  '${item.lot}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                              );
                            }).toList(),
                            onChanged: (TwisterWarpingLotModel? value) {
                              lotController.value = value;
                            },
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              border: OutlineInputBorder(),
                              // hintText: 'Select',
                              labelText: 'Lot',
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
                        const SizedBox(
                          width: 11,
                        ),
                        ActionChip(
                          backgroundColor: const Color(0xFFDCFFDB),
                          shape: const StadiumBorder(
                              side: BorderSide(
                                  color: Color(0xFF00DE16), width: 0.4)),
                          label: const Text('Create Lot'),
                          onPressed: () async {
                            var result = await CreateLotDialoge(context);
                            print("result: ${result.toString()}");
                            if (result != null) {
                              twisterList.add(result);
                            }
                          },
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        MyTextField(
                          controller: recoredNoController,
                          hintText: "Record No",
                          validate: "string",
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
                                    fontSize: 14,
                                    color: Color(0xFF141414),
                                    fontFamily: 'Poppins'),
                                value: firmName.value,
                                items: controller.firmDropdown
                                    .map((FirmModel item) {
                                  return DropdownMenuItem<FirmModel>(
                                    value: item,
                                    child: Text('${item.firmName}'),
                                  );
                                }).toList(),
                                onChanged: (FirmModel? value) {
                                  firmName.value = value;
                                },
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                  border: OutlineInputBorder(),
                                  // hintText: 'Select',
                                  labelText: "Firm",
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
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: AddItemsElevatedButton(
                        width: 135,
                        onPressed: () async {
                          var result = await twisterItemDialog(context);
                          print(jsonEncode(result));
                          if (result != null) {
                            twisterList.add(result);
                            initTotal();
                          }
                        },
                        child: const Text('Add Item'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TwisterItems(),
                    const SizedBox(height: 40),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 630)),
                          SizedBox(
                            width: 170,
                            child: CountTextField(
                              controller: totalDeliveredWeightController,
                              hintText: "Total Delivered Weight",
                              readonly: true,
                              suffix: const Text('Kg',
                                  style: TextStyle(color: Color(0xFF5700BC))),
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            child: CountTextField(
                              controller: totalReceivedWeightController,
                              hintText: "Total Received Weight",
                              suffix: const Text('Kg',
                                  style: TextStyle(color: Color(0xFF5700BC))),
                              readonly: true,
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            child: CountTextField(
                              controller: totalWagesController,
                              hintText: "Total Wages",
                              readonly: true,
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            child: CountTextField(
                              controller: totalCopsOUTController,
                              hintText: "Total Cops OUT",
                              readonly: true,
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            child: CountTextField(
                              controller: totalCopsInController,
                              hintText: "Total Cops In",
                              readonly: true,
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            child: CountTextField(
                              controller: totalReelOUTController,
                              hintText: "Total Reel OUT",
                              readonly: true,
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            child: CountTextField(
                              controller: totalReelInController,
                              hintText: "Total Reel In",
                              readonly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 580)),
                          const Text(
                            'Balance',
                            style: TextStyle(
                              color: Color(0xFF5700BC),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            child: CountTextField(
                              controller: balanceDeliveredWeightController,
                              hintText: "Balance Delivered Weight",
                              readonly: true,
                              suffix: const Text('Kg',
                                  style: TextStyle(color: Color(0xFF5700BC))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 200,
                          child: MyElevatedButton(
                            color: Colors.red,
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 200,
                          child: MyElevatedButton(
                            onPressed: () => submit(),
                            child:
                                Text(Get.arguments == null ? 'Save' : 'Update'),
                          ),
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
      Map<String, dynamic> request = {
        "warper_id": warperName.value?.id,
        "warper_name": warperName.value?.ledgerName,
        "lot": lotController.value?.lot,
        "recored_no": recoredNoController.text,
        "firm": firmName.value?.id,
        "total_deliverd_weight": totalDeliveredWeightController.text,
        "total_received_weight": totalReceivedWeightController.text,
        "total_wages": totalWagesController.text,
        "toatl_cops_out": totalCopsOUTController.text,
        "total_cops_in": totalCopsInController.text,
        "total_reel_out": totalReelOUTController.text,
        "total_reel_in": totalReelInController.text,
        "balance_deliverd_weight": balanceDeliveredWeightController.text,
      };
      var warpItemList = [];
      for (var i = 0; i < twisterList.length; i++) {
        /// Opening Balance value send in post Api
        if (twisterList[i]["entry_type"] == "Opening Balance") {
          var item = {
            "date": twisterList[i]['date'],
            "entry_type": twisterList[i]['entry_type'],
            "particulers": twisterList[i]["opening_balance_details"],
            "deliverd_weight": twisterList[i]["opening_balance_De_weight"],
            "received_weight": twisterList[i]["opening_balance_Re_weight"],
            "wages": "",
            "cops_out": twisterList[i]["opening_balance_cops"],
            "cops_in": "",
            "reel_out": twisterList[i]["opening_balance_reel"],
            "reel_in": "",
          };
          warpItemList.add(item);
        }

        /// Delivery value send in post Api
        if (twisterList[i]["entry_type"] == "Delivery") {
          var particulars =
              '${twisterList[i]['delivery_yarn_name']}-${twisterList[i]['delivery_color_Name']} ';

          var item = {
            "date": twisterList[i]['date'],
            "entry_type": twisterList[i]['entry_type'],
            "particulers": particulars,
            "deliverd_weight": twisterList[i]["delivery_quantity"],
            "received_weight": "",
            "wages": "",
            "cops_out": "",
            "cops_in": "",
            "reel_out": "",
            "reel_in": "",
          };

          warpItemList.add(item);
        }

        /// Yarn Inward value send in post Api
        if (twisterList[i]["entry_type"] == "Yarn Inward") {
          var particulars =
              '${twisterList[i]['yarnInward_yarn_name']}-${twisterList[i]['yarnInward_color_name']} ';

          var item = {
            "date": twisterList[i]['date'],
            "entry_type": twisterList[i]['entry_type'],
            "particulers": particulars,
            "deliverd_weight": "",
            "received_weight": twisterList[i]["yarnInward_quantity"],
            "wages": twisterList[i]["yarnInward_amount"],
            "cops_out": "",
            "cops_in": "",
            "reel_out": "",
            "reel_in": "",
          };

          warpItemList.add(item);
        }

        /// Warp Inward value send in post Api
        if (twisterList[i]["entry_type"] == "Warp Inward") {
          var particulars =
              '${twisterList[i]['warpInward_warp_design']},${twisterList[i]['warpInward_yards']},${twisterList[i]['warpInward_warp_IdNo']}';

          var item = {
            "date": twisterList[i]['date'],
            "entry_type": twisterList[i]['entry_type'],
            "particulers": particulars,
            "deliverd_weight": "",
            "received_weight": twisterList[i]["warpInward_quantity"],
            "wages": twisterList[i]["warpInward_amount"],
            "cops_out": "",
            "cops_in": "",
            "reel_out": "",
            "reel_in": "",
          };

          warpItemList.add(item);
        }

        /// Order - Warp value send in post Api
        if (twisterList[i]["entry_type"] == "Order-Warp") {
          var particulars =
              '${twisterList[i]['orderWarp_warp_design']}-${twisterList[i]['orderWarp_yards']} ';

          var item = {
            "date": twisterList[i]['date'],
            "entry_type": twisterList[i]['entry_type'],
            "particulers": particulars,
            "deliverd_weight": "",
            "received_weight": "",
            "wages": "",
            "cops_out": "",
            "cops_in": "",
            "reel_out": "",
            "reel_in": "",
          };

          warpItemList.add(item);
        }

        /// Wastage value send in post Api
        if (twisterList[i]["entry_type"] == "Wastage") {
          var item = {
            "date": twisterList[i]['date'],
            "entry_type": twisterList[i]['entry_type'],
            "particulers": twisterList[i]["wastage_details"],
            "deliverd_weight": "",
            "received_weight": twisterList[i]["wastage_wastage_weight"],
            "wages": twisterList[i]["wastage_deduction_amount"],
            "cops_out": "",
            "cops_in": "",
            "reel_out": "",
            "reel_in": "",
          };

          warpItemList.add(item);
        }

        /// Transfer - Weight value send in post Api
        if (twisterList[i]["entry_type"] == "Transfer-Weight") {
          var item = {
            "date": twisterList[i]['date'],
            "entry_type": twisterList[i]['entry_type'],
            "particulers": twisterList[i]["transfer_weight_to"],
            "deliverd_weight": "",
            "received_weight": twisterList[i]
                ["transfer_weight_delivered_weight"],
            "wages": "",
            "cops_out": "",
            "cops_in": twisterList[i]["transfer_weight_cops"],
            "reel_out": "",
            "reel_in": twisterList[i]["transfer_weight_reel"],
          };

          warpItemList.add(item);
        }
      }

      request['twister_items'] = warpItemList;

      print('twisting request: ${jsonEncode(request)}');
      var id = idController.text;
      if (id.isEmpty) {
        controller.addTwister(request);
      } else {
        request['id'] = id;
        controller.updateTwister(request);
      }
    }
  }

  void _initValue() {
    wagesAccountController.text = Constants.WAGESACCOUNT[0];
    transactionTypsController.text = Constants.TRANSACTIONTYPE[0];

    if (Get.arguments != null) {
      TwistingOrWarpingController controller = Get.find();
      TwisterWarpingModel twisterWarping = Get.arguments['item'];
      idController.text = '${twisterWarping.id}';
      recoredNoController.text = '${twisterWarping.recoredNo}';

      // WarperName
      var warperNameList = controller.WarperName.where(
              (element) => '${element.id}' == '${twisterWarping.warperId}')
          .toList();
      if (warperNameList.isNotEmpty) {
        warperName.value = warperNameList.first;
      }
      // firmName
      var firmNameList = controller.firmDropdown
          .where((element) => '${element.id}' == '${twisterWarping.firm}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmName.value = firmNameList.first;
      }
      // lot
      var lotList = controller.lot
          .where((element) => '${element.lot}' == '${twisterWarping.lot}')
          .toList();
      if (firmNameList.isNotEmpty) {
        lotController.value = lotList.first;
      }

      twisterWarping.itemDetails?.forEach((element) {
        /// Opening Balance value update
        if (element.entryType == "Opening Balance") {
          var particulers = element.particulers;
          var request = {
            "date": "${element.date}",
            "entry_type": "${element.entryType}",
            "opening_balance_details": particulers,
            "opening_balance_De_weight": "${element.deliverdWeight}",
            "opening_balance_Re_weight": "${element.receivedWeight}",
            "opening_balance_cops": "${element.copsOut}",
            "opening_balance_reel": "${element.reelOut}",
          };
          twisterList.add(request);
        }

        /// Delivery value update
        if (element.entryType == "Delivery") {
          var yarnName = element.particulers?.split("-").first;
          var colorName = element.particulers?.split("-").last;
          var request = {
            "date": "${element.date}",
            "entry_type": "${element.entryType}",
            "delivery_yarn_name": yarnName,
            "delivery_color_Name": colorName,
            "delivery_quantity": "${element.deliverdWeight}",
          };
          twisterList.add(request);
        }

        /// Yarn Inward value update
        if (element.entryType == "Yarn Inward") {
          var yarnName = element.particulers?.split("-").first;
          var colorName = element.particulers?.split("-").last;
          var request = {
            "date": "${element.date}",
            "entry_type": "${element.entryType}",
            "yarnInward_yarn_name": yarnName,
            "yarnInward_color_name": colorName,
            "yarnInward_quantity": "${element.receivedWeight}",
            "yarnInward_amount": "${element.wages}",
          };
          twisterList.add(request);
        }

        /// Warp Inward value update
        if (element.entryType == "Warp Inward") {
          var warpDesign = element.particulers?.split(",").first;
          var yards = element.particulers?.split(",")[1];
          var warpIdNo = element.particulers?.split(",").last;

          var request = {
            "date": "${element.date}",
            "entry_type": "${element.entryType}",
            "warpInward_warp_design": warpDesign,
            "warpInward_yards": yards,
            "warpInward_warp_IdNo": warpIdNo,
            "warpInward_quantity": "${element.receivedWeight}",
            "warpInward_amount": "${element.wages}",
          };
          twisterList.add(request);
        }

        /// Order - Warp value update
        if (element.entryType == "Order-Warp") {
          var warpDesign = element.particulers?.split("-").first;
          var yards = element.particulers?.split("-").last;

          var request = {
            "date": "${element.date}",
            "entry_type": "${element.entryType}",
            "orderWarp_warp_design": warpDesign,
            "orderWarp_yards": yards,
          };
          twisterList.add(request);
        }

        /// Wastage value update
        if (element.entryType == "Wastage") {
          var request = {
            "date": "${element.date}",
            "entry_type": "${element.entryType}",
            "wastage_details": "${element.particulers}",
            "wastage_wastage_weight": "${element.receivedWeight}",
            "wastage_deduction_amount": "${element.wages}",
          };
          twisterList.add(request);
        }

        /// Wastage value update
        if (element.entryType == "Transfer-Weight") {
          var request = {
            "date": "${element.date}",
            "entry_type": "${element.entryType}",
            "transfer_weight_to": "${element.particulers}",
            "transfer_weight_delivered_weight": "${element.receivedWeight}",
            "transfer_weight_cops": "${element.copsIn}",
            "transfer_weight_reel": "${element.reelIn}",
          };
          twisterList.add(request);
        }
      });
    }
    initTotal();
  }

  void initTotal() {
    double totalDeliveredWeight = 0.0;
    double totalReceivedWeight = 0.0;
    double totalWages = 0.0;
    int totalCopsOut = 0;
    int totalCopsIn = 0;
    int totalReelOut = 0;
    int totalReelIN = 0;
    double balanceDeliveredWeight = 0.0;

    for (var i = 0; i < twisterList.length; i++) {
      /// Total Delivered Weight Calculation

      if (twisterList[i]["entry_type"] == "Opening Balance") {
        totalDeliveredWeight +=
            double.tryParse(twisterList[i]["opening_balance_De_weight"]) ?? 0.0;
      }
      if (twisterList[i]["entry_type"] == "Delivery") {
        totalDeliveredWeight +=
            double.tryParse(twisterList[i]["delivery_quantity"]) ?? 0.0;
      }

      /// Total Received Weight Calculation

      if (twisterList[i]["entry_type"] == "Opening Balance") {
        totalReceivedWeight +=
            double.tryParse(twisterList[i]["opening_balance_Re_weight"]) ?? 0.0;
      }
      if (twisterList[i]["entry_type"] == "Yarn Inward") {
        totalReceivedWeight +=
            double.tryParse(twisterList[i]["yarnInward_quantity"]) ?? 0.0;
      }
      if (twisterList[i]["entry_type"] == "Warp Inward") {
        totalReceivedWeight +=
            double.tryParse(twisterList[i]["warpInward_quantity"]) ?? 0.0;
      }
      if (twisterList[i]["entry_type"] == "Wastage") {
        totalReceivedWeight +=
            double.tryParse(twisterList[i]["wastage_wastage_weight"]) ?? 0.0;
      }
      if (twisterList[i]["entry_type"] == "Transfer-Weight") {
        totalReceivedWeight += double.tryParse(
                twisterList[i]["transfer_weight_delivered_weight"]) ??
            0.0;
      }

      /// total Wages (Rs) calculation
      if (twisterList[i]["entry_type"] == "Yarn Inward") {
        totalWages +=
            double.tryParse(twisterList[i]["yarnInward_amount"]) ?? 0.0;
      }
      if (twisterList[i]["entry_type"] == "Warp Inward") {
        totalWages +=
            double.tryParse(twisterList[i]["warpInward_amount"]) ?? 0.0;
      }
      if (twisterList[i]["entry_type"] == "Wastage") {
        totalWages -=
            double.tryParse(twisterList[i]["wastage_deduction_amount"]) ?? 0.0;
      }

      /// total Cops out calculation
      if (twisterList[i]["entry_type"] == "Opening Balance") {
        totalCopsOut +=
            int.tryParse(twisterList[i]["opening_balance_cops"]) ?? 0;
      }

      /// total Cops In calculation
      if (twisterList[i]["entry_type"] == "Transfer-Weight") {
        totalCopsIn +=
            int.tryParse(twisterList[i]["transfer_weight_cops"]) ?? 0;
      }

      /// total Reel Out calculation
      if (twisterList[i]["entry_type"] == "Opening Balance") {
        totalReelOut +=
            int.tryParse(twisterList[i]["opening_balance_reel"]) ?? 0;
      }

      /// total Reel In calculation
      if (twisterList[i]["entry_type"] == "Transfer-Weight") {
        totalReelIN +=
            int.tryParse(twisterList[i]["transfer_weight_reel"]) ?? 0;
      }
    }

    /// Balance Delivered Weight calculation
    balanceDeliveredWeight = totalDeliveredWeight - totalReceivedWeight;

    totalDeliveredWeightController.text = '$totalDeliveredWeight';
    totalReceivedWeightController.text = '$totalReceivedWeight';
    totalWagesController.text = '$totalWages';
    totalCopsOUTController.text = '$totalCopsOut';
    totalCopsInController.text = '$totalCopsIn';
    totalReelOUTController.text = '$totalReelOut';
    totalReelInController.text = '$totalReelIN';
    balanceDeliveredWeightController.text = "$balanceDeliveredWeight";
  }

  Widget TwisterItems() {
    final ScrollController scrollView = ScrollController();

    return Obx(() => Container(
          width: Get.width,
          color: const Color(0xFFF4F2FF),
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollView,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollView,
              physics: const BouncingScrollPhysics(),
              child: DataTable(
                onSelectAll: (b) {},
                sortColumnIndex: 0,
                sortAscending: true,
                columns: const <DataColumn>[
                  DataColumn(
                      label: Text(
                    "Date",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Entry Type",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Particulars",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Delivered Weight",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Received Weight",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Wages (Rs)",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Cops OUT",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Cops IN",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Reel OUT",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Reel IN",
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Action",
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
                rows: twisterList.map((user) {
                  var particulars = "";
                  var deliveredWeight = "";
                  var receivedWeight = "";
                  var wages = "";
                  var copsOUT = "";
                  var copsIn = "";
                  var reelOUT = "";
                  var reelIn = "";

                  /// Opening Balance value display
                  if (user['entry_type'] == 'Opening Balance') {
                    particulars = '${user['opening_balance_details']}';
                    deliveredWeight = '${user['opening_balance_De_weight']}';
                    receivedWeight = '${user['opening_balance_Re_weight']}';
                    copsOUT = '${user['opening_balance_cops']}';
                    reelOUT = '${user['opening_balance_reel']}';
                  }

                  /// Delivery value display
                  if (user['entry_type'] == 'Delivery') {
                    particulars =
                        '${user['delivery_yarn_name']} - ${user['delivery_color_Name']}';
                    deliveredWeight = '${user['delivery_quantity']}';
                  }

                  /// Yarn Inward value display
                  if (user['entry_type'] == 'Yarn Inward') {
                    particulars =
                        '${user['yarnInward_yarn_name']} - ${user['yarnInward_color_name']} ';
                    receivedWeight = '${user['yarnInward_quantity']}';
                    wages = '${user['yarnInward_amount']}';
                  }

                  /// Warp Inward value display
                  if (user['entry_type'] == 'Warp Inward') {
                    particulars =
                        '${user['warpInward_warp_design']}, (${user['warpInward_yards']} Yards ) -> ${user['warpInward_warp_IdNo']}';
                    receivedWeight = '${user['warpInward_quantity']}';
                    wages = '${user['warpInward_amount']}';
                  }

                  /// Order Warp value display
                  if (user['entry_type'] == 'Order-Warp') {
                    particulars =
                        '${user['orderWarp_warp_design']}, (${user['orderWarp_yards']} Yards )';
                  }

                  /// Wastage value display
                  if (user['entry_type'] == 'Wastage') {
                    particulars = '${user['wastage_details']}';
                    receivedWeight = '${user['wastage_wastage_weight']}';
                    wages = '-${user['wastage_deduction_amount']}';
                  }

                  /// Transfer Weight value display
                  if (user['entry_type'] == 'Transfer-Weight') {
                    particulars =
                        'Transfer Weight To : ${user['transfer_weight_to']}';
                    receivedWeight =
                        '${user['transfer_weight_delivered_weight']}';
                    copsIn = "${user["transfer_weight_cops"]}";
                    reelIn = "${user["transfer_weight_reel"]}";
                  }

                  return DataRow(
                    cells: [
                      DataCell(Text(
                        '${user['date']}',
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        '${user['entry_type']}',
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        particulars,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        deliveredWeight,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        receivedWeight,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        wages,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        copsOUT,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        copsIn,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        reelOUT,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        reelIn,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(
                        IconButton(
                          iconSize: 24,
                          icon: Image.asset('assets/images/ic_delete1.png',
                              width: 18),
                          onPressed: () {
                            twisterList.remove(user);
                            initTotal();
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ));
  }

  dynamic twisterItemDialog(var context) async {
    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          return const TwisterItemBottomSheet();
        });
    return result;
  }

  dynamic CreateLotDialoge(context) async {
    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          return const TwisterCreateLotBottomSheet();
          //error lin
        });
  }
}
