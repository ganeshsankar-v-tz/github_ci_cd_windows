import 'package:abtxt/model/LoomGroup.dart';
import 'package:abtxt/model/NewWarpModel.dart';
import 'package:abtxt/model/weaving_models/WeaverCurrentProductModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/widgets/my_autocompletes/loom_autocomplete.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/weaving_models/WeaverByLoomStatusModel.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../weaving/add_weaving.dart';
import 'empty_in_out_controller.dart';

class EmptyInOutBottomSheet extends StatefulWidget {
  const EmptyInOutBottomSheet({super.key});

  static const String routeName = '/empty_in_out_bottom_sheet';

  @override
  State<EmptyInOutBottomSheet> createState() => _State();
}

class _State extends State<EmptyInOutBottomSheet> {
  /// Default Controllers
  TextEditingController entryTypeController =
      TextEditingController(text: "Empty - (In / Out)");
  Rxn<WeaverByLoomStatusModel> warpStatusController =
      Rxn<WeaverByLoomStatusModel>();
  Rxn<LoomGroup> loomNoController = Rxn<LoomGroup>();
  final _selectedEntryType = "Empty - (In / Out)".obs;
  final _formKey = GlobalKey<FormState>();
  EmptyInOutController controller = Get.find();
  final FocusNode _submitButtonFocusNode = FocusNode();
  final FocusNode _warpStatusFocusNode = FocusNode();

  /// Empty - (In / Out) Controllers
  TextEditingController emptyInOutBeamIn = TextEditingController(text: '0');
  TextEditingController emptyInOutBeamOut = TextEditingController(text: '0');
  TextEditingController emptyInOutBobbinIn = TextEditingController(text: '0');
  TextEditingController emptyInOutBobbinOut = TextEditingController(text: '0');
  TextEditingController emptyInOutSheetIn = TextEditingController(text: '0');
  TextEditingController emptyInOutSheetOut = TextEditingController(text: '0');
  TextEditingController emptyInOutDetails = TextEditingController();
  TextEditingController emptyInOutBeamInDesignText = TextEditingController();
  TextEditingController emptyInOutBobbinInDesignText = TextEditingController();
  Rxn<NewWarpModel> emptyInOutBeamInDesign = Rxn<NewWarpModel>();
  Rxn<NewWarpModel> emptyInOutBobbinInDesign = Rxn<NewWarpModel>();
  final FocusNode _beamInDesignFocusNode = FocusNode();
  final FocusNode _bobbinInDesignFocusNode = FocusNode();
  final FocusNode _bobbinInFocusNode = FocusNode();
  final FocusNode _sheetInFocusNode = FocusNode();

  RxString otherWarp = RxString("");

  var shortCut = RxString("");
  RxString productName = RxString("");

  List<WeaverCurrentProductModel> weaverWarpStockDetails =
      <WeaverCurrentProductModel>[];
  late ItemDataSource dataSource;
  late WarpStockDataSource warpStockDataSource;

