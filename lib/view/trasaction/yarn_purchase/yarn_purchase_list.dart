import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_filter.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:abtxt/widgets/MyFilterIconButton.dart';
import 'package:abtxt/widgets/MyRefreshButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_yarn_purchase.dart';
import 'yarn_purchase_controller.dart';

class YarnPurchase extends StatefulWidget {
  const YarnPurchase({super.key});

  static const String routeName = '/YarnPurchaseList';

  @override
  State<YarnPurchase> createState() => _State();
}

class _State extends State<YarnPurchase> {
  YarnPurchaseController controller = Get.put(YarnPurchaseController());
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
    return GetBuilder<YarnPurchaseController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Yarn Purchase'),
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
          columns: [
            GridColumn(
              columnName: 'id',
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'purchase_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 110,
              columnName: 'dc_inv_no',
              label: const MyDataGridHeader(title: 'D.C/Inv No'),
            ),
            GridColumn(
              width: 215,
              columnName: 'supplier',
              label: const MyDataGridHeader(title: 'Supplier'),
            ),
            GridColumn(
              width: 210,
              columnName: 'firm',
              label: const MyDataGridHeader(title: 'Firm'),
            ),
            GridColumn(
              width: 115,
              columnName: 'net_total',
              label: const MyDataGridHeader(title: 'Net Amount'),
            ),
            GridColumn(
              width: 60,
              columnName: 'pack',
              label: const MyDataGridHeader(title: 'Pack'),
            ),
            GridColumn(
              width: 80,
              columnName: 'slip_no',
              label: const MyDataGridHeader(title: 'Slip No'),
            ),
            GridColumn(
              width: 100,
              columnName: 'net_qty',
              label: const MyDataGridHeader(title: 'Net Qty'),
            ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
          ],
          tableSummaryColumns: const [
            GridSummaryColumn(
              name: 'net_total',
              columnName: 'net_total',
              summaryType: GridSummaryType.sum,
            ),
            GridSummaryColumn(
              name: 'pack',
              columnName: 'pack',
              summaryType: GridSummaryType.sum,
            ),
            GridSummaryColumn(
              name: 'net_qty',
              columnName: 'net_qty',
              summaryType: GridSummaryType.sum,
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.yarnPurchase(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    if (list.isNotEmpty) {
      controller.supplierName = list.first["supplier_name"];
    } else {
      controller.supplierName = "";
    }

    var result = await Get.toNamed(AddYarnPurchase.routeName, arguments: args);
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const YarnPurchaseFilter(),
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
            columnName: 'purchase_date', value: '${e['purchase_date']}'),
        DataGridCell<dynamic>(columnName: 'dc_inv_no', value: e['invoice_no']),
        DataGridCell<dynamic>(
            columnName: 'supplier', value: e['supplier_name']),
        DataGridCell<dynamic>(columnName: 'firm', value: e['firm_name']),
        DataGridCell<dynamic>(columnName: 'net_total', value: e['net_total']),
        DataGridCell<dynamic>(columnName: 'pack', value: e['pack']),
        DataGridCell<dynamic>(columnName: 'slip_no', value: e['slip_no']),
        DataGridCell<dynamic>(columnName: 'net_qty', value: e['net_qty']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
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
        case 'net_total':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'net_qty':
          return buildFormattedCell(value, decimalPlaces: 3);
        default:
          return Container(
            alignment: Alignment.centerLeft,
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
    final columnName = summaryColumn?.columnName;
    double parsedValue = double.tryParse(summaryValue) ?? 0;
    TextAlign alignment;

    switch (columnName) {
      case 'net_total':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'net_qty':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);
      default:
        alignment = TextAlign.left;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 0, alignment: alignment);
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
}
