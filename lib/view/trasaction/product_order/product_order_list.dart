import 'package:abtxt/view/trasaction/product_order/product_order_controller.dart';
import 'package:abtxt/view/trasaction/product_order/product_order_filter.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../flutter_core_widget.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import '../../../widgets/MyRefreshButton.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import '../product_sales_calender_view/product_sales_calender_view.dart';
import 'add_product_order.dart';

class ProductOrderList extends StatefulWidget {
  const ProductOrderList({super.key});

  static const String routeName = '/product_order_list';

  @override
  State<ProductOrderList> createState() => _State();
}

class _State extends State<ProductOrderList> {
  ProductOrderController controller = Get.put(ProductOrderController());
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
    return GetBuilder<ProductOrderController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Product Order'),
          actions: [
            Visibility(
              visible: false,
              child: TextButton(
                onPressed: () => Get.toNamed(ProductSalesCalenderView.routeName),
                child: const Text("Calender View"),
              ),
            ),
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
              width: 60,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              columnName: 'firm_name',
              label: const MyDataGridHeader(title: 'Firm'),
            ),
            GridColumn(
              columnName: 'customer_name',
              label: const MyDataGridHeader(title: 'Customer Name'),
            ),
            GridColumn(
              width: 140,
              columnName: 'order_no',
              label: const MyDataGridHeader(title: 'Oder No'),
            ),
            GridColumn(
              width: 120,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Order Date'),
            ),
            GridColumn(
              columnName: 'transport',
              label: const MyDataGridHeader(title: 'Transport'),
            ),
            GridColumn(
              width: 140,
              columnName: 'total_amount',
              label: const MyDataGridHeader(
                  alignment: Alignment.center, title: 'Total Amount'),
            ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
          ],
          tableSummaryColumns: const [
            GridSummaryColumn(
              name: 'total_amount',
              columnName: 'total_amount',
              summaryType: GridSummaryType.sum,
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.productOrderList(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(AddProductOrder.routeName, arguments: args);
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const ProductOrderFilter(),
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
      double totalAmount = 0.0;

      for (var e in e["product_order_details"]) {
        totalAmount += double.tryParse("${e["total_amount"]}") ?? 0.0;
      }

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e['firm_name']),
        DataGridCell<dynamic>(
            columnName: 'customer_name', value: e['customer_name']),
        DataGridCell<dynamic>(columnName: 'order_no', value: e['order_no']),
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e['e_date']}'),
        DataGridCell<dynamic>(columnName: 'transport', value: e['transport']),
        DataGridCell<dynamic>(columnName: 'total_amount', value: totalAmount),
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
        case 'total_amount':
          return buildFormattedCell(value, decimalPlaces: 2);
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
      case 'total_amount':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
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
      child: Text(
        formatter.format(value),
        style: AppUtils.footerTextStyle(),
        textAlign: alignment,
      ),
    );
  }
}
