import 'package:abtxt/model/SplitWarpModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/adjustments/split_warp/split_warp_bottom_sheet.dart';
import 'package:abtxt/view/adjustments/split_warp/split_warp_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/NewWarpModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddSplitWarp extends StatefulWidget {
  const AddSplitWarp({Key? key}) : super(key: key);
  static const String routeName = '/add_split_warp';

  @override
  State<AddSplitWarp> createState() => _State();
}

class _State extends State<AddSplitWarp> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  Rxn<NewWarpModel> newWarpDesignName = Rxn<NewWarpModel>();
  TextEditingController endsController = TextEditingController(text: '0');
  Rxn<SplitWarpWarpIdItemTableModel> warpIdNo =
      Rxn<SplitWarpWarpIdItemTableModel>();
  TextEditingController meterController = TextEditingController(text: '0');
  TextEditingController emptypeController = TextEditingController();
  TextEditingController empqytController = TextEditingController(text: '0');
  TextEditingController warpColorController = TextEditingController();
  TextEditingController sheetController = TextEditingController(text: "0");

  final _formKey = GlobalKey<FormState>();
  late SplitWarpController controller;

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;
  final FocusNode _firstInputFocusNode = FocusNode();
  var selectedItemIndex = <int>[].obs;

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_firstInputFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplitWarpController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title:
              Text("${idController.text == '' ? 'Add' : 'Update'} Split Warp"),
        ),
        // bindings: {
        //   const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
        //       Get.back(),
        //   const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
        //       _addItem(),
        //   const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
        //       submit(),
        // },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true):
              AddNewIntent(),
          SingleActivator(LogicalKeyboardKey.keyR, control: true):
              RemoveIntent(),
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
            AddNewIntent: SetCounterAction(perform: () {
              _addItem();
            }),
            RemoveIntent: SetCounterAction(perform: () {
              removeSelectedItems();
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Form(
                        key: _formKey,
                        child: Container(
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
                                  MyDateFilter(
                                    controller: dateController,
                                    labelText: "Date",
                                  ),
                                  MyTextField(
                                    controller: detailsController,
                                    hintText: "Details",

                                    // validate: "string",
                                  ),
                                  MyAutoComplete(
                                    label: 'Warp Design',
                                    items: controller.newWarp,
                                    selectedItem: newWarpDesignName.value,
                                    onChanged: (NewWarpModel item) async {
                                      newWarpDesignName.value = item;
                                      endsController.clear();
                                      warpIdNo.value = null;
                                      endsController.text = '${item.totalEnds}';
                                      await controller
                                          .warpIdNoDropdown(item.id);
                                    },
                                  ),
                                  MyTextField(
                                    controller: endsController,
                                    hintText: "Total Ends",
                                    // validate: "number",
                                  ),
                                  MyAutoComplete(
                                    label: 'Warp Id No',
                                    enabled:
                                        controller.warpIdDropdown.isNotEmpty,
                                    items: controller.warpIdDropdown,
                                    selectedItem: warpIdNo.value,
                                    onChanged: (SplitWarpWarpIdItemTableModel
                                        item) async {
                                      warpIdNo.value = item;
                                      meterController.clear();
                                      emptypeController.clear();
                                      empqytController.clear();
                                      warpColorController.clear();
                                      sheetController.clear();
                                      meterController.text = '${item.metre}';
                                      emptypeController.text =
                                          '${item.emptyType}';
                                      empqytController.text =
                                          '${item.emptyQty}';
                                      warpColorController.text =
                                          '${item.warpColor}';
                                      sheetController.text = '${item.sheet}';
                                    },
                                  ),
                                  MyTextField(
                                    controller: meterController,
                                    hintText: "Meter",
                                    validate: "double",
                                  ),
                                  MyTextField(
                                    controller: emptypeController,
                                    hintText: "Empty Type ",
                                    validate: "string",
                                  ),
                                  MyTextField(
                                    controller: empqytController,
                                    hintText: "Empty Qty",
                                    validate: "number",
                                  ),
                                  MyTextField(
                                    controller: warpColorController,
                                    hintText: "Warp Color",
                                    // validate: "string",
                                  ),
                                  MyTextField(
                                    controller: sheetController,
                                    hintText: "Sheet",
                                    validate: "number",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Obx(
                                    () => Visibility(
                                      visible: selectedItemIndex.isNotEmpty,
                                      child:
                                          MyAddItemsRemoveButton(onPressed: () {
                                        removeSelectedItems();
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  AddItemsElevatedButton(
                                    width: 135,
                                    onPressed: () async {
                                      _addItem();
                                    },
                                    child: const Text('Add Item'),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ItemsTable(),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  /* MyCloseButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Close'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),*/
                                  MySubmitButton(
                                    onPressed: () => submit(),
                                  ),
                                ],
                              )
                            ],
                          ),
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

  /*
  Future<void> warpIdDetailsDisplay(SplitWarpWarpIdItemTableModel item) async {
    print(jsonEncode(item));
    meterController.text = '${item.metre}';
    emptypeController.text = '${item.emptyType}';
    empqytController.text = '${item.emptyQty}';
    warpColorController.text = '${item.warpColor}';
    sheetController.text = '${item.sheet}';

    itemList.clear();
    var request = {
      "warp_color": item.warpColor,
      "metre": item.metre,
      "sheet": item.sheet,
      "empty_qty": item.emptyQty,
      "wrap_condition": item.wrapCondition,
      "empty_type": item.emptyType,
    };
    itemList.add(request);
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }
   */

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "e_date": dateController.text,
        "details": detailsController.text ?? '',
        "warp_design_id": newWarpDesignName.value?.id,
        "total_ends": int.tryParse(endsController.text) ?? 0,
        "warp_id_no": warpIdNo.value?.warpId,
        "metre": int.tryParse(meterController.text) ?? 0,
        "empty_type": emptypeController.text,
        "empty_qty": int.tryParse(empqytController.text) ?? 0,
        "warp_colors": warpColorController.text,
        "sheet": int.tryParse(sheetController.text) ?? 0,
      };
      request['warp_item'] = itemList;
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = '$id';
        controller.edit(request, id);
      }
      //  print('Print: ${jsonEncode(request)}');
    }
  }

  void _initValue() async {
    SplitWarpController controller = Get.find();
    controller.request = <String, dynamic>{};
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (Get.arguments != null) {
      var item = SplitWarpModel.fromJson(Get.arguments['item']);
      idController.text = tryCast(item.id);
      dateController.text = item.eDate ?? '';
      detailsController.text = item.details ?? '';
      var warplist = controller.newWarp
          .where((element) => '${element.id}' == '${item.warpDesignId}')
          .toList();
      if (warplist.isNotEmpty) {
        newWarpDesignName.value = warplist.first;
        await controller.warpIdNoDropdown(newWarpDesignName.value?.id);
        var warpIdList = controller.warpIdDropdown
            .where((e) => '${e.warpId}' == '${item.warpIdNo}')
            .toList();
        if (warpIdList.isNotEmpty) {
          warpIdNo.value = warpIdList.first;
        }
      }
      //  warpidNoController.text = item.warpIdNo ?? '';
      endsController.text = tryCast(item.totalEnds);
      meterController.text = tryCast(item.metre);
      emptypeController.text = item.emptyType ?? '';
      empqytController.text = tryCast(item.emptyQty);
      warpColorController.text = item.warpColors ?? '';
      sheetController.text = tryCast(item.sheet);
      item.warpItem?.forEach((e) {
        var item = e.toJson();
        itemList.add(item);
      });
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.single,
      columns: [
        GridColumn(
          columnName: 'warp_id_no',
          label: const MyDataGridHeader(title: 'Warp ID No'),
        ),
        GridColumn(
          columnName: 'warp_design_name',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          columnName: 'warp_color',
          label: const MyDataGridHeader(title: 'Warp Color'),
        ),
        GridColumn(
          columnName: 'wrap_condition',
          label: const MyDataGridHeader(title: 'Warp Condition'),
        ),
        GridColumn(
          columnName: 'metre',
          label: const MyDataGridHeader(title: 'Meter'),
        ),
        GridColumn(
          columnName: 'empty_type',
          label: const MyDataGridHeader(title: 'Empty Type'),
        ),
        GridColumn(
          columnName: 'empty_qty',
          label: const MyDataGridHeader(title: 'Empty Qty'),
        ),
        GridColumn(
          columnName: 'sheet',
          label: const MyDataGridHeader(title: 'Sheet'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'empty_qty',
              columnName: 'empty_qty',
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
        selectedItemIndexes(index);
        var item = itemList[index];
        var result = await Get.to(const SplitWarpBottomSheet(),
            arguments: {'item': item});
        if (result != null) {
          itemList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
      onRowSingleSelect: (index) {
        selectedItemIndexes(index);
      },
    );
  }

  void selectedItemIndexes(index) {
    if (selectedItemIndex.contains(index)) {
      selectedItemIndex.remove(index);
    } else {
      selectedItemIndex.add(index);
    }
  }

  void removeSelectedItems() {
    if (selectedItemIndex.isEmpty) {
      return;
    }
    for (final index in selectedItemIndex) {
      itemList.removeAt(index);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    }
    selectedItemIndex.clear();
  }

  void _addItem() async {
    var result = await Get.to(const SplitWarpBottomSheet());
    if (result != null) {
      itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
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
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'warp_id_no', value: e['warp_id_no']),
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell<dynamic>(columnName: 'warp_color', value: e['warp_color']),
        DataGridCell<dynamic>(
            columnName: 'wrap_condition', value: e['wrap_condition']),
        DataGridCell<dynamic>(columnName: 'metre', value: e['metre']),
        DataGridCell<dynamic>(columnName: 'empty_type', value: e['empty_type']),
        DataGridCell<dynamic>(columnName: 'empty_qty', value: e['empty_qty']),
        DataGridCell<dynamic>(columnName: 'sheet', value: e['sheet']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          dataGridCell.value != null ? '${dataGridCell.value}' : '',
          style: AppUtils.cellTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        summaryValue,
        style: AppUtils.footerTextStyle(),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
