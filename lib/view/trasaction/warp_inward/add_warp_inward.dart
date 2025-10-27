import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/LoomModel.dart';
import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/model/WarpInwardModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/new_wrap/add_new_warp_list.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward_bottomsheet.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddWarpInward extends StatefulWidget {
  const AddWarpInward({super.key});

  static const String routeName = '/AddWarpInward';

  @override
  State<AddWarpInward> createState() => _State();
}

class _State extends State<AddWarpInward> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<LedgerModel> warperName = Rxn<LedgerModel>();
  TextEditingController warperNameTextController = TextEditingController();
  TextEditingController recordNoController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();
  TextEditingController orderController = TextEditingController(text: "No");
  TextEditingController warpIDController = TextEditingController();
  Rxn<NewWarpModel> newWarp = Rxn<NewWarpModel>();
  TextEditingController warpDesignTextController = TextEditingController();
  TextEditingController warpTypeController = TextEditingController();
  TextEditingController productQtyController = TextEditingController(text: "0");
  TextEditingController meterController = TextEditingController(text: "0.000");
  TextEditingController warpConditionController =
      TextEditingController(text: "UnDyed");
  TextEditingController usedEmptyController =
      TextEditingController(text: "Nothing");
  TextEditingController emptyQtyController = TextEditingController(text: "0");
  TextEditingController sheetController = TextEditingController(text: "0");
  Rxn<LedgerModel> accountType = Rxn<LedgerModel>();
  TextEditingController designWagesController =
      TextEditingController(text: "0.00");
  TextEditingController warpingWagesController =
      TextEditingController(text: "0.00");
  TextEditingController twistingWagesController =
      TextEditingController(text: "0.00");
  TextEditingController totalRsController = TextEditingController(text: "0.00");
  TextEditingController typeController =
      TextEditingController(text: "Warping Only");
  TextEditingController detailsController = TextEditingController();
  TextEditingController warpForController =
      TextEditingController(text: "Weaving");
  Rxn<LedgerModel> weaverNameController = Rxn<LedgerModel>();
  TextEditingController weaverNameTextController = TextEditingController();
  Rxn<LoomModel> loomNoController = Rxn<LoomModel>();
  TextEditingController loomNoTextController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  /// warp tracker id this for backend process
  String? warpTrackerId;

  RxBool warpFor = RxBool(true);

  final RxString _selectedEntryType = RxString(Constants.WI_USEDEMPTY[0]);
  Rxn<WarpInwardDetailsModel> details = Rxn<WarpInwardDetailsModel>();

  WarpInwardController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final FocusNode _warpDesignFocusNode = FocusNode();
  final FocusNode _weaverNameFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _warpTypeFocusNode = FocusNode();
  final FocusNode _weaverFocusNode = FocusNode();
  final FocusNode _loomFocusNode = FocusNode();
  final FocusNode _submitFocusNode = FocusNode();
  final FocusNode _remarkFocusNode = FocusNode();
  var shortCut = RxString("");
  var detailText = "";
  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  RxBool isUpdate = RxBool(false);

  /// this key used to disable the field after the dyer oy roller delivery
  RxBool isDelivered = RxBool(false);

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  @override
  void initState() {
    _warpDesignFocusNode.addListener(() => shortCutKeys());
    controller.loomList.clear();
    controller.detailsColumnData();
    super.initState();
    _initValue();
    dataSource = ItemDataSource(list: itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_dateFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpInwardController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title:
              Text("${idController.text == '' ? 'Add' : 'Update'} Warp Inward"),
          actions: [
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyDeleteIconButton(
                onPressed: (password) {
                  if (isDelivered.value == true) {
                    return AppUtils.infoAlert(
                        message:
                            "This warp is alerter delivered, so you cannot delete");
                  } else {
                    controller.delete(idController.text, password);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Visibility(
              visible: recordNoController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
            Visibility(
              visible: recordNoController.text.isNotEmpty,
              child: TextButton.icon(
                onPressed: () async {
                  int id = int.tryParse(idController.text) ?? 0;
                  var result = await controller.labelPrintPdf(id);
                  if (result!.isNotEmpty) {
                    final Uri url = Uri.parse(result);
                    if (!await launchUrl(url)) {
                      throw Exception('Error : $result');
                    }
                  }
                },
                icon: const Icon(
                  Icons.print,
                  color: Color(0x960D30E3),
                ),
                label: const Text(
                  'LABEL PRINT',
                  style: TextStyle(color: Color(0x960D30E3)),
                ),
              ),
            ),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true):
              NavigateAnotherPageIntent(),
          SingleActivator(LogicalKeyboardKey.f2): DetailsIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            PrintIntent: SetCounterAction(perform: () {
              _print();
            }),
            NavigateAnotherPageIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
            DetailsIntent: SetCounterAction(perform: () {
              _showDetailDialog();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                width: Get.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
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
                          MyAutoComplete(
                            label: 'Firm',
                            items: controller.firmDropdown,
                            selectedItem: firmName.value,
                            onChanged: (FirmModel item) {
                              firmName.value = item;
                              // controller.request['group_name'] = item.id;
                            },
                            autofocus: false,
                          ),
                          MyAutoComplete(
                            label: 'Account Type',
                            selectedItem: accountType.value,
                            items: controller.purchaseAccountDropdown,
                            onChanged: (LedgerModel item) {
                              accountType.value = item;
                            },
                            autofocus: false,
                          ),
                          MySearchField(
                            label: 'Warper Name',
                            enabled: !isDelivered.value,
                            items: controller.ledgerDropdown,
                            textController: warperNameTextController,
                            focusNode: _weaverNameFocusNode,
                            requestFocus: _dateFocusNode,
                            onChanged: (LedgerModel item) async {
                              warperName.value = item;
                              _warpId();
                            },
                          ),
                          Visibility(
                            visible: recordNoController.text.isNotEmpty,
                            child: MyTextField(
                              controller: recordNoController,
                              hintText: "Record No",
                              readonly: true,
                              enabled: false,
                            ),
                          ),
                          MyDateFilter(
                            focusNode: _dateFocusNode,
                            controller: entryDateController,
                            labelText: "Entry Date",
                            required: true,
                            onChanged: (value) async {
                              _warpId();
                            },
                            // readonly: true,
                          ),
                          ExcludeFocusTraversal(
                            child: MyDropdownButtonFormField(
                              controller: orderController,
                              hintText: "Order",
                              items: const ['No'],
                              enabled: !isUpdate.value,
                            ),
                          ),
                          MyTextField(
                            enabled: !isDelivered.value,
                            controller: warpIDController,
                            hintText: "Warp ID",
                            validate: "string",
                          ),
                          MySearchField(
                            label: 'Warp Design',
                            items: controller.newWarpDropDown,
                            enabled: !isUpdate.value,
                            textController: warpDesignTextController,
                            focusNode: _warpDesignFocusNode,
                            requestFocus: _warpTypeFocusNode,
                            onChanged: (NewWarpModel item) async {
                              sheetController.text = "0";
                              usedTypeCheck(item.warpType);
                              warpTypeController.text = '${item.warpType}';
                              productQtyController.text = "0";
                              newWarp.value = item;
                              meterController.text = "0.000";
                              var result = await controller
                                  .warpDesignUsingByWarpInfo(item.id);
                              itemList.clear();
                              for (var element in result) {
                                var request = element.toJson();
                                itemList.add(request);
                              }
                              dataSource.updateDataGridRows();
                              dataSource.updateDataGridSource();
                            },
                          ),
                          MyTextField(
                            focusNode: _warpTypeFocusNode,
                            controller: warpTypeController,
                            hintText: "Warp Type",
                            readonly: true,
                          ),
                          MyTextField(
                            enabled: warpTypeController.text == "Main Warp" &&
                                !isUpdate.value,
                            controller: productQtyController,
                            hintText: "Product Qty",
                            validate: "number",
                          ),
                          Focus(
                              skipTraversal: true,
                              child: MyTextField(
                                controller: meterController,
                                hintText: "Meter",
                                validate: "double",
                                enabled: !isUpdate.value,
                                onChanged: (val) {
                                  double meter =
                                      double.tryParse(meterController.text) ??
                                          0.0;
                                  _calcualteQtyAmount(meter);
                                },
                              ),
                              onFocusChange: (hasFocus) {
                                AppUtils.fractionDigitsText(
                                  meterController,
                                );
                              }),
                          MyDropdownButtonFormField(
                            enabled: !isDelivered.value,
                            controller: warpConditionController,
                            hintText: "Warp Condition",
                            items: Constants.WarpCondition,
                          ),
                          MyDropdownButtonFormField(
                            enabled: !isDelivered.value,
                            controller: usedEmptyController,
                            hintText: "Used Empty",
                            items: const ["Beam", "Bobbin", "Nothing"],
                            onChanged: (value) {
                              _selectedEntryType.value = value;
                              if (value == "Beam") {
                                emptyQtyController.text = "1";
                              } else {
                                emptyQtyController.text = "0";
                              }
                            },
                          ),
                          Obx(() {
                            if (_selectedEntryType.value == 'Beam') {
                              return Wrap(
                                children: [
                                  MyTextField(
                                    enabled: !isDelivered.value,
                                    controller: emptyQtyController,
                                    hintText: "Empty Qty",
                                    validate: "number",
                                  ),
                                  MyTextField(
                                    enabled: warpTypeController.text ==
                                            "Main Warp" &&
                                        !isDelivered.value,
                                    controller: sheetController,
                                    hintText: "Sheet",
                                    validate: "number",
                                  ),
                                ],
                              );
                            } else if (_selectedEntryType.value == 'Bobbin') {
                              return Wrap(
                                children: [
                                  MyTextField(
                                    enabled: !isDelivered.value,
                                    controller: emptyQtyController,
                                    hintText: "Empty Qty",
                                    validate: "number",
                                  ),
                                  MyTextField(
                                    enabled: !isDelivered.value,
                                    controller: sheetController,
                                    hintText: "Sheet",
                                    validate: "number",
                                  ),
                                ],
                              );
                            } else {
                              return Wrap(
                                children: [
                                  Container(
                                    width: 240,
                                  ),
                                  Container(
                                    width: 240,
                                  ),
                                ],
                              );
                            }
                          }),
                          ExcludeFocus(
                            child: MyDropdownButtonFormField(
                              controller: typeController,
                              hintText: "Type",
                              enabled: !isUpdate.value,
                              items: const [
                                "Warping Only",
                                "Cops",
                                "Reel",
                                "Nothing"
                              ],
                            ),
                          ),
                          ExcludeFocusTraversal(
                            child: MyTextField(
                              controller: designWagesController,
                              hintText: "Design Wages (Rs)",
                              validate: "double",
                              onChanged: (val) => calculation(),
                            ),
                          ),
                          ExcludeFocusTraversal(
                            child: MyTextField(
                              controller: warpingWagesController,
                              hintText: "Warping Wages (Rs)",
                              validate: "double",
                              onChanged: (val) => calculation(),
                            ),
                          ),
                          ExcludeFocusTraversal(
                            child: MyTextField(
                              controller: twistingWagesController,
                              hintText: "Twisting Wages (Rs)",
                              validate: "double",
                              onChanged: (val) => calculation(),
                            ),
                          ),
                          ExcludeFocusTraversal(
                            child: MyTextField(
                              controller: totalRsController,
                              hintText: "Total (Rs)",
                              readonly: true,
                            ),
                          ),
                          const Text(
                            'F2',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 8),
                          MyDropdownButtonFormField(
                            controller: warpForController,
                            hintText: "Warp For",
                            items: const ["Weaving", "Sale"],
                            onChanged: (value) {
                              warpFor.value = value == "Weaving" ? true : false;
                            },
                          ),
                          Obx(
                            () => Visibility(
                              visible: warpFor.value == true,
                              child: MySearchField(
                                setInitialValue: warpFor.value,
                                label: "Weaver Name",
                                items: controller.weaverDropdown,
                                textController: weaverNameTextController,
                                focusNode: _weaverFocusNode,
                                requestFocus: _loomFocusNode,
                                onChanged: (LedgerModel item) {
                                  controller.loomInfo(item.id);
                                  weaverNameController.value = item;
                                  loomNoTextController.text = "";
                                  loomNoController.value = null;
                                  detailsValue();
                                },
                              ),
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: warpFor.value == true,
                              child: MySearchField(
                                label: "Loom No",
                                setInitialValue: warpFor.value,
                                items: controller.loomList,
                                textController: loomNoTextController,
                                focusNode: _loomFocusNode,
                                requestFocus: _remarkFocusNode,
                                onChanged: (LoomModel item) {
                                  loomNoController.value = item;
                                  detailsValue();
                                },
                              ),
                            ),
                          ),
                          MyTextField(
                            focusNode: _remarkFocusNode,
                            controller: remarkController,
                            hintText: "Remark",
                            onChanged: (value) => detailsValue(),
                          ),
                          ExcludeFocusTraversal(
                            child: MyTextField(
                              readonly: true,
                              controller: detailsController,
                              hintText: "Details",
                            ),
                          ),
                        ],
                      ),
                      itemsTable(),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          crateAndUpdatedBy(),
                          const Spacer(),
                          Obx(
                            () => Text(shortCut.value,
                                style: AppUtils.shortCutTextStyle()),
                          ),
                          const SizedBox(width: 12),
                          MySubmitButton(
                            focusNode: _submitFocusNode,
                            onPressed:
                                controller.status.isLoading ? null : submit,
                          ),
                        ],
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

  shortCutKeys() {
    if (_warpDesignFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Warp Design',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  navigateAnotherPage() async {
    if (_warpDesignFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddNewWarp.routeName);

      if (result == "success") {
        controller.newWarpInfo();
      }
    }
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }
    var request = {'id': idController.text};
    String? response = await controller.warpInwardPdf(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      if (warperName.value == null) {
        return AppUtils.infoAlert(message: "Select the warper name");
      }
      if (newWarp.value == null) {
        return AppUtils.infoAlert(message: "Select the warp design");
      }

      double meter = double.tryParse(meterController.text) ?? 0.0;
      int emptyQty = int.tryParse(emptyQtyController.text) ?? 0;
      int productQty = int.tryParse(productQtyController.text) ?? 0;

      if (warpTypeController.text == "Main Warp") {
        if (productQty == 0) {
          return AppUtils.infoAlert(message: "Enter the product qty");
        }
        if (usedEmptyController.text != "Nothing" && emptyQty == 0) {
          return AppUtils.infoAlert(message: "Enter the empty qty");
        }
      } else {
        if (usedEmptyController.text != "Nothing" && emptyQty == 0) {
          return AppUtils.infoAlert(message: "Enter the empty qty");
        }
      }

      if (meter == 0.0) {
        return AppUtils.infoAlert(message: "Inward meter is 0");
      }

      if (warpForController.text == "Weaving") {
        if (weaverNameController.value == null) {
          return AppUtils.infoAlert(message: "Select the Weaver Name");
        }
        if (loomNoController.value == null) {
          return AppUtils.infoAlert(message: "Select the Loom No");
        }
      }

      Map<String, dynamic> request = {
        "firm_id": firmName.value?.id,
        "warper_id": warperName.value?.id,
        "e_date": entryDateController.text,
        "order_yn": orderController.text,
        "warp_id": warpIDController.text,
        "warp_design_id": newWarp.value?.id,
        "product_qty": productQty,
        "metre": meter,
        "warp_condition": warpConditionController.text,
        "empty_type": usedEmptyController.text,
        "empty_qty": emptyQty,
        "sheet": int.tryParse(sheetController.text) ?? 0,
        "design_charges": double.tryParse(designWagesController.text) ?? 0.0,
        "warping_wages": double.tryParse(warpingWagesController.text) ?? 0.0,
        "wages_ano": accountType.value?.id,
        "total_wages": double.tryParse(totalRsController.text) ?? 0.0,
        "twisting_wages": double.tryParse(twistingWagesController.text) ?? 0.0,
        "typ": typeController.text,
        "details": detailsController.text,
        "warp_for": warpForController.text,
      };

      if (warpForController.text == "Weaving") {
        request["weaver_id"] = weaverNameController.value?.id;
        request["sub_weaver_no"] = loomNoController.value?.id;
      } else {
        request["weaver_id"] = 0;
        request["sub_weaver_no"] = 0;
      }

      var warpItemList = [];
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "yarn_id": itemList[i]['yarn_id'],
          "color_id": itemList[i]['color_id'],
          "ends": itemList[i]['ends'],
          "qty": itemList[i]['qty'],
          "calc_typ": itemList[i]['calc_typ'],
          "wages": itemList[i]['wages'],
          "amount": itemList[i]['amount'],
        };

        warpItemList.add(item);
      }
      request['warp_item'] = warpItemList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.warperName = warperName.value!.ledgerName ?? "";
        controller.warpDesign = newWarp.value!.warpName ?? "";

        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        request["warp_tracker_id"] = warpTrackerId;
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    entryDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    accountType.value = AppUtils.findLedgerAccountByName(
        controller.purchaseAccountDropdown, 'Warping Wages');
    firmName.value = AppUtils.setDefaultFirmName(controller.firmDropdown);
    controller.request = <String, dynamic>{};

    if (controller.warpDesign.isNotEmpty) {
      warpDesignTextController.text = controller.warpDesign;
    }
    if (controller.warperName.isNotEmpty) {
      warperNameTextController.text = controller.warperName;
    }

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = WarpInwardModel.fromJson(Get.arguments['item']);
      if (item.warpDelivery == 1) {
        isDelivered.value = true;
      }

      warpTrackerId = item.warpTrackerId;
      idController.text = '${item.id}';
      recordNoController.text = '${item.id}';
      entryDateController.text = '${item.eDate}';
      orderController.text = '${item.orderYn}';
      warpIDController.text = '${item.warpId}';
      productQtyController.text = '${item.productQty}';
      meterController.text = '${item.metre}';
      warpConditionController.text = '${item.warpCondition}';
      typeController.text = '${item.typ}';
      usedEmptyController.text = '${item.emptyType}';
      emptyQtyController.text = '${item.emptyQty}';
      sheetController.text = '${item.sheet}';
      designWagesController.text = tryCast(item.designCharges);
      twistingWagesController.text = tryCast(item.twistingWages);
      warpingWagesController.text = tryCast(item.warpingWages);
      detailsController.text = tryCast(item.details);
      detailText = tryCast(item.details);

      var firmList = controller.firmDropdown
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmList.isNotEmpty) {
        firmName.value = firmList.first;
      }
      var warperNameList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${item.warperId}')
          .toList();
      if (warperNameList.isNotEmpty) {
        warperName.value = warperNameList.first;
        warperNameTextController.text = warperNameList.first.ledgerName!;
      }
      var warpDesignList = controller.newWarpDropDown
          .where((element) => '${element.id}' == '${item.warpDesignId}')
          .toList();
      if (warpDesignList.isNotEmpty) {
        newWarp.value = warpDesignList.first;
        warpDesignTextController.text = warpDesignList.first.warpName!;
        warpTypeController.text = '${warpDesignList.first.warpType}';
      }

      var accountTypeList = controller.purchaseAccountDropdown
          .where((element) => '${item.wagesAno}' == '${element.id}')
          .toList();
      if (accountTypeList.isNotEmpty) {
        accountType.value = accountTypeList.first;
      }

      warpForController.text = item.warpFor ?? "Weaving";
      warpFor.value = item.warpFor == "Weaving" ? true : false;
      if (warpForController.text == "Weaving") {
        weaverNameController.value =
            LedgerModel(id: item.weaverId ?? 0, ledgerName: item.weaverName);
        weaverNameTextController.text = "${item.weaverName}";

        loomNoController.value =
            LoomModel(id: item.subWeaverNo, subWeaverNo: item.loomNo);
        loomNoTextController.text = "${item.loomNo}";
      }

      // loom details API call
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (item.weaverId != null && item.weaverId != 0) {
          controller.loomInfo(item.weaverId);
        }
      });

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(item.createdAt ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item.updatedAt ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = item.creatorName;
      updatedBy = item.updatedName;
      if (updatedBy != null) {
        displayName = "Edit : $updatedBy";
        displayDate = updatedAt;
      } else {
        displayName = "New : $createdBy";
        displayDate = createdAt;
      }

      item.itemDetails?.forEach((element) {
        var request = element.toJson();
        itemList.add(request);
      });
    }
    calculation();
  }

  void calculation() {
    double designWages = double.tryParse(designWagesController.text) ?? 0.00;
    double warpWages = double.tryParse(warpingWagesController.text) ?? 0.00;
    double twistingWages =
        double.tryParse(twistingWagesController.text) ?? 0.00;
    double total = designWages + warpWages + twistingWages;
    totalRsController.text = total.toStringAsFixed(2);
  }

  Widget itemsTable() {
    return ExcludeFocusTraversal(
      child: MySFDataGridItemTable(
        selectionMode: SelectionMode.single,
        columns: [
          GridColumn(
            columnName: 'yarn_name',
            label: const MyDataGridHeader(title: 'Yarn Name'),
          ),
          GridColumn(
            columnName: 'color_name',
            label: const MyDataGridHeader(title: 'Color Name'),
          ),
          GridColumn(
            width: 120,
            columnName: 'ends',
            label: const MyDataGridHeader(title: 'No.of Ends'),
          ),
          GridColumn(
            width: 120,
            columnName: 'qty',
            label: const MyDataGridHeader(title: 'Quantity'),
          ),
          GridColumn(
            columnName: 'calc_typ',
            label: const MyDataGridHeader(title: 'Calculate Type'),
          ),
          GridColumn(
            width: 120,
            columnName: 'wages',
            label: const MyDataGridHeader(title: 'Wages (Rs)'),
          ),
          GridColumn(
            width: 120,
            columnName: 'amount',
            label: const MyDataGridHeader(title: 'Amount (Rs)'),
          ),
        ],
        tableSummaryRows: [
          GridTableSummaryRow(
            showSummaryInRow: false,
            title: 'Total: ',
            titleColumnSpan: 1,
            columns: [
              const GridSummaryColumn(
                name: 'ends',
                columnName: 'ends',
                summaryType: GridSummaryType.sum,
              ),
              const GridSummaryColumn(
                name: 'qty',
                columnName: 'qty',
                summaryType: GridSummaryType.sum,
              ),
              const GridSummaryColumn(
                name: 'amount',
                columnName: 'amount',
                summaryType: GridSummaryType.sum,
              ),
            ],
            position: GridTableSummaryRowPosition.bottom,
          ),
        ],
        source: dataSource,
        onRowSelected: (index) async {
          var item = itemList[index];
          var result = await Get.to(const WarpInwardBottomSheet(),
              arguments: {'item': item});
          if (result != null) {
            itemList[index] = result;
            dataSource.updateDataGridRows();
            dataSource.updateDataGridSource();
          }
        },
      ),
    );
  }

  void _calcualteQtyAmount(double meter) {
    for (var i = 0; i < itemList.length; i++) {
      var e = itemList[i];
      num singleYarnWeight = e["sycons"] ?? 0;
      int noOfEnded = e["ends"] ?? 0;
      num defaultLengthy = e["dft_length"] ?? 0;
      num wages = e["wages"] ?? 0;
      var calculationType = e["calc_typ"];

      /// qty
      double quantity =
          ((meter * singleYarnWeight) / defaultLengthy) * noOfEnded;

      /// Amount
      double amount = 0.0;
      if (calculationType == "Yarn Usage") {
        amount = wages * quantity;
      } else if (calculationType == "Ends") {
        amount = wages * meter;
      }
      e['qty'] = quantity;
      e['amount'] = amount;
      itemList[i] = e;
    }
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();

    double warpAmount = 0.0;
    for (var e in itemList) {
      warpAmount += e["amount"];
    }
    warpingWagesController.text = warpAmount.roundToDouble().toStringAsFixed(2);

    calculation();
  }

  void _warpId() async {
    warpIDController.clear();
    var id = warperName.value?.id;
    var eDate = entryDateController.text;

    if (id == null || eDate.isEmpty) {
      return;
    }

    var warpId = await controller.warpIDDetails(id, eDate);
    warpIDController.text = warpId != null ? "${warpId.newWarpId}" : '';
  }

  void usedTypeCheck(String? warpType) {
    if (warpType == "Main Warp") {
      setState(() {
        usedEmptyController.text = "Nothing";
        emptyQtyController.text = "0";
        warpConditionController.text = "UnDyed";
      });
    } else {
      setState(() {
        usedEmptyController.text = "Bobbin";
        emptyQtyController.text = "0";
        warpConditionController.text = "Dyed";
      });
    }
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

  void detailsTextData() {
    var comma = detailText.isNotEmpty ? "," : "";
    var text = details.value?.toString().isEmpty ?? true
        ? detailsController.text
        : details.value.toString();
    detailsController.text = text;
    Get.back();
  }

  Widget crateAndUpdatedBy() {
    String id = idController.text;
    String formattedDate = AppUtils.dateFormatter.format(DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${id.isEmpty ? "New : ${AppUtils().loginName}" : displayName}",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          "${id.isEmpty ? formattedDate : displayDate}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
  }

  detailsValue() {
    String weaverName = weaverNameController.value?.ledgerName ?? "";
    String loomNo = loomNoController.value?.subWeaverNo ?? "";
    String remark =
        remarkController.text.isNotEmpty ? remarkController.text : "";

    String details =
        "${weaverName.isNotEmpty ? "$weaverName, " : ""}${loomNo.isNotEmpty ? "$loomNo, " : ""}$remark";

    detailsController.text = details;
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<dynamic>(columnName: 'ends', value: e['ends']),
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
        DataGridCell<dynamic>(columnName: 'calc_typ', value: e['calc_typ']),
        DataGridCell<dynamic>(columnName: 'wages', value: e['wages']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
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
        case 'ends':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'qty':
          return buildFormattedCell(value, decimalPlaces: 3);
        case 'wages':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'amount':
          return buildFormattedCell(value, decimalPlaces: 2);
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
        alignment: Alignment.centerRight,
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
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    final columnName = summaryColumn?.columnName;
    double parsedValue = double.tryParse(summaryValue) ?? 0;
    TextAlign alignment;

    switch (columnName) {
      case 'ends':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);
      default:
        /*  alignment = TextAlign.left;
        return const Text('Total: ',  style: TextStyle(fontWeight: FontWeight.w700),);*/
        return null;
    }
  }

  Widget _buildFormattedCell(double value,
      {int decimalPlaces = 0, required TextAlign alignment}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      decimalDigits: decimalPlaces,
      name: '',
    );
    return Container(
      padding: const EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      child: Text(
        formatter.format(value),
        style: AppUtils.footerTextStyle(),
        textAlign: alignment,
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
