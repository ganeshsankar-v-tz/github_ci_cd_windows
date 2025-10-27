import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/add_warp_delivery_to_dyer.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_deliver_to_dyer_filter.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer_controller.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

class WarpDeliveryToDyer extends StatefulWidget {
  const WarpDeliveryToDyer({super.key});

  static const String routeName = '/WarpDeliveryToDyer';

  @override
  State<WarpDeliveryToDyer> createState() => _State();
}

class _State extends State<WarpDeliveryToDyer> {
  WarpDeliveryToDyerController controller =
      Get.put(WarpDeliveryToDyerController());
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
    return GetBuilder<WarpDeliveryToDyerController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction /  Warp Delivery To Dyer'),
          actions: [
            MyRefreshIconButton(
                onPressed: () => _api(request: controller.filterData ?? {})),
            const SizedBox(width: 12),
            MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}"),
            const SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            const SizedBox(width: 12)
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
              _add(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(request: controller.filterData ?? {}),
        },
        child: MySFDataGridRawTable(
          selectionMode: SelectionMode.single,
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {'item': item});
          },
          columns: [
            GridColumn(
              columnName: 'id',
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 120,
              columnName: 'dc_no',
              label: const MyDataGridHeader(title: 'No'),
            ),
            GridColumn(
              width: 280,
              columnName: 'dyer_name',
              label: const MyDataGridHeader(title: 'Dyer Name'),
            ),
            GridColumn(
              columnName: 'delivered_warps',
              label: const MyDataGridHeader(title: 'Deli Warps'),
            ),
            GridColumn(
              columnName: 'inward_warps',
              label: const MyDataGridHeader(title: 'Rcd Warps'),
            ),
            GridColumn(
              columnName: 'balance_warps',
              label: const MyDataGridHeader(title: 'Bal Warps'),
            ),
            GridColumn(
              columnName: 'warp_checker_name',
              label: const MyDataGridHeader(title: 'Checker Name'),
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
    var response = await controller.paginatedList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddWarpDeliveryToDyer.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WarpDeliverToDyerFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _employeeData = [];
  late List<dynamic> _list;

  @override
  List<DataGridRow> get rows => _employeeData;

  void updateDataGridRows() {
    _employeeData = _list.map<DataGridRow>((e) {
      int balanceWarps = 0;
      int deliveredWarps = 0;
      int inwardWarpsWarps = 0;
      if (e["delivery_warps"] != null) {
        deliveredWarps = e["delivery_warps"];
      }
      if (e["inward_warps"] != null) {
        inwardWarpsWarps = e["inward_warps"];
      }
      balanceWarps = deliveredWarps - inwardWarpsWarps;

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e['e_date']}'),
        DataGridCell<dynamic>(columnName: 'dc_no', value: e['dc_no']),
        DataGridCell<dynamic>(columnName: 'dyar_name', value: e['dyar_name']),
        DataGridCell<dynamic>(
            columnName: 'delivery_warps', value: deliveredWarps),
        DataGridCell<dynamic>(
            columnName: 'inward_warps', value: inwardWarpsWarps),
        DataGridCell<dynamic>(columnName: 'balance_warps', value: balanceWarps),
        DataGridCell<dynamic>(
            columnName: 'warp_checker_name', value: e["warp_checker_name"]),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
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
