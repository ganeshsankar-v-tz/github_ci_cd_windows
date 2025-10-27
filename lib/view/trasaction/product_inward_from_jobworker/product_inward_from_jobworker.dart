import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/add_product_inward_from_jobworker.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/jobWorker_inward_payment_details.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/product_inward_from_jobworker_controller.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/product_inward_from_jobworker_filter.dart';
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

class ProductInwardFromJobWorker extends StatefulWidget {
  const ProductInwardFromJobWorker({Key? key}) : super(key: key);
  static const String routeName = '/Product_Inward_FromJobWorker';

  @override
  State<ProductInwardFromJobWorker> createState() => _State();
}

class _State extends State<ProductInwardFromJobWorker> {
  ProductInwardFromJobWorkerController controller =
      Get.put(ProductInwardFromJobWorkerController());
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
    return GetBuilder<ProductInwardFromJobWorkerController>(
        builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Product Inward From JobWorker'),
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
            _add(args: {'item': item});
            // await Get.toNamed(AddProductInwardFromJobWorker.routeName,
            //     arguments: {"item": item});
          },
          columns: <GridColumn>[
            GridColumn(
              columnName: 'id',
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 110,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Inward Date'),
            ),
            GridColumn(
              width: 80,
              columnName: 'dc_no',
              label: const MyDataGridHeader(title: 'D.C No'),
            ),
            GridColumn(
              width: 80,
              columnName: 'ref_no',
              label: const MyDataGridHeader(title: 'Ref No'),
            ),
            GridColumn(
              columnName: 'job_worker_name',
              label: const MyDataGridHeader(title: 'JobWorker Name'),
            ),
            GridColumn(
              width: 120,
              columnName: 'qty',
              label: const MyDataGridHeader(title: 'Net.Qty'),
            ),
            GridColumn(
              width: 120,
              columnName: 'total_amount',
              label: const MyDataGridHeader(title: 'Net.Amount'),
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
    var response =
        await controller.productInwardFromJobWorker(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddProductInwardFromJobWorker.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api(request: controller.filterData ?? {});
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const ProductInwardFromJobWorkerFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }

  void _payDetails() async {
    showDialog(
      context: context,
      builder: (_) => const JobWorkerInwardPaymentDetails(),
    );
  }

  void _paymentScreen() async {
    var arg = {
      "firm_name": "A B TEX PRIVATE LIMITED",
      "payment_type": "JobWorker Amount",
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
        DataGridCell<dynamic>(columnName: 'e_date', value: '${e['e_date']}'),
        DataGridCell<dynamic>(columnName: 'dc_no', value: e['dc_no']),
        DataGridCell<dynamic>(columnName: 'ref_no', value: e['ref_no']),
        DataGridCell<dynamic>(
            columnName: 'job_worker_name', value: e['job_worker_name']),
        DataGridCell<int>(columnName: 'qty', value: e['qty']),
        DataGridCell<dynamic>(
            columnName: 'total_amount', value: e['total_amount']),
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
        /*case 'qty':
              return buildFormattedCell(value, decimalPlaces: 0);*/
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
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        summaryValue,
        style: AppUtils.footerTextStyle(),
      ),
    );
  }
}
