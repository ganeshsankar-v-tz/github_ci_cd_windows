import 'dart:math';

import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/trasaction/payment/payment_controller.dart';
import 'package:abtxt/view/trasaction/payment/payment_filter.dart';
import 'package:abtxt/widgets/MyAddItemButton.dart';
import 'package:abtxt/widgets/MyFilterIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MySFDataGridRawTable.dart';
import 'add_payment.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);
  static const String routeName = '/PaymentList';

  @override
  State<Payment> createState() => _State();
}

class _State extends State<Payment> {
  PaymentController controller = Get.put(PaymentController());
  final _formKey = GlobalKey<FormState>();
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
    return GetBuilder<PaymentController>(builder: (controller) {
      //return GetBuilder(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Transaction / Payment'),
          actions: [
            MyFilterIconButton(onPressed: () => _filter()),
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
              _filter()
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {
            var item = list[index];
            _add(args: {'item': item});
            // await Get.toNamed(AddPayment.routeName, arguments: {"item": item});
            // dataSource.notifyListeners();
          },
          columns: <GridColumn>[
            GridColumn(
              columnName: 'id',
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 120,
              columnName: 'e_date',
              label: const MyDataGridHeader(title: 'Date'),
            ),
            GridColumn(
              columnName: 'slip_no',
              label: const MyDataGridHeader(title: 'Slip No'),
            ),
            GridColumn(
              columnName: 'firm',
              label: const MyDataGridHeader(title: 'Firm'),
            ),
            GridColumn(
              columnName: 'ledger_name',
              label: const MyDataGridHeader(title: 'By Ledger Name'),
            ),
            GridColumn(
              columnName: 'debit_amount',
              label: const MyDataGridHeader(title: 'Debit(Rs)'),
            ),
            GridColumn(
              columnName: 'details',
              label: const MyDataGridHeader(title: 'Details'),
            ),
            GridColumn(
              columnName: 'against',
              label: const MyDataGridHeader(title: 'Against'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.payments(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _add({Map<String, dynamic>? args}) async {
    var result = await Get.toNamed(
      AddPayment.routeName,
      arguments: args,
    );
    if (result == 'success') {
      _api();
    }
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const PaymentFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';;
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> _data = [];
  late List<dynamic> _list;

  @override
  List<DataGridRow> get rows => _data;

  void updateDataGridRows() {
    _data = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'id', value: e['id']),
        DataGridCell<dynamic>(columnName: 'e_date', value: e['e_date']),
        DataGridCell<dynamic>(columnName: 'slip_no', value: e['slip_no']),
        DataGridCell<dynamic>(columnName: 'firm', value: e['firm_name']),
        DataGridCell<dynamic>(
            columnName: 'ledger_name', value: e['ledger_name']),
        DataGridCell<dynamic>(
            columnName: 'debit_amount', value: e['debit_amount']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
        DataGridCell<dynamic>(columnName: 'against', value: e['against']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value != null ? '${e.value}' : ''),
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
        '${summaryValue}',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