  @override
  void initState() {
    controller.warpStatus.clear();
    super.initState();
    warpStockDataSource = WarpStockDataSource(list: weaverWarpStockDetails);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmptyInOutController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text('Weaving...'),
        ),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                MyLoomAutoComplete(
                                  label: 'Loom',
                                  items: controller.loomList,
                                  forceNextFocus: true,
                                  selectedItem: loomNoController.value,
                                  onChanged: (LoomGroup item) async {
                                    loomNoController.value = item;
                                    productDetailsApiCall();
                                    warpStatusApiCall();
                                  },
                                ),
                                Focus(
                                  focusNode: _warpStatusFocusNode,
                                  skipTraversal: true,
                                  autofocus: false,
                                  child: MyAutoComplete(
                                    label: 'Warp Status',
                                    items: controller.warpStatus,
                                    selectedItem: warpStatusController.value,
                                    onChanged:
                                        (WeaverByLoomStatusModel item) async {
                                      warpStatusController.value = item;
                                      productName.value = item.productName!;
                                      runningWarpDetails();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyDropdownButtonFormField(
                                  controller: entryTypeController,
                                  hintText: "Entry Type",
                                  items: const ["Empty - (In / Out)"],
                                  onChanged: (value) {
                                    _selectedEntryType.value = value;
                                  },
                                ),
                                SizedBox(
                                  width: 240,
                                  child: Text(
                                    productName.value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Obx(() => updateWidget(_selectedEntryType.value)),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Text(shortCut.value,
                                      style: AppUtils.shortCutTextStyle()),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  child: MyAddButton(
                                    focusNode: _submitButtonFocusNode,
                                    onPressed: () => submit(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget updateWidget(String option) {
    return GetBuilder<EmptyInOutController>(builder: (controller) {
      if (option == 'Empty - (In / Out)') {
        return SizedBox(
          child: Wrap(
            children: [
              Row(
                children: [
                  MyTextField(
                    width: 150,
                    controller: emptyInOutBeamIn,
                    hintText: 'Beam Inward',
                    validate: 'number',
                  ),
                  MyTextField(
                    width: 150,
                    controller: emptyInOutBeamOut,
                    hintText: 'Beam Delivery',
                    validate: 'number',
                  ),
                  ExcludeFocusTraversal(
                    child: MySearchField(
                      label: "Main warp",
                      items: controller.newWarpDropDown,
                      textController: emptyInOutBeamInDesignText,
                      focusNode: _beamInDesignFocusNode,
                      requestFocus: _bobbinInFocusNode,
                      isValidate: false,
                      onChanged: (NewWarpModel item) {
                        emptyInOutBeamInDesign.value = item;
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  MyTextField(
                    width: 150,
                    focusNode: _bobbinInFocusNode,
                    controller: emptyInOutBobbinIn,
                    hintText: 'Bobbin Inward',
                    validate: 'number',
                  ),
                  MyTextField(
                    width: 150,
                    controller: emptyInOutBobbinOut,
                    hintText: 'Bobbin Delivery',
                    validate: 'number',
                  ),
                  ExcludeFocusTraversal(
                    child: MySearchField(
                      label: "Other warp",
                      items: controller.newWarpDropDown,
                      textController: emptyInOutBobbinInDesignText,
                      focusNode: _bobbinInDesignFocusNode,
                      requestFocus: _sheetInFocusNode,
                      isValidate: false,
                      onChanged: (NewWarpModel item) {
                        emptyInOutBobbinInDesign.value = item;
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  MyTextField(
                    width: 150,
                    focusNode: _sheetInFocusNode,
                    controller: emptyInOutSheetIn,
                    hintText: 'Sheet Inward',
                    validate: 'number',
                  ),
                  MyTextField(
                    width: 150,
                    controller: emptyInOutSheetOut,
                    hintText: 'Sheet Delivery',
                    validate: 'number',
                  ),
                ],
              ),
              Row(
                children: [
                  MyTextField(
                    controller: emptyInOutDetails,
                    hintText: 'Details',
                  ),
                  Obx(
                    () => Text(
                      otherWarp.value,
                      style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }

  shortCutKeys() {
    if (_warpStatusFocusNode.hasFocus) {
      shortCut.value = "To Create 'Weaving Page',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_warpStatusFocusNode.hasFocus) {
      var weaverId = controller.weaverId;
      var loomNo = loomNoController.value?.loomNo;

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
    }
  }

  runningWarpDetails() async {
    String? loomNo = loomNoController.value?.loomNo;
    if (loomNo?.toLowerCase() == "vl") {
      return;
    }

    var result =
        await controller.runningWarpDetails(controller.weaverId!, loomNo!);
    List<dynamic> mainWarpList = result["main_warp"];
    List<dynamic> otherWarpList = result["other_warp"];

    if (mainWarpList.isNotEmpty) {
      emptyInOutBeamInDesignText.text =
          "${mainWarpList.first["warp_name"] ?? ""}";
      emptyInOutBeamInDesign.value = NewWarpModel(
          id: mainWarpList.first["warp_design_id"],
          warpDetails: [],
          warpName: "${otherWarpList.first["warp_name"] ?? ""}");
    }

    if (otherWarpList.length == 1) {
      emptyInOutBobbinInDesignText.text =
          "${otherWarpList.first["warp_name"] ?? ""}";
      emptyInOutBobbinInDesign.value = NewWarpModel(
          id: otherWarpList.first["warp_design_id"],
          warpDetails: [],
          warpName: "${otherWarpList.first["warp_name"] ?? ""}");
    } else {
      otherWarp.value = "";
      for (var e in otherWarpList) {
        otherWarp.value += "${e["warp_name"]}, ";
      }
    }
  }

  /// weaver and loom by get the current product details
  productDetailsApiCall() async {
    weaverWarpStockDetails.clear();
    warpStockDataSource.updateDataGridRows();
    warpStockDataSource.updateDataGridSource();

    var weaverId = controller.weaverId;
    var loomNo = loomNoController.value?.loomNo;
    if (weaverId == null) {
      return;
    }
    List<WeaverCurrentProductModel> result =
        await controller.weaverCurrentProducts(weaverId, loomNo);
    weaverWarpStockDetails.addAll(result);
    warpStockDataSource.updateDataGridRows();
    warpStockDataSource.updateDataGridSource();
  }

  warpStatusApiCall() async {
    warpStatusController.value = null;
    var weaverId = controller.weaverId;
    var loomId = loomNoController.value?.loomNo;
    List<WeaverByLoomStatusModel> data =
        await controller.loomWarpStatus(weaverId, loomId);

    var index = data.indexWhere((e) => e.currentStatus == 'Running');
    initWarpStatus(index: index != -1 ? index : 0);
  }

  void initWarpStatus({var index = 0}) async {
    if (controller.warpStatus.isNotEmpty) {
      var item = controller.warpStatus[index];
      warpStatusController.value = item;
      productName.value = item.productName!;

      if (warpStatusController.value != null) {
        _apiCals();
      }
    }
  }

  void _apiCals() async {
    var productId = warpStatusController.value?.productId;

    /// Product Id By Warp Details Call
    if (productId != null) {
      await controller.warpInfo(productId);
    }

    _mainWarpDeliveryStatusCheck();
    runningWarpDetails();
  }

  _mainWarpDeliveryStatusCheck() {
    var loomId = loomNoController.value?.loomNo;
    var currentStatus = warpStatusController.value?.currentStatus;
    if (loomId == null || currentStatus == null) {
      return;
    }

    var ll = controller.itemList
        .where(
            (e) => e['loom'] == loomId && e['current_status'] == currentStatus)
        .toList();
    for (var e in ll) {
      if (e['entry_type'] == "Warp Delivery" && e["warp_type"] == "Main Warp") {
        controller.mainWarpDeliverStatus = true;
      }
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var entryType = _selectedEntryType.value.toString();
      Map<String, dynamic> request = {
        "entry_type": entryType,
        "loom": loomNoController.value?.loomNo,
        "current_status": warpStatusController.value?.currentStatus,
        "product_name": warpStatusController.value?.productName,
        "sync": 0,
        "e_date": "${DateTime.now()}".substring(0, 10),
      };
      if (entryType == "Empty - (In / Out)") {
        if (loomNoController.value?.loomNo?.toLowerCase() == "vl") {
          return;
        }

        int bmIn = int.tryParse(emptyInOutBeamIn.text) ?? 0;
        int bmOut = int.tryParse(emptyInOutBeamOut.text) ?? 0;
        int bbnIn = int.tryParse(emptyInOutBobbinIn.text) ?? 0;
        int bbnOut = int.tryParse(emptyInOutBobbinOut.text) ?? 0;
        int shtIn = int.tryParse(emptyInOutSheetIn.text) ?? 0;
        int shtOut = int.tryParse(emptyInOutSheetOut.text) ?? 0;

        var list = [];
        if (bmIn > 0) {
          if (emptyInOutBeamInDesign.value == null) {
            return AppUtils.infoAlert(message: "Select the manin warp");
          }

          var req = Map.from(request);
          req['bm_in'] = bmIn;
          req['bm_out'] = 0;
          req['bbn_in'] = 0;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          req["empty_warp_desing_id"] = emptyInOutBeamInDesign.value?.id;
          req["empty_warp_desing_name"] =
              emptyInOutBeamInDesign.value?.warpName;
          list.add(req);
        }
        if (bmOut > 0) {
          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = bmOut;
          req['bbn_in'] = 0;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        if (bbnIn > 0) {
          if (emptyInOutBobbinInDesign.value == null) {
            return AppUtils.infoAlert(message: "Select the Other warp");
          }

          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = 0;
          req['bbn_in'] = bbnIn;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          req["empty_warp_desing_id"] = emptyInOutBobbinInDesign.value?.id;
          req["empty_warp_desing_name"] =
              emptyInOutBobbinInDesign.value?.warpName;
          list.add(req);
        }
        if (bbnOut > 0) {
          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = 0;
          req['bbn_in'] = 0;
          req['bbn_out'] = bbnOut;
          req['sht_in'] = 0;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        if (shtIn > 0) {
          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = 0;
          req['bbn_in'] = 0;
          req['bbn_out'] = 0;
          req['sht_in'] = shtIn;
          req['sht_out'] = 0;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        if (shtOut > 0) {
          var req = Map.from(request);
          req['bm_in'] = 0;
          req['bm_out'] = 0;
          req['bbn_in'] = 0;
          req['bbn_out'] = 0;
          req['sht_in'] = 0;
          req['sht_out'] = shtOut;
          req["product_details"] = emptyInOutDetails.text;
          list.add(req);
        }
        request['list'] = list;
        Get.back(result: request);
      }
    }
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;
  var today = "${DateTime.now()}".substring(0, 10);

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var wevYarn = e["wev_stock"];
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(
            columnName: 'weaver_stock', value: wevYarn.toStringAsFixed(3)),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color? weaverStockText;
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      TextStyle? getTextStyle() {
        if (e.columnName == "weaver_stock") {
          return TextStyle(
            color: weaverStockText ?? Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        } else {
          return const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.visible,
          );
        }
      }

      if (e.columnName == "weaver_stock") {
        double data = double.tryParse("${e.value}") ?? 0.0;

        if (data < 0) {
          weaverStockText = Colors.red;
        }
      }

      return Container(
        padding: const EdgeInsets.all(8),
        alignment: e.columnName == "weaver_stock"
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          e.value != null ? '${e.value}' : ' ',
          style: getTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}

class WarpStockDataSource extends DataGridSource {
  WarpStockDataSource({required List<WeaverCurrentProductModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<WeaverCurrentProductModel> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var details = '';
      var productName = '';
      var warpDesign = '';
      var warpId = '';
      var balanceQty = '';
      var balanceMtr = '';
      var qtyMeter = '';

      if (e.productName != null) {
        productName = "${e.productName},  ";
      }
      if (e.warpName != null) {
        warpDesign = "${e.warpName},  ";
      }
      if (e.warpId != null && e.warpId != "NULL") {
        warpId = "${e.warpId},  ";
      }
      if (e.balanceQty != 0 && e.warpType == "Main Warp") {
        balanceQty = "Qty: ${e.balanceQty}, ";
      }

      if (e.balanceMeter != 0 && e.warpType == "Other") {
        balanceMtr = "Mtr ${e.balanceMeter}, ";
      }

      details = "$productName$warpDesign$warpId";
      qtyMeter = "$balanceQty$balanceMtr";

      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'warp_status', value: e.currentStatus),
        DataGridCell<dynamic>(columnName: 'details', value: details),
        DataGridCell<dynamic>(columnName: 'meter_qty', value: qtyMeter),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == "meter_qty") {
        return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            e.value != null ? '${e.value}' : '',
            style: const TextStyle(
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            e.value != null ? '${e.value}' : '',
            style: AppUtils.cellTextStyle(),
          ),
        );
      }
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
