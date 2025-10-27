import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/warp_inward/add_warp_inward.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward_controller.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAddItemButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';

class WarpInward extends StatefulWidget {
  const WarpInward({super.key});

  static const String routeName = '/WarpInward';

  @override
  State<WarpInward> createState() => _State();
}

class _State extends State<WarpInward> {
  WarpInwardController controller = Get.put(WarpInwardController());
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
    return GetBuilder<WarpInwardController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Warp Inward'),
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
            const SizedBox(width: 12),
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
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {'item': item});
          },
          columns: <GridColumn>[
            GridColumn(
              visible: false,
              width: 70,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 140,
              columnName: 'warp_id',
              label: const MyDataGridHeader(title: 'Warp ID'),
            ),
            GridColumn(
              width: 150,
              columnName: 'warper_name',
              label: const MyDataGridHeader(title: 'Warper Name'),
            ),
            GridColumn(
              width: 60,
              columnName: 'metre',
              label: const MyDataGridHeader(
                  alignment: Alignment.centerRight, title: 'Mtr'),
            ),
            GridColumn(
              width: 300,
              columnName: 'warp_design_name',
              label: const MyDataGridHeader(title: 'Warp Design'),
            ),
            GridColumn(
              width: 110,
              columnName: 'warping_wages',
              label: const MyDataGridHeader(title: 'Warping(Rs)'),
            ),
            GridColumn(
              width: 90,
              columnName: 'total_wages',
              label: const MyDataGridHeader(title: 'Total(Rs)'),
            ),
            GridColumn(
              width: 300,
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
            GridColumn(
              width: 150,
              columnName: 'weaver_name',
              label: const MyDataGridHeader(title: 'Weaver Name'),
            ),
            GridColumn(
              width: 65,
              columnName: 'loom_no',
              label: const MyDataGridHeader(title: 'Loom'),
            ),
            GridColumn(
              width: 200,
              columnName: 'firm_name',
              label: const MyDataGridHeader(title: 'Firm'),
            ),
            GridColumn(
              width: 100,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'Record No'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.warpInward(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddWarpInward.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WarpInwardFilter(),
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
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(
            columnName: 'entry_date', value: '${e['e_date']}'),
        DataGridCell<dynamic>(columnName: 'warp_id', value: e['warp_id']),
        DataGridCell<dynamic>(
            columnName: 'warper_name', value: e['warper_name']),
        DataGridCell<int>(columnName: 'metre', value: e['metre']),
        DataGridCell<dynamic>(
            columnName: 'warp_design_name', value: e['warp_design_name']),
        DataGridCell<int>(
            columnName: 'warping_wages', value: e['warping_wages']),
        DataGridCell<int>(columnName: 'total_wages', value: e['total_wages']),
        DataGridCell<String>(columnName: 'details', value: e['details']),
        DataGridCell<String>(
            columnName: 'weaver_name', value: e['weaver_name']),
        DataGridCell<String>(columnName: 'loon_no', value: e['loom_no']),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e['firm_name']),
        DataGridCell<int>(columnName: 'id', value: e['id']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      double value = double.tryParse('${e.value}') ?? 0;
      final columnName = e.columnName;
      switch (columnName) {
        case 'warping_wages':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'total_wages':
          return buildFormattedCell(value, decimalPlaces: 2);
        default:
          return Container(
            alignment: columnName == "metre"
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value != null ? '${e.value}' : '',
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
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        summaryValue,
        style: AppUtils.footerTextStyle(),
      ),
    );
  }
}
