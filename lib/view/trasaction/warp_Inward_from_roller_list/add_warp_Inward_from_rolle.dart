import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/WarpInwardFromRollerModel.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller_bottomsheet.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/DropModel.dart';
import '../../../model/FirmModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';

class AddWarpInwardFromRoller extends StatefulWidget {
  const AddWarpInwardFromRoller({super.key});

  static const String routeName = '/AddWarpInwardFromRoller';

  @override
  State<AddWarpInwardFromRoller> createState() => _State();
}

class _State extends State<AddWarpInwardFromRoller> {
  TextEditingController idController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<DropModel> roller = Rxn<DropModel>();
  TextEditingController referenceNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Rxn<LedgerModel> accountType = Rxn<LedgerModel>();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalProductQtyController = TextEditingController();
  TextEditingController wagesStatusController =
      TextEditingController(text: "Pending");

  final _formKey = GlobalKey<FormState>();
  WarpInwardFromRollerController controller = Get.find();
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _accountTypeFocusNode = FocusNode();
  final FocusNode _rollerNameFocusNode = FocusNode();
  final FocusNode _addItemFocus = FocusNode();
  var shortCut = RxString("");

  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);
  final DataGridController _dataGridController = DataGridController();

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  @override
  void initState() {
    controller.getBackBoolean.value = false;
    _accountTypeFocusNode.addListener(() => shortCutKeys());
    _rollerNameFocusNode.addListener(() => shortCutKeys());
    controller.itemList.clear();
    controller.lastWarp = null;
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpInwardFromRollerController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warp Inward From Roller"),
          actions: [
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyDeleteIconButton(
                onPressed: (password) {
                  controller.delete(idController.text, password);
                },
              ),
            ),
            const SizedBox(width: 8),
            Visibility(
              visible: Get.arguments != null,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
            Visibility(
              visible: idController.text.isNotEmpty,
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
            const SizedBox(width: 12),
          ],
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              getBackAlert();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            AddNewIntent: SetCounterAction(perform: () {
              _addItem();
            }),
            PrintIntent: SetCounterAction(perform: () {
              _print();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeSelectedItems();
            }),
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: WillPopScope(
            onWillPop: () async {
              getBackAlert();
              return false;
            },
            child: FocusScope(
              autofocus: true,
              child: SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xFFF9F3FF), width: 16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
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
                              enabled: !isUpdate.value,
                              onChanged: (FirmModel item) {
                                firmName.value = item;
                                //  _firmNameFocusNode.requestFocus();
                              },
                              autofocus: false,
                            ),
                            Focus(
                              focusNode: _accountTypeFocusNode,
                              skipTraversal: true,
                              child: MyAutoComplete(
                                label: 'Account Type',
                                items: controller.accountDropdown,
                                selectedItem: accountType.value,
                                enabled: !isUpdate.value,
                                onChanged: (LedgerModel item) {
                                  accountType.value = item;
                                },
                                autofocus: false,
                              ),
                            ),
                            Focus(
                              focusNode: _rollerNameFocusNode,
                              skipTraversal: true,
                              child: MyAutoComplete(
                                label: 'Roller Name',
                                items: controller.ledgerDropdown,
                                selectedItem: roller.value,
                                enabled: !isUpdate.value,
                                onChanged: (LedgerModel item) async {
                                  FocusScope.of(context)
                                      .requestFocus(_addItemFocus);
                                  controller.rollerId = item.id;
                                  roller.value = DropModel(
                                      id: item.id, name: item.ledgerName);
                                  controller.itemList.clear();
                                  dataTableDetailsUpdate();
                                  controller.warpDesignInfo(item.id);
                                },
                              ),
                            ),
                            MyTextField(
                              controller: referenceNoController,
                              hintText: "Reference No",
                              focusNode: _firstInputFocusNode,
                              // validate: "string",
                            ),
                            MyDateFilter(
                              controller: dateController,
                              labelText: 'Date',
                            ),
                            MyTextField(
                              controller: detailsController,
                              hintText: "Details",
                              // validate: "string",
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyAddItemsRemoveButton(
                                onPressed: () => removeSelectedItems()),
                            const SizedBox(width: 12),
                            AddItemsElevatedButton(
                              focusNode: _addItemFocus,
                              width: 135,
                              onPressed: () => _addItem(),
                              child: const Text('Add Item'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        itemsTable(),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: MyDropdownButtonFormField(
                            enabled: wagesStatusController.text != "Paid",
                            controller: wagesStatusController,
                            hintText: "Wages Status",
                            items: const ["Pending", "Paid"],
                            // validate: "string",
                          ),
                        ),
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
                              onPressed:
                                  controller.status.isLoading ? null : submit,
                            ),
                          ],
                        )
                      ],
                    ),
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
    if (_accountTypeFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Account',Press Alt+C ";
    } else if (_rollerNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Roller',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_accountTypeFocusNode.hasFocus) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.accountInfo();
      }
    } else if (_rollerNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.ledgerInfo();
      }
    }
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response =
        await controller.warpInwardFromRollerPdf(request: request);
    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "roller_id": roller.value?.id,
        "firm_id": firmName.value?.id,
        "wages_ano": accountType.value?.id,
        "reference_no": referenceNoController.text,
        "e_date": dateController.text,
        "details": detailsController.text,
        "wages_status": wagesStatusController.text,
      };
      var rollerItemList = [];
      var itemList = controller.itemList;
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "warp_design_id": itemList[i]['warp_design_id'],
          "old_warp_id": itemList[i]['old_warp_id'],
          "qty": itemList[i]['qty'],
          "length": itemList[i]['length'],
          "wages": itemList[i]['wages'],
          "empty_typ": itemList[i]['empty_typ'],
          "empty_qty": itemList[i]['empty_qty'],
          "sheet": itemList[i]['sheet'],
          "warp_color": itemList[i]['warp_color'],
          "new_warp_id": itemList[i]['new_warp_id'],
          "warp_det": itemList[i]['warp_det'],
          "weaver_id": itemList[i]['weaver_id'],
          "sub_weaver_no": itemList[i]['sub_weaver_no'],
          "warp_tracker_id": itemList[i]['warp_tracker_id'],
          "warp_for": itemList[i]['warp_for'],
        };

        rollerItemList.add(item);
      }
      request['roller_item'] = rollerItemList;
      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.addInward(request);
      } else {
        request['id'] = id;
        controller.updateInward(request);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    WarpInwardFromRollerController controller = Get.find();
    accountType.value = AppUtils.findLedgerAccountByName(
        controller.accountDropdown, 'Rolling Wages');
    firmName.value = AppUtils.setDefaultFirmName(controller.firmDropdown);
    if (Get.arguments != null) {
      isUpdate.value = true;
      WarpInwardFromRollerController controller = Get.find();
      var item = WarpInwardFromRollerModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      referenceNoController.text = item.referenceNo ?? '';
      dateController.text = '${item.eDate}';
      detailsController.text = item.details ?? '';
      wagesStatusController.text = "${item.wagesStatus}";
      roller.value = DropModel(id: item.rollerId, name: '${item.rollerName}');
      var id = item.rollerId;
      controller.rollerId = id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.warpDesignInfo(id);
      });

      /*var rallerNameList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${item.rollerId}')
          .toList();
      if (rallerNameList.isNotEmpty) {
        rollerNameController.text = '${rallerNameList.first.ledgerName}';
        rollerName.value = rallerNameList.first;
      }*/

      var accountTypeList = controller.accountDropdown
          .where((element) => '${element.id}' == '${item.wagesAno}')
          .toList();
      if (accountTypeList.isNotEmpty) {
        accountTypeController.text = "${accountTypeList.first.ledgerName}";
        accountType.value = accountTypeList.first;
      }
      var firmList = controller.firmDropdown
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (accountTypeList.isNotEmpty) {
        firmName.value = firmList.first;
      }

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

      item.rollerItem?.forEach((element) {
        var request = element.toJson();
        controller.itemList.add(request);
      });
    }
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      controller: _dataGridController,
      selectionMode: SelectionMode.single,
      columns: [
        GridColumn(
          width: 50,
          columnName: 's_no',
          label: const MyDataGridHeader(title: 'S.No'),
        ),
        GridColumn(
          width: 180,
          columnName: 'warp_design_id',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          width: 140,
          columnName: 'old_warp_id',
          label: const MyDataGridHeader(title: 'Old Warp ID'),
        ),
        GridColumn(
          width: 140,
          columnName: 'new_warp_id',
          label: const MyDataGridHeader(title: 'New Warp Id'),
        ),
        GridColumn(
          width: 50,
          columnName: 'qty',
          label: const MyDataGridHeader(title: 'Qty'),
        ),
        GridColumn(
          width: 60,
          columnName: 'length',
          label: const MyDataGridHeader(title: 'length'),
        ),
        GridColumn(
          width: 60,
          columnName: 'beam',
          label: const MyDataGridHeader(title: 'Beam'),
        ),
        GridColumn(
          width: 60,
          columnName: 'bobbin',
          label: const MyDataGridHeader(title: 'Bobbin'),
        ),
        GridColumn(
          width: 60,
          columnName: 'sheet',
          label: const MyDataGridHeader(title: 'Sheet'),
        ),
        GridColumn(
          width: 100,
          columnName: 'wages',
          label: const MyDataGridHeader(title: 'Wages (Rs)'),
        ),
        GridColumn(
          width: 100,
          columnName: 'warp_color',
          label: const MyDataGridHeader(title: 'Warp Color'),
        ),
        GridColumn(
          minimumWidth: 200,
          columnName: 'warp_det',
          label: const MyDataGridHeader(title: 'Details'),
        ),
        GridColumn(
          width: 180,
          columnName: 'weaver_name',
          label: const MyDataGridHeader(title: 'Weaver Name'),
        ),
        GridColumn(
          width: 60,
          columnName: 'loom_no',
          label: const MyDataGridHeader(title: 'Loom'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'qty',
              columnName: 'qty',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'length',
              columnName: 'length',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'sheet',
              columnName: 'sheet',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'beam',
              columnName: 'beam',
              summaryType: GridSummaryType.sum,
            ),
            const GridSummaryColumn(
              name: 'bobbin',
              columnName: 'bobbin',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = controller.itemList[index];
        var result = await Get.to(
          const WarpInwardFromRollerBottomSheet(),
          arguments: {
            'item': item,
            "payment_status": wagesStatusController.text,
          },
        );
        if (result != null) {
          controller.itemList[index] = result;
          dataTableDetailsUpdate();
        }
      },
    );
  }

  removeSelectedItems() async {
    int? index = _dataGridController.selectedIndex;

    if (index < 0) {
      return AppUtils.infoAlert(message: "Select The Value");
    }

    var data = controller.itemList[index];

    if (data["sync"] == 0) {
      _removeItem(index);
      return;
    }

    if (wagesStatusController.text == "Paid") {
      return AppUtils.infoAlert(
          message:
              "Wages have already been paid for this slip, so it cannot be removed.");
    }

    var result = await controller.rowRemoveCheck(
        data["id"], data["warp_inward_from_roller_id"], data["new_warp_id"]);

    if (result == "sucess") {
      _removeItem(index);
    }
  }

  void _removeItem(int index) {
    controller.itemList.removeAt(index);
    dataTableDetailsUpdate();
    _dataGridController.selectedIndex = -1;
  }

  void _addItem() async {
    var rollerId = roller.value?.id;
    var eDate = dateController.text;
    if (rollerId == null || eDate.isEmpty) {
      return;
    }

    /// Last Added Ware Design Show In Add Item
    if (controller.itemList.isNotEmpty) {
      controller.lastWarp = controller.itemList.last;
    }

    /// New Warp Id Auto Increment
    controller.warpID = '';
    if (controller.itemList.isEmpty) {
      /// Api By Get Last Warp Id
      var result = await controller.warpIdInfo(rollerId, eDate);

      var item = result?.newWarpId;
      final split = item?.split('-');
      if (split!.isNotEmpty) {
        var number = int.parse(split.last);
        controller.warpID = '${split.first}-${number + 1}';
      }
    } else {
      /// Item Table By Get Last Warp Id
      var item = controller.itemList.last['new_warp_id'];
      final split = item.split('-');
      if (split.isNotEmpty) {
        var number = int.parse(split.last);
        controller.warpID = '${split.first}-${number + 1}';
      }
    }

    var result = await Get.to(() => const WarpInwardFromRollerBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
      dataTableDetailsUpdate();

      await Future.delayed(const Duration(milliseconds: 500));
      _addItem();
    }
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

  dataTableDetailsUpdate() {
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  getBackAlert() async {
    if (controller.getBackBoolean.value == true) {
      await AppUtils.showExitDialog(context) == true ? submit() : '';
    } else {
      Get.back();
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

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      var index = _list.indexOf(e);
      num beam = 0;
      num bobbin = 0;
      if (e["empty_typ"] == "Beam") {
        beam += e["empty_qty"];
      } else {
        bobbin += e["empty_qty"];
      }

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: index + 1),
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell<dynamic>(
            columnName: 'old_warp_id', value: e['old_warp_id']),
        DataGridCell<dynamic>(
            columnName: 'new_warp_id', value: e['new_warp_id']),
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
        DataGridCell<dynamic>(columnName: 'length', value: e['length']),
        DataGridCell<dynamic>(columnName: 'beam', value: beam),
        DataGridCell<dynamic>(columnName: 'bobbin', value: bobbin),
        DataGridCell<dynamic>(columnName: 'sheet', value: e['sheet']),
        DataGridCell<dynamic>(columnName: 'wages', value: e['wages']),
        DataGridCell<dynamic>(columnName: 'warp_color', value: e['warp_color']),
        DataGridCell<dynamic>(columnName: 'warp_det', value: e['warp_det']),
        DataGridCell<dynamic>(
            columnName: 'weaver_name', value: e['weaver_name']),
        DataGridCell<dynamic>(columnName: 'loom_no', value: e['loom_no']),
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
        case 'qty':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'length':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'beam':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'bobbin':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'sheet':
          return buildFormattedCell(value, decimalPlaces: 0);
        case 'wages':
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
      case 'qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'length':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'beam':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'bobbin':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'sheet':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      default:
        /*   alignment = TextAlign.right;
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
