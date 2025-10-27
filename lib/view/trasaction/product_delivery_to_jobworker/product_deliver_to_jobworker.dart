import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/add_product_deliver_to_jobworker.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/product_deliver_to_jobworker_controller.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/product_delivery_to_jobworker_filter.dart';
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

class ProductDeliverToJobWorker extends StatefulWidget {
  const ProductDeliverToJobWorker({Key? key}) : super(key: key);
  static const String routeName = '/Product_Deliver_To_JobWorker';

  @override
  State<ProductDeliverToJobWorker> createState() => _State();
}

class _State extends State<ProductDeliverToJobWorker> {
  ProductDeliverToJobWorkerController controller =
      Get.put(ProductDeliverToJobWorkerController());
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
    return GetBuilder<ProductDeliverToJobWorkerController>(
        builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Product Deliver To JobWorker'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api(request: controller.filterData ?? {})),
            SizedBox(width: 12),
            MyFilterIconButton(
                onPressed: () => _filter(),
                filterIcon: controller.filterData != null ? true : false,
                tooltipText: "${controller.filterData}"),
            SizedBox(width: 12),
            MyAddItemButton(onPressed: () => _add()),
            SizedBox(width: 12),
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
            // await Get.toNamed(AddProductDeliverToJobWorker.routeName,
            //     arguments: {"item": item});
            // dataSource.notifyListeners();
          },
          columns: <GridColumn>[
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
              width: 250,
              columnName: 'firm_name',
              label: const MyDataGridHeader(title: 'Firm'),
            ),
            GridColumn(
              width: 130,
              columnName: 'dc_no',
              label: const MyDataGridHeader(title: 'D.C No'),
            ),
            GridColumn(
              width: 250,
              columnName: 'job_worker_name',
              label: const MyDataGridHeader(title: 'JobWorker Name'),
            ),
            GridColumn(
              width: 130,
              columnName: 'net_total',
              label: const MyDataGridHeader(title: 'Net.Amount'),
            ),
            GridColumn(
              width: 130,
              columnName: 'total_delivery_qty',
              label: const MyDataGridHeader(title: 'Delivered Qty'),
            ),
            GridColumn(
              width: 130,
              columnName: 'total_inward_qty',
              label: const MyDataGridHeader(title: 'Inward Qty'),
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
            /* GridSummaryColumn(
              name: 'total_delivery_qty',
              columnName: 'total_delivery_qty',
              summaryType: GridSummaryType.sum,
            ),*/
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.productDeliverToJobWorker(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddProductDeliverToJobWorker.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const ProductDeliverytoJobWorkerFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
    ;
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
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e['e_date']}'),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e['firm_name']),
        DataGridCell<int>(columnName: 'dc_no', value: e['dc_no']),
        DataGridCell<dynamic>(
            columnName: 'job_worker_name', value: e['job_worker_name']),
        DataGridCell<int>(columnName: 'net_total', value: e['net_total']),
        DataGridCell<int>(
            columnName: 'total_delivery_qty', value: e['total_delivery_qty']),
        DataGridCell<int>(
            columnName: 'total_inward_qty', value: e['total_inward_qty']),
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
        /*  case 'total_delivery_qty':
              return buildFormattedCell(value, decimalPlaces: 3);
            case 'total_inward_qty':
              return buildFormattedCell(value, decimalPlaces: 3);*/
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
      /* case 'total_delivery_qty':
        alignment = TextAlign.left;
        return _buildFormattedCell(parsedValue, decimalPlaces: 3,alignment: alignment);*/
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
