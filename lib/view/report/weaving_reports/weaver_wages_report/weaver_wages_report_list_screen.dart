import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/weaving_reports/weaver_wages_report/weaver_wages_report_filter.dart';
import 'package:abtxt/view/report/weaving_reports/weaver_wages_report/weaver_wages_reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../widgets/MyDataGridHeader.dart';
import '../../../../widgets/MyFilterIconButton.dart';
import '../../../../widgets/MySFDataGridRawTable.dart';


class WeaverWagesReportList extends StatefulWidget {
  const WeaverWagesReportList({Key? key}) : super(key: key);
  static const String routeName = '/WeaverWagesList';

  @override
  State<WeaverWagesReportList> createState() => _State();
}

class _State extends State<WeaverWagesReportList> {
  WeaverWagesListReportController controller =
  Get.put(WeaverWagesListReportController());
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
    return GetBuilder<WeaverWagesListReportController>(builder: (controller) {
      this.controller = controller;
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Weaver Wages Report'),
          actions: [
            MyFilterIconButton(onPressed: () => _filter()),
            SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
        },
        child: MySFDataGridRawTable(
          source: dataSource,
          isLoading: controller.status.isLoading,
          onRowSelected: (index) async {},
          columns: [
            GridColumn(
              columnName: 'id',
              width: 80,
              label: const MyDataGridHeader(title: 'ID'),
            ),
            GridColumn(
              width: 120,
              columnName: 'date',
              label: const MyDataGridHeader(title: 'Empty Column'),
            ),
            GridColumn(
              width: 120,
              columnName: 'bill_no',
              label: const MyDataGridHeader(title: 'Weaver Name'),
            ),
            GridColumn(
              columnName: 'firm_name',
              label: const MyDataGridHeader(title: 'Name'),
            ),
            GridColumn(
              columnName: 'customer_name',
              label: const MyDataGridHeader(title: 'A/C No'),
            ),
            GridColumn(
              columnName: 'net_total',
              label: const MyDataGridHeader(title: 'IFSC'),
            ),
            GridColumn(
              columnName: 'box_no',
              label: const MyDataGridHeader(title: 'Amount'),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.weaverWages(request: request);
    list.clear();
    list.addAll(response);
    dataSource.updateDataGridRows();
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const WeaverWagesReport(),
    );
    result != null ? _api(request: result ?? {}) : '';;
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
            columnName: 'sales_date', value: '${e['sales_date']}'),
        DataGridCell<dynamic>(columnName: 'bill_no', value: e['bill_no']),
        DataGridCell<dynamic>(columnName: 'firm_name', value: e['firm_name']),
        DataGridCell<dynamic>(
            columnName: 'customer_name', value: e['customer_name']),
        DataGridCell<dynamic>(columnName: 'net_total', value: e['net_total']),
        DataGridCell<dynamic>(columnName: 'box_no', value: e['box_no']),
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
            child: Text(e.value.toString()),
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
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
