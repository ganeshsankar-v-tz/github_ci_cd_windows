import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/adjustments/warp_merging/warp_merging_bottomsheet.dart';
import 'package:abtxt/view/adjustments/warp_merging/warp_merging_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/NewWarpModel.dart';
import '../../../model/WarpMergingModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyAddItemsRemoveButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class AddWarpMerging extends StatefulWidget {
  const AddWarpMerging({Key? key}) : super(key: key);
  static const String routeName = '/add_warp_merging';

  @override
  State<AddWarpMerging> createState() => _State();
}

class _State extends State<AddWarpMerging> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  // TextEditingController recordNOController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  Rxn<NewWarpModel> newWarpDesignName = Rxn<NewWarpModel>();
  TextEditingController endsController = TextEditingController(text: "0");
  Rxn<WarpIDByWarpDetails> warpIdNo = Rxn<WarpIDByWarpDetails>();
  TextEditingController warptypeController = TextEditingController();
  TextEditingController WarpConditionController =
      TextEditingController(text: "UnDyed");
  TextEditingController proqytController = TextEditingController(text: "0");
  TextEditingController meterController = TextEditingController();
  TextEditingController emptypeController = TextEditingController();
  TextEditingController empqytController = TextEditingController(text: "0");
  TextEditingController SheetController = TextEditingController(text: "0");

  final _formKey = GlobalKey<FormState>();
  late WarpMergingController controller;
  var selectedItemIndex = <int>[].obs;

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;
  final FocusNode _firstInputFocusNode = FocusNode();

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
    return GetBuilder<WarpMergingController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Warp Merging"),
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _addItem(),
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
              submit(),
          const SingleActivator(LogicalKeyboardKey.keyR, control: true): () =>
              removeSelectedItems(),
        },
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
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
                                MyDateFilter(
                                  controller: dateController,
                                  labelText: "E Date",
                                ),
                                /*
                                MyTextField(
                                  controller: recordNOController,
                                  hintText: "Record No",
                                  readonly: true,
                                ),
                               */
                                MyTextField(
                                  controller: detailsController,
                                  hintText: "Details",
                                  focusNode: _firstInputFocusNode,
                                  // validate: "string",
                                ),
                                MyAutoComplete(
                                  label: 'Warp Design',
                                  items: controller.newWarp,
                                  // isValidate: false,
                                  selectedItem: newWarpDesignName.value,
                                  onChanged: (NewWarpModel item) async {
                                    newWarpDesignName.value = item;
                                    endsController.clear();
                                    warpIdNo.value = null;
                                    endsController.text = '${item.totalEnds}';
                                    await controller
                                        .warpDetailsDropdown(item.id);
                                  },
                                ),
                                MyTextField(
                                  controller: endsController,
                                  hintText: "Total Ends",
                                  readonly: true,
                                ),
                                MyAutoComplete(
                                  label: 'Warp Id No',
                                  enabled: controller.warpDetails.isNotEmpty,
                                  items: controller.warpDetails,
                                  selectedItem: warpIdNo.value,
                                  onChanged: (WarpIDByWarpDetails item) async {
                                    warpIdNo.value = item;
                                    warptypeController.clear();
                                    proqytController.clear();
                                    meterController.clear();
                                    emptypeController.clear();
                                    empqytController.clear();
                                    SheetController.clear();
                                    warptypeController.text =
                                        '${item.warpCondition}';
                                    proqytController.text =
                                        '${item.prodQty ?? "0"}';
                                    meterController.text = '${item.metre}';
                                    emptypeController.text =
                                        '${item.emptyType}';
                                    empqytController.text = '${item.emptyQty}';
                                    SheetController.text = '${item.sheet}';
                                  },
                                ),
                                MyTextField(
                                  controller: warptypeController,
                                  hintText: "Warp Type ",
                                  readonly: true,
                                  validate: "string",
                                ),
                                MyDropdownButtonFormField(
                                  controller: WarpConditionController,
                                  hintText: "Warp Condition",
                                  items: ["UnDyed", "Dyed"],
                                ),
                                MyTextField(
                                  controller: proqytController,
                                  hintText: "Product Qty",
                                  validate: "number",
                                ),
                                MyTextField(
                                  controller: meterController,
                                  hintText: "Meter",
                                  validate: "number",
                                ),
                                MyTextField(
                                  controller: emptypeController,
                                  hintText: "Empty Type",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: empqytController,
                                  hintText: "Empty Qty",
                                  validate: "number",
                                ),
                                MyTextField(
                                  controller: SheetController,
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
                              height: 20,
                            ),
                            ItemsTable(),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MySubmitButton(
                                  onPressed: () => submit(),
                                ),
                                /* MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),*/
                                /*SizedBox(
                                  child: MyElevatedButton(
                                    onPressed: () => submit(),
                                    child: Text(
                                        "${Get.arguments == null ? 'SAVE' : 'UPDATE'}"),
                                  ),
                                ),*/
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "e_date": dateController.text,
        "details": detailsController.text ?? '',
        "warp_design_id": newWarpDesignName.value?.id,
        "warp_id_no": warpIdNo.value?.warpId,
        "warp_type": warptypeController.text,
        "warp_condition": WarpConditionController.text,
        "prod_qty": int.tryParse(proqytController.text) ?? 0,
        "metre": int.tryParse(meterController.text) ?? 0,
        "empty_typ": emptypeController.text,
        "empty_qty": int.tryParse(empqytController.text) ?? 0,
        "sheet": int.tryParse(SheetController.text) ?? 0,
      };

      request['item_details'] = itemList;
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request, id);
      }
    }
  }

  Future<void> _initValue() async {
    WarpMergingController controller = Get.find();
    controller.request = <String, dynamic>{};
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (Get.arguments != null) {
      var item = WarpMergingModel.fromJson(Get.arguments['item']);
      idController.text = tryCast(item.id);
      dateController.text = item.eDate ?? '';
      // recordNOController.text = '${item['id']}';
      detailsController.text = item.details ?? '';
      var warplist = controller.newWarp
          .where((element) => '${element.id}' == '${item.warpDesignId}')
          .toList();
      if (warplist.isNotEmpty) {
        newWarpDesignName.value = warplist.first;
        await controller.warpDetailsDropdown(newWarpDesignName.value?.id);
        var warpIdList = controller.warpDetails
            .where((e) => '${e.warpId}' == '${item.warpIdNo}')
            .toList();
        if (warpIdList.isNotEmpty) {
          warpIdNo.value = warpIdList.first;
        }
      }

      endsController.text = tryCast(item.totalEnds);
      //  warpIdNo.text = '${item['warp_id_no']}';
      warptypeController.text = tryCast(item.warpType);
      WarpConditionController.text = tryCast(item.warpCondition);
      proqytController.text = tryCast(item.prodQty);
      meterController.text = tryCast(item.metre);
      emptypeController.text = tryCast(item.emptyTyp);
      empqytController.text = tryCast(item.emptyQty);
      SheetController.text = tryCast(item.sheet);

      item.itemDetails?.forEach((e) {
        var item = e.toJson();
        itemList.add(item);
      });
      // dataSource.updateDataGridRows();
      // dataSource.updateDataGridSource();
    }
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      selectionMode: SelectionMode.multiple,
      columns: [
        GridColumn(
          columnName: 'warp_id_no',
          label: const MyDataGridHeader(title: 'Warp ID No'),
        ),
        GridColumn(
          columnName: 'warp_design',
          label: const MyDataGridHeader(title: 'Warp Design'),
        ),
        GridColumn(
          columnName: 'meter',
          label: const MyDataGridHeader(title: 'Meter'),
        ),
        GridColumn(
          columnName: 'total_ends',
          label: const MyDataGridHeader(title: 'Ends'),
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
    var result = await Get.to(const WarpMergingBottomSheet());
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
            columnName: 'warp_design', value: e['warp_design_name']),
        DataGridCell<dynamic>(columnName: 'meter', value: e['metre']),
        DataGridCell<dynamic>(columnName: 'total_ends', value: e['total_ends']),
        DataGridCell<dynamic>(columnName: 'empty_type', value: e['empty_typ']),
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
