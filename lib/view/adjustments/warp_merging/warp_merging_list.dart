import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/adjustments/warp_merging/warp_merging_controller.dart';
import 'package:abtxt/view/adjustments/warp_merging/warp_merging_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_warp_merging.dart';

class WarpMerging extends StatefulWidget {
  const WarpMerging({Key? key}) : super(key: key);
  static const String routeName = '/warp_merging';

  @override
  State<WarpMerging> createState() => _State();
}

class _State extends State<WarpMerging> {
  WarpMergingController controller = Get.put(WarpMergingController());
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
    return GetBuilder<WarpMergingController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Adjustment / Warp Merging'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api()),
            SizedBox(width: 12),
            MyFilterIconButton(onPressed: () => _filter()),
            const SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            const SizedBox(width: 12),
          ],
        ),
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _add(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(),
        },
        loadingStatus: controller.status.isLoading,
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {'item': item});
          },
          columns: <GridColumn>[
            GridColumn(
              width: 80,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'warp_design_name',
              label: const MyDataGridHeader(title: 'Warp Design'),
            ),
            GridColumn(
              columnName: 'wrap_no_id',
              label: const MyDataGridHeader(title: 'Warp ID No'),
            ),
            GridColumn(
              width: 100,
              columnName: 'prod_qty',
              label: const MyDataGridHeader(title: 'Qty'),
            ),
            GridColumn(
              columnName: 'metre',
              label: const MyDataGridHeader(title: 'Metre Yards'),
            ),
            // GridColumn(
            //   columnName: 'wrap_no_id',
            //   label: const MyDataGridHeader(title: 'Beam'),
            // ),
            // GridColumn(
            //   columnName: 'wrap_no_id',
            //   label: const MyDataGridHeader(title: 'Bbn'),
            // ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
            // GridColumn(
            //   columnName: 'warpColor',
            //   label: const MyDataGridHeader(title: 'Warp Colours'),
            // ),

            //
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.warpMerging(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddWarpMerging.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api();
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WarpMergingFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];
  late List<dynamic> _list;

  @override
  List<DataGridRow> get rows => dataGridRows;

  void updateDataGridRows() {
    dataGridRows = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'id', value: e['id']),
        DataGridCell(columnName: 'date', value: e['e_date']),
        DataGridCell(
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell(columnName: 'wrap_no_id', value: e['warp_id_no']),
        DataGridCell(columnName: 'prod_qty', value: e['prod_qty']),
        DataGridCell(columnName: 'metre', value: e['metre']),
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
