import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_winder/yarn_deliver_to_winder_filter.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_winder/yarn_delivery_to_winder_controller.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_yarn_delivery_to_winder.dart';

class YarnDeliveryToWinder extends StatefulWidget {
  const YarnDeliveryToWinder({Key? key}) : super(key: key);
  static const String routeName = '/yarn_delivery_to_winder_list';

  @override
  State<YarnDeliveryToWinder> createState() => _State();
}

class _State extends State<YarnDeliveryToWinder> {
  YarnDeliveryToWinderController controller =
      Get.put(YarnDeliveryToWinderController());
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
    return GetBuilder<YarnDeliveryToWinderController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Yarn Delivery To Winder'),
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
              width: 80,
              columnName: 'id',
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 100,
              columnName: 'dc_no',
              label: const MyDataGridHeader(title: 'D.C No'),
            ),
            GridColumn(
              width: 250,
              columnName: 'winder_name',
              label: const MyDataGridHeader(title: 'Winder Name'),
            ),
            GridColumn(
              width: 250,
              columnName: 'wages_account_type',
              label: const MyDataGridHeader(title: 'Wages Account'),
            ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
            GridColumn(
              width: 80,
              columnName: 'total_pack',
              label: const MyDataGridHeader(title: 'Pack'),
            ),
            GridColumn(
              width: 120,
              columnName: 'total_qty',
              label: const MyDataGridHeader(title: 'Qty'),
            ),
            GridColumn(
              width: 120,
              columnName: 'amount',
              label: const MyDataGridHeader(title: 'Amount(Rs)'),
            ),
            GridColumn(
              width: 100,
              columnName: 'wages_status',
              label: const MyDataGridHeader(title: 'Wages Sts'),
            ),
          ],
          tableSummaryColumns: const [
            GridSummaryColumn(
              name: 'total_qty',
              columnName: 'total_qty',
              summaryType: GridSummaryType.sum,
            ),
            GridSummaryColumn(
              name: 'amount',
              columnName: 'amount',
              summaryType: GridSummaryType.sum,
            ),
            GridSummaryColumn(
              name: 'total_pack',
              columnName: 'total_pack',
              summaryType: GridSummaryType.sum,
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.yarnDelivery(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddDeliveryWinder.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const YarnDeliverToWinderFilter(),
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
        DataGridCell<dynamic>(columnName: 'e_date', value: e['e_date']),
        DataGridCell<dynamic>(columnName: 'dc_no', value: e['dc_no']),
        DataGridCell<dynamic>(
            columnName: 'winder_name', value: e['winder_name']),
        DataGridCell<dynamic>(
            columnName: 'wages_account_type', value: e['wages_account_type']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
        DataGridCell<dynamic>(columnName: 'total_pack', value: e['total_pack']),
        DataGridCell<dynamic>(columnName: 'total_qty', value: e['total_qty']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
        DataGridCell<dynamic>(
            columnName: 'wages_status', value: e['wages_status']),
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
        case 'amount':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'total_qty':
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
      case 'amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'total_qty':
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
