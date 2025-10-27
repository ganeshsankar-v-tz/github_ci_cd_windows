import 'dart:convert';

import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/model/WarpDeliveryRollerModel.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/warp_delivery_to_roller_bottomsheet.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/warp_delivery_to_roller_bottomsheet_two.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/warp_delivery_to_roller_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/saree_checker/SareeCheckerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_search_field/my_search_field.dart';
import '../../basics/ledger/addledger.dart';

class AddWarpDeliveryRoller extends StatefulWidget {
  const AddWarpDeliveryRoller({super.key});

  static const String routeName = '/add_warp_delivery_to_roller';

  @override
  State<AddWarpDeliveryRoller> createState() => _State();
}

class _State extends State<AddWarpDeliveryRoller> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> rollerName = Rxn<LedgerModel>();
  TextEditingController rollernameController = TextEditingController();
  TextEditingController dCNoController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController totalProductQtyController = TextEditingController();
  TextEditingController totalMeterController = TextEditingController();
  TextEditingController totalBeamController = TextEditingController();
  TextEditingController totalBobbinController = TextEditingController();
  TextEditingController totalSheetController = TextEditingController();
  var warpCheckerController = TextEditingController();
  Rxn<SareeCheckerModel> warpChecker = Rxn<SareeCheckerModel>();

  final _formKey = GlobalKey<FormState>();
  WarpDeliveryToRollerController controller = Get.find();

  RxBool isUpdate = RxBool(false);
  RxBool addItemVisible = RxBool(false);

  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _rollerNameFocusNode = FocusNode();
  final FocusNode _warpCheckerFocusNode = FocusNode();
  var shortCut = RxString("");

  final DataGridController _dataGridController = DataGridController();
  final FocusNode _addItemController = FocusNode();
  late RollerDeliveryItemDataSource dataSource;

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
    _rollerNameFocusNode.addListener(() => shortCutKeys());
    controller.itemList.clear();
    controller.lastWarp = null;
    _initValue();
    super.initState();
    dataSource = RollerDeliveryItemDataSource(list: controller.itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_addItemController);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpDeliveryToRollerController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warp Delivery To Roller"),
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
              visible: dCNoController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Focus(
                                      focusNode: _rollerNameFocusNode,
                                      skipTraversal: true,
                                      child: MyAutoComplete(
                                        label: 'Roller Name',
                                        items: controller.ledgerDropdown,
                                        selectedItem: rollerName.value,
                                        enabled: !isUpdate.value,
                                        onChanged: (LedgerModel item) {
                                          rollerName.value = item;
                                          controller.rollerWarpBalanceDetails(
                                              item.id);
                                          FocusScope.of(context).requestFocus(
                                              _warpCheckerFocusNode);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                MySearchField(
                                  label: 'Warp Checker',
                                  textController: warpCheckerController,
                                  focusNode: _warpCheckerFocusNode,
                                  items: controller.warpCheckerDropdown,
                                  onChanged: (SareeCheckerModel item) {
                                    warpChecker.value = item;
                                  },
                                  requestFocus: _addItemController,
                                ),
                                Visibility(
                                  visible: dCNoController.text.isNotEmpty,
                                  child: MyTextField(
                                    controller: dCNoController,
                                    hintText: "D.C No",
                                    enabled: false,
                                  ),
                                ),
                                MyDateFilter(
                                  width: 160,
                                  controller: entryDateController,
                                  labelText: "Entry Date",
                                  focusNode: _firstInputFocusNode,
                                ),
                                Visibility(
                                  visible: false,
                                  child: MyTextField(
                                    controller: detailsController,
                                    hintText: "Details",
                                    // validate: "string",
                                  ),
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
                                  focusNode: _addItemController,
                                  onPressed: () => _addItem(),
                                  child: const Text('Add Item'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
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
                                  onPressed: controller.status.isLoading
                                      ? null
                                      : submit,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: addItemVisible.value,
                      child: Flexible(
                        flex: 2,
                        child: WarpDeliveryToRollerBottomSheetTwo(
                          dataSource: dataSource,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  shortCutKeys() {
    if (_rollerNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Roller',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_rollerNameFocusNode.hasFocus) {
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
    var request = {'id': idController.text, "dc_no": dCNoController.text};
    String? response =
        await controller.warpDeliverytoRollerPdf(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "roller_id": rollerName.value?.id,
        "e_date": entryDateController.text,
        "details": detailsController.text,
        "warp_checker_id": warpChecker.value?.id,
      };
      var itemList = controller.itemList;
      var itemDetailsList = [];
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          "warp_design_id": itemList[i]['warp_design_id'],
          "warp_id": itemList[i]['warp_id'],
          "empty_type": itemList[i]['empty_type'],
          "empty_qty": itemList[i]['empty_qty'],
          "sheet": itemList[i]['sheet'],
          "warp_weight": itemList[i]['warp_weight'],
          "warp_det": itemList[i]['warp_det'],
          "product_qty": itemList[i]['product_qty'],
          "warp_color": itemList[i]['warp_color'],
          "warp_inward": itemList[i]['warp_inward'],
          "weaver_id": itemList[i]['weaver_id'],
          "sub_weaver_no": itemList[i]['sub_weaver_no'],
          "warp_tracker_id": itemList[i]['warp_tracker_id'],
          "warp_for": itemList[i]['warp_for'],
        };
        itemDetailsList.add(item);
      }
      request['roller_item'] = itemDetailsList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.addwarpdroller(request);
      } else {
        request['id'] = id;
        request['dc_no'] = int.tryParse(dCNoController.text);
        controller.updatewarpdroller(request, id);
      }
    }
  }

  void _initValue() {
    entryDateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    if (Get.arguments != null) {
      isUpdate.value = true;
      WarpDeliveryToRollerController controller = Get.find();
      var item = WarpDeliveryRollerModel.fromJson(Get.arguments['item']);
      idController.text = '${item.id}';
      dCNoController.text = '${item.dcNo}';
      entryDateController.text = '${item.eDate}';
      detailsController.text = item.details ?? '';

      warpChecker.value = SareeCheckerModel(
        id: item.warpCheckerId,
        checkerName: item.warpCheckerName,
      );
      warpCheckerController.text = item.warpCheckerName ?? '';

      var rallerNameList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${item.rollerId}')
          .toList();
      if (rallerNameList.isNotEmpty) {
        rollernameController.text = '${rallerNameList.first.ledgerName}';
        rollerName.value = rallerNameList.first;
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

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (rollerName.value != null) {
          controller.rollerWarpBalanceDetails(rollerName.value?.id);
        }
      });

      item.itemDetails?.forEach((element) {
        var request = element.toJson();
        controller.itemList.add(request);
      });
    }
  }

  Widget itemsTable() {
    return Flexible(
      child: MySFDataGridItemTable(
        shrinkWrapRows: false,
        scrollPhysics: const ScrollPhysics(),
        controller: _dataGridController,
        selectionMode: SelectionMode.single,
        columns: [
          GridColumn(
            width: 40,
            columnName: 's_no',
            label: const MyDataGridHeader(title: 'S.N'),
          ),
          GridColumn(
            minimumWidth: 250,
            columnName: 'warp_design_name',
            label: const MyDataGridHeader(title: 'Warp Design'),
          ),
          GridColumn(
            width: 150,
            columnName: 'warp_id',
            label: const MyDataGridHeader(title: 'Warp ID'),
          ),
          GridColumn(
            width: 50,
            columnName: 'product_qty',
            label: const MyDataGridHeader(title: 'Qty'),
          ),
          GridColumn(
            width: 60,
            columnName: 'meter',
            label: const MyDataGridHeader(title: 'Meter'),
          ),
          GridColumn(
            minimumWidth: 250,
            columnName: 'warp_det',
            label: const MyDataGridHeader(title: 'Warp Details'),
          ),
          GridColumn(
            width: 250,
            columnName: 'warp_color',
            label: const MyDataGridHeader(title: 'Warp Color'),
          ),
          GridColumn(
            width: 40,
            columnName: 'beam',
            label: const MyDataGridHeader(title: 'Bm'),
          ),
          GridColumn(
            width: 40,
            columnName: 'bobbin',
            label: const MyDataGridHeader(title: 'Bbn'),
          ),
          GridColumn(
            width: 40,
            columnName: 'sheet',
            label: const MyDataGridHeader(title: 'Sht'),
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
          GridColumn(
            width: 80,
            columnName: 'warp_weight',
            label: const MyDataGridHeader(title: 'Weight'),
          ),
          GridColumn(
            visible: false,
            columnName: 'warp_inward',
            label: const MyDataGridHeader(title: 'Warp Inward'),
          ),
        ],
        tableSummaryRows: [
          GridTableSummaryRow(
            showSummaryInRow: false,
            title: 'Total: ',
            titleColumnSpan: 1,
            columns: [
              const GridSummaryColumn(
                name: 'product_qty',
                columnName: 'product_qty',
                summaryType: GridSummaryType.sum,
              ),
              const GridSummaryColumn(
                name: 'meter',
                columnName: 'meter',
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
              const GridSummaryColumn(
                name: 'sheet',
                columnName: 'sheet',
                summaryType: GridSummaryType.sum,
              ),
            ],
            position: GridTableSummaryRowPosition.bottom,
          ),
        ],
        source: dataSource,
        onRowSelected: (index) async {
          var item = controller.itemList[index];

          if (item["warp_inward"] == 1) {
            return AppUtils.infoAlert(
                message:
                    "This warp ID has already been inward, so the data cannot be changed.");
          }

          var result = await Get.to(
              () => const WarpDeliveryToRollerBottomSheet(),
              arguments: {'item': item});
          if (result != null) {
            controller.itemList[index] = result;
            dataTableDetailsUpdate();
          }
        },
      ),
    );
  }

  removeSelectedItems() {
    int? index = _dataGridController.selectedIndex;
    var item = controller.itemList[index];
    if (index >= 0) {
      if (item["warp_inward"] == 1) {
        return AppUtils.infoAlert(
            message:
                "This warp ID has already been inward, so the data cannot be remove.");
      }

      controller.itemList.removeAt(index);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      _dataGridController.selectedIndex = -1;
    } else {
      AppUtils.infoAlert(message: "Select The Value");
    }
  }

  void _addItem() {
    addItemVisible.value = true;
  }

  /*void _addItem() async {
    if (controller.itemList.isNotEmpty) {
      controller.lastWarp = controller.itemList.last;
    }

    var result = await Get.to(const WarpDeliveryToRollerBottomSheet());
    if (result != null) {
      controller.itemList.add(result);
      dataTableDetailsUpdate();

      await Future.delayed(const Duration(milliseconds: 500));
      _addItem();
    }
  }*/

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
    controller.itemList.sort((a, b) => a['warp_design_name']
        .toLowerCase()
        .compareTo(b['warp_design_name'].toLowerCase()));
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

class RollerDeliveryItemDataSource extends DataGridSource {
  RollerDeliveryItemDataSource({required List<dynamic> list}) {
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

      if (e["empty_type"] == "Beam") {
        beam += e["empty_qty"];
      }
      if (e["empty_type"] == "Bobbin") {
        bobbin += e["empty_qty"];
      }
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: index + 1),
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell<dynamic>(columnName: 'warp_id', value: e['warp_id']),
        DataGridCell<dynamic>(
            columnName: 'product_qty', value: e["product_qty"]),
        DataGridCell<dynamic>(columnName: 'meter', value: e['meter']),
        DataGridCell<dynamic>(columnName: 'warp_det', value: e["warp_det"]),
        DataGridCell<dynamic>(columnName: 'warp_color', value: e['warp_color']),
        DataGridCell<dynamic>(columnName: 'beam', value: beam),
        DataGridCell<dynamic>(columnName: 'bobbin', value: bobbin),
        DataGridCell<dynamic>(columnName: 'sheet', value: e["sheet"]),
        DataGridCell<dynamic>(
            columnName: 'weaver_name', value: e["weaver_name"]),
        DataGridCell<dynamic>(columnName: 'loom_no', value: e["loom_no"]),
        DataGridCell<dynamic>(
            columnName: 'warp_weight', value: e["warp_weight"]),
        DataGridCell<dynamic>(
            columnName: 'warp_inward', value: e["warp_inward"]),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowColor() {
      if (row.getCells()[13].value == 1) {
        return Colors.green.shade100;
      } else {
        return Colors.transparent;
      }
    }

    return DataGridRowAdapter(
        color: getRowColor(),
        cells: row.getCells().map<Widget>((dataGridCell) {
          double value = double.tryParse('${dataGridCell.value}') ?? 0;
          final columnName = dataGridCell.columnName;
          switch (columnName) {
            case 'product_qty':
              return buildFormattedCell(value, decimalPlaces: 0);
            case 'meter':
              return buildFormattedCell(value, decimalPlaces: 0);
            case 'beam':
              return buildFormattedCell(value, decimalPlaces: 0);
            case 'bobbin':
              return buildFormattedCell(value, decimalPlaces: 0);
            case 'sheet':
              return buildFormattedCell(value, decimalPlaces: 0);
            case 'warp_weight':
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
      case 'product_qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
      case 'meter':
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
        /* alignment = TextAlign.right;
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
