import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_inward_from_process/add_product_inward_from_process.dart';
import 'package:abtxt/view/trasaction/product_inward_from_process/processor_inward_payment_details.dart';
import 'package:abtxt/view/trasaction/product_inward_from_process/product_inward_from_process_controller.dart';
import 'package:abtxt/view/trasaction/product_inward_from_process/product_inward_from_process_filter.dart';
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
import '../payment_v2/add_payment_v2.dart';

class ProductInwardFromProcess extends StatefulWidget {
  const ProductInwardFromProcess({Key? key}) : super(key: key);
  static const String routeName = '/Product_Inward_From_Process';

  @override
  State<ProductInwardFromProcess> createState() => _State();
}

class _State extends State<ProductInwardFromProcess> {
  ProductInwardFromProcessController controller =
      Get.put(ProductInwardFromProcessController());
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
    return GetBuilder<ProductInwardFromProcessController>(
        builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Product Inward From Process'),
          actions: [
            MyRefreshIconButton(onPressed: () => _api(request: controller.filterData ?? {})),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Payment Details (Shift+P)',
              child: ElevatedButton(
                onPressed: () {
                  _payDetails();
                },
                child: const Text("Payment Details"),
              ),
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: 'Payment (Ctrl+P)',
              child: ElevatedButton(
                onPressed: () {
                  _paymentScreen();
                },
                child: const Text("Payment"),
              ),
            ),
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
          const SingleActivator(LogicalKeyboardKey.keyP, shift: true): () =>
              _payDetails(),
          const SingleActivator(LogicalKeyboardKey.keyR, shift: true): () =>
              _api(request: controller.filterData ?? {}),
          const SingleActivator(LogicalKeyboardKey.keyP, control: true): () =>
              _paymentScreen(),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            // await Get.toNamed(AddProductInwardFromProcess.routeName,
            //     arguments: {"item": item});
            _add(args: {'item': item});
          },
          columns: <GridColumn>[
            GridColumn(
              columnName: 'id',
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 105,
              columnName: 'date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              width: 120,
              columnName: 'dc_no',
              label: const MyDataGridHeader(title: 'DC No'),
            ),
            GridColumn(
              width: 210,
              columnName: 'firm',
              label: const MyDataGridHeader(title: 'Firm'),
            ),
            GridColumn(
              width: 250,
              columnName: 'processor_name',
              label: const MyDataGridHeader(title: 'Processor Name'),
            ),
            GridColumn(
              width: 120,
              columnName: 'ref_no',
              label: const MyDataGridHeader(title: 'Ref No'),
            ),
            GridColumn(
              width: 120,
              columnName: 'quantity',
              label: const MyDataGridHeader(title: 'Qty'),
            ),
            GridColumn(
              width: 120,
              columnName: 'total_wages',
              label: const MyDataGridHeader(title: 'Wages (Rs)'),
            ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
          ],
          tableSummaryColumns: const [
            GridSummaryColumn(
              name: 'total_wages',
              columnName: 'total_wages',
              summaryType: GridSummaryType.sum,
            ),
            GridSummaryColumn(
              name: 'quantity',
              columnName: 'quantity',
              summaryType: GridSummaryType.sum,
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.productInwardFromProcess(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddProductInwardFromProcess.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const ProductInwardFromProcessFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
    ;
  }

  void _payDetails() async {
    showDialog(
      context: context,
      builder: (_) => const ProcessorInwardPaymentDetails(),
    );
  }

  void _paymentScreen() async {
    var arg = {
      "firm_name": "A B TEX PRIVATE LIMITED",
      "payment_type": "Processor Amount",
    };

    Get.toNamed(AddPaymentV2.routeName, arguments: arg);
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
        DataGridCell<dynamic>(columnName: 'date', value: '${e['e_date']}'),
        DataGridCell<int>(columnName: 'dc_no', value: e['dc_no']),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e['firm_name']),
        DataGridCell<dynamic>(
            columnName: 'processor_name', value: e['processor_name']),
        DataGridCell<dynamic>(columnName: 'ref_no', value: e['ref_no']),
        DataGridCell<int>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<int>(columnName: 'total_wages', value: e['total_wages']),
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
        case 'total_wages':
          return buildFormattedCell(value, decimalPlaces: 2);
        /* case 'quantity':
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
      case 'total_wages':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 2, alignment: alignment);
      case 'quantity':
        alignment = TextAlign.left;
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
