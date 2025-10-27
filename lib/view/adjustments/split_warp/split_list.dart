import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/adjustments/split_warp/split_warp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_split_warp.dart';

class SplitList extends StatefulWidget {
  const SplitList({Key? key}) : super(key: key);
  static const String routeName = '/SplitList';

  @override
  State<SplitList> createState() => _State();
}

class _State extends State<SplitList> {
  SplitWarpController controller = Get.put(SplitWarpController());
  List<dynamic> list = <dynamic>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
    _api();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplitWarpController>(builder: (controller) {
      // this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Adjustment / Split Warp'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api()),
            SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _add(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            // print(jsonEncode(item));
            // await Get.toNamed(AddSplitWarp.routeName,
            //     arguments: {"item": item});
            // dataSource.notifyListeners();
            _add(args: {'item': item});
          },
          columns: <GridColumn>[
            GridColumn(
              width: 80,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 100,
              columnName: 'date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'warp_design_name',
              label: const MyDataGridHeader(title: 'Warp Design'),
            ),
            GridColumn(
              columnName: 'warp_id_no',
              label: const MyDataGridHeader(title: 'Warp ID No'),
            ),
            GridColumn(
              width: 100,
              columnName: 'metre',
              label: const MyDataGridHeader(title: 'Mtr/Yrds'),
            ),
            GridColumn(
              columnName: 'empty_type',
              label: const MyDataGridHeader(title: 'Empty'),
            ),
            GridColumn(
              width: 100,
              columnName: 'empty_qty',
              label: const MyDataGridHeader(title: 'Empty Qty'),
            ),
            GridColumn(
              width: 100,
              columnName: 'total_ends',
              label: const MyDataGridHeader(title: 'Ends'),
            ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.splitWarp(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddSplitWarp.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api();
    }
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<dynamic> _list;

  // List<DataGridRow> dataGridRows = [];

  @override
//  List<DataGridRow> get rows => dataGridRows;
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'id', value: e['id']),
        DataGridCell(columnName: 'date', value: e['e_date']),
        DataGridCell(
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell(columnName: 'warp_id_no', value: e['warp_id_no']),
        DataGridCell(columnName: 'metre', value: e['metre']),
        DataGridCell(columnName: 'empty_type', value: e['empty_type']),
        DataGridCell(columnName: 'empty_qty', value: e['empty_qty']),
        DataGridCell(columnName: 'total_ends', value: e['total_ends']),
        DataGridCell(columnName: 'details', value: e['details']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          e.value != null ? '${e.value}' : '',
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
}
